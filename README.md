## Комп'ютерний практикум №6: Використання мови SQL для роботи з об’єктами предметної області в IRIS

### Завдання

Додати запити в класи з комп’ютерного практикуму №5. Принаймні один з
них повинен приймати параметр. Принаймні один з них має бути типу %Query.
Використати динамічний запит та обидва види вбудованого SQL для виконання дій
в методах. Показати роботу з оператором &quot;-&gt;&quot;. Створити для будь-якого класу
тригер і написати програму для демонстрації його роботи. Всі методи повинні мати
сенс.

### Реалізовані компоненти

#### 1. SQL-запити (%SQLQuery)

### Transport.Vehicle

**GetVehiclesByBrand(brandName As %String)** - запит з параметром та оператором `->`

```sql
SELECT %ID, Brand, Model, VIN, Year, Color,
       Owner->Name As OwnerName,
       Owner->Email As OwnerEmail,
       Owner->Phone As OwnerPhone
FROM Transport.Vehicle
WHERE Brand = :brandName
ORDER BY Year DESC
```

**GetVehiclesWithOwners()** - запит з оператором `->`

```sql
SELECT %ID, Brand, Model, VIN, Year, Color, CurrentMileage,
       Owner->Name As OwnerName,
       Owner->Email As OwnerEmail
FROM Transport.Vehicle
ORDER BY Owner->Name, Brand
```

### Transport.Owner

**GetOwnersByName(namePattern As %String)** - запит з параметром

```sql
SELECT %ID, Id, Name, Email, Phone
FROM Transport.Owner
WHERE Name %STARTSWITH :namePattern
ORDER BY Name
```

### Transport.ServiceRecord

**GetServiceHistoryByVehicle(vehicleId As %Integer)** - запит з параметром та оператором `->`

```sql
SELECT %ID, ServiceDate, Description, Cost, PerformedBy, Mileage,
       Vehicle->Brand As VehicleBrand,
       Vehicle->Model As VehicleModel,
       Vehicle->VIN As VehicleVIN
FROM Transport.ServiceRecord
WHERE Vehicle = :vehicleId
ORDER BY ServiceDate DESC
```

**GetExpensiveServices(minCost As %Numeric)** - запит з параметром та оператором `->`

```sql
SELECT %ID, ServiceDate, Description, Cost, PerformedBy,
       Vehicle->Brand As VehicleBrand,
       Vehicle->Model As VehicleModel,
       Vehicle->Owner->Name As OwnerName
FROM Transport.ServiceRecord
WHERE Cost >= :minCost
ORDER BY Cost DESC
```

#### 2. Запит типу %Query (COS)

**Transport.Owner.GetOwnersWithVehicleCount()** - запит на основі COS з курсором

Цей запит демонструє використання вбудованого SQL з курсором для обчислення кількості транспортних засобів для кожного власника.

**Приклад використання:**

```objectscript
Set resultSet = ##class(%ResultSet).%New("Transport.Owner:GetOwnersWithVehicleCount")
Set sc = resultSet.Execute()
While resultSet.%Next() {
    Write resultSet.Data("OwnerName")_" - "_resultSet.Data("VehicleCount")_" транспортів",!
}
```

#### 3. Вбудований SQL (прості вирази)

**Transport.Vehicle**

- `CountByBrand(brandName As %String)` - підрахунок транспортних засобів за маркою
- `GetAverageMileageByBrand(brandName As %String)` - середній пробіг для марки

**Transport.ServiceRecord**

- `CountServicesByPeriod(startDate As %Date, endDate As %Date)` - підрахунок записів обслуговування за період
- `GetTotalServiceCostByVehicle(vehicleId As %Integer)` - загальна вартість обслуговування для транспортного засобу

**Приклад використання:**

```objectscript
Set count = ##class(Transport.Vehicle).CountByBrand("Toyota")
Set avgMileage = ##class(Transport.Vehicle).GetAverageMileageByBrand("Toyota")
Write "Кількість: "_count_", Середній пробіг: "_avgMileage_" км",!
```

#### 4. Вбудований SQL (курсори)

Вбудований SQL з курсорами використовується в методі `DemoEmbeddedSQLCursor()` класу `Transport.SQLDemo` для обробки множини рядків.

**Приклад використання:**

```objectscript
&sql(DECLARE VehicleMileageCursor CURSOR FOR
    SELECT %ID, Brand, Model, VIN, CurrentMileage, Owner->Name As OwnerName
    INTO :vehicleId, :brand, :model, :vin, :mileage, :ownerName
    FROM Transport.Vehicle
    WHERE CurrentMileage > 1000
    ORDER BY CurrentMileage DESC
)
&sql(OPEN VehicleMileageCursor)
For {
    &sql(FETCH VehicleMileageCursor)
    Quit:SQLCODE'=0
    Write brand_" "_model_" - "_mileage_" км",!
}
&sql(CLOSE VehicleMileageCursor)
```

#### 5. Динамічний SQL

Використано клас `%SQL.Statement` для виконання динамічних SQL-запитів. Демонстрація в методі `DemoDynamicSQL()` класу `Transport.SQLDemo`.

**Приклад використання:**

```objectscript
Set query = "SELECT Brand, Model, Year "_
            "FROM Transport.Vehicle "_
            "WHERE Year >= ? "_
            "ORDER BY Year DESC"
Set statement = ##class(%SQL.Statement).%New()
Set sc = statement.%Prepare(query)
Set resultSet = statement.%Execute(minYear)
While resultSet.%Next() {
    Write resultSet.Brand_" "_resultSet.Model_" ("_resultSet.Year_")",!
}
```

#### 6. Оператор "->"

Оператор `->` використовується для доступу до властивостей пов'язаних об'єктів у SQL-запитах:

- `Owner->Name` - доступ до імені власника
- `Owner->Email` - доступ до email власника
- `Vehicle->Brand` - доступ до марки транспортного засобу
- `Vehicle->Owner->Name` - ланцюговий доступ (через Vehicle до Owner)

#### 7. Тригер

**Transport.Owner.LogOwnerChanges** - тригер для логування змін власників

Тригер спрацьовує при операціях `INSERT` та `UPDATE` і зберігає інформацію про зміни в глобал `^Transport.OwnerLog`.

**Структура тригера:**

```objectscript
Trigger LogOwnerChanges [ Event = INSERT/UPDATE, Foreach = row/object, Time = AFTER ]
{
    Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "Name") = {Name*N}
    Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "Email") = {Email*N}
    Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "Phone") = {Phone*N}
    If {%%OPERATION} = "UPDATE" {
        Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "OldName") = {Name*O}
    }
}
```

**Запуск демонстрації:**

```objectscript
Do ##class(Transport.SQLDemo).Main()
```

## Висновки

Проект успішно реалізовано з використанням об'єктно-орієнтованого підходу та SQL-запитів для роботи з даними. Система включає:

- Різноманітні типи SQL-запитів (статичні, динамічні, з курсорами)
- Використання оператора `->` для роботи з відношеннями
- Тригери для автоматичного логування змін

## Приклад роботи програми

```
%SYS>Do ##class(Transport.SQLDemo).Main()

========================================
  ДЕМОНСТРАЦІЯ SQL-ЗАПИТІВ ТА ТРИГЕРІВ
========================================



=== ДЕМОНСТРАЦІЯ SQL ===
1. Демонстрація SQL-запитів з параметрами (GetVehiclesByBrand)
2. Демонстрація SQL-запиту з оператором -> (GetVehiclesWithOwners)
3. Демонстрація %Query з курсором (GetOwnersWithVehicleCount)
4. Демонстрація динамічного SQL
5. Демонстрація вбудованого SQL (простий вираз)
6. Демонстрація вбудованого SQL (курсор)
7. Демонстрація тригера Owner
8. Демонстрація запитів ServiceRecord
0. Вихід

Оберіть опцію: 1

=== ДЕМОНСТРАЦІЯ SQL-ЗАПИТУ З ПАРАМЕТРОМ ===
Запит: GetVehiclesByBrand

Введіть марку транспорту (наприклад, Toyota, BMW): Toyota

Транспортні засоби марки 'Toyota':
========================================

1. ID: 1
   Марка: Toyota
   Модель: Camry
   VIN: CAR1LT3WX3PBUYHSD
   Рік: 2019
   Колір: Чорний
   Власник: Іван Петренко
   Email: ivan.petrenko@email.com
   Телефон: +380501234567


Всього знайдено: 1 транспортних засобів


Оберіть опцію: 2

=== ДЕМОНСТРАЦІЯ SQL-ЗАПИТУ З ОПЕРАТОРОМ -> ===
Запит: GetVehiclesWithOwners

Використовує оператор -> для доступу до властивостей Owner

Всі транспортні засоби з інформацією про власників:
========================================

1. Toyota Camry (CAR1LT3WX3PBUYHSD)
   Рік: 2019 | Колір: Чорний
   Пробіг: 12000 км
   Власник: Іван Петренко
   Email: ivan.petrenko@email.com

2. Yamaha YZF-R6 (MOTO2WTAHWSZ6HM2K)
   Рік: 2021 | Колір: Синій
   Пробіг: 18000 км
   Власник: Іван Петренко
   Email: іван.петренко@gmail.com

3. BMW Corolla (CAR2X4DXL8A7L4MPL)
   Рік: 2020 | Колір: Білий
   Пробіг: 34000 км
   Власник: Марія Коваленко
   Email: maria.kovalenko@email.com

4. Volvo FH16 (TRUCK1RVSD9YWVVDW)
   Рік: 2021 | Колір: Синій
   Пробіг: 15000 км
   Власник: Марія Коваленко
   Email: марія.коваленко@ukr.net

5. Harley-Davidson Street 750 (MOTO1PRVE6M2ZJNX5)
   Рік: 2020 | Колір: Червоний
   Пробіг: 5000 км
   Власник: Олег Сидоренко
   Email: oleg.sydorenko@email.com


Всього: 5 транспортних засобів


Оберіть опцію: 3

=== ДЕМОНСТРАЦІЯ %QUERY З КУРСОРОМ ===
Запит: GetOwnersWithVehicleCount
Використовує вбудований SQL з курсором

Власники з кількістю транспортних засобів:
========================================

1. Іван Петренко
   ID: 1
   Email: ivan.petrenko@email.com
   Телефон: +380501234567
   Кількість транспортних засобів: 1

2. Іван Петренко
   ID: 6
   Email: іван.петренко@gmail.com
   Телефон: +380839330363
   Кількість транспортних засобів: 1

3. Іван Петренко
   ID: 28
   Email: іван.петренко@gmail.com
   Телефон: +380951583348
   Кількість транспортних засобів: 0

4. Анна Мельник
   ID: 9
   Email: анна.мельник@yahoo.com
   Телефон: +380507920776
   Кількість транспортних засобів: 0

5. Анна Мельник
   ID: 31
   Email: анна.мельник@yahoo.com
   Телефон: +380304429808
   Кількість транспортних засобів: 0

6. Дмитро Шевченко
   ID: 10
   Email: дмитро.шевченко@gmail.com
   Телефон: +380651254514
   Кількість транспортних засобів: 0

7. Дмитро Шевченко
   ID: 32
   Email: дмитро.шевченко@gmail.com
   Телефон: +380377310804
   Кількість транспортних засобів: 0

8. Марія Коваленко
   ID: 2
   Email: maria.kovalenko@email.com
   Телефон: +380507654321
   Кількість транспортних засобів: 1

9. Марія Коваленко
   ID: 7
   Email: марія.коваленко@ukr.net
   Телефон: +380684063132
   Кількість транспортних засобів: 1

10. Марія Коваленко
   ID: 29
   Email: марія.коваленко@ukr.net
   Телефон: +380618463380
   Кількість транспортних засобів: 0

11. Олег Сидоренко
   ID: 3
   Email: oleg.sydorenko@email.com
   Телефон: +380509876543
   Кількість транспортних засобів: 1

12. Олег Сидоренко
   ID: 8
   Email: олег.сидоренко@email.com
   Телефон: +380226937590
   Кількість транспортних засобів: 0

13. Олег Сидоренко
   ID: 30
   Email: олег.сидоренко@email.com
   Телефон: +380303534565
   Кількість транспортних засобів: 0

14. Тестовий Власник
   ID: 16
   Email:
   Телефон:
   Кількість транспортних засобів: 0

15. Тестовий Власник
   ID: 21
   Email:
   Телефон:
   Кількість транспортних засобів: 0

16. Тестовий Власник (Демо)
   ID: 22
   Email: demo@example.com
   Телефон: +380501112233
   Кількість транспортних засобів: 0

17. Тестовий Власник (Демо)
   ID: 23
   Email: demo@example.com
   Телефон: +380501112233
   Кількість транспортних засобів: 0

18. Тестовий Власник (Демо)
   ID: 24
   Email: demo@example.com
   Телефон: +380501112233
   Кількість транспортних засобів: 0

19. Тестовий Власник (Демо)
   ID: 25
   Email: demo@example.com
   Телефон: +380501112233
   Кількість транспортних засобів: 0

20. Тестовий Власник (Демо)
   ID: 26
   Email: demo@example.com
   Телефон: +380501112233
   Кількість транспортних засобів: 0


Всього: 20 власників


Оберіть опцію: 4

=== ДЕМОНСТРАЦІЯ ДИНАМІЧНОГО SQL ===
Використання %SQL.Statement для динамічних запитів

Введіть мінімальний рік випуску: 2021

Виконується запит:
SELECT Brand, Model, Year FROM Transport.Vehicle WHERE Year >= ? ORDER BY Year DESC
Параметр: 2021

Результати:
========================================

1. Yamaha YZF-R6 (2021)

2. Volvo FH16 (2021)


Всього знайдено: 2 транспортних засобів

Оберіть опцію: 5

=== ДЕМОНСТРАЦІЯ ВБУДОВАНОГО SQL (ПРОСТИЙ ВИРАЗ) ===
Використання &sql() для простих SQL виразів

Введіть марку транспорту: BMW

Статистика для марки 'BMW':
========================================
Кількість транспортних засобів: 1
Середній пробіг: 34000.00 км


Оберіть опцію: 6

=== ДЕМОНСТРАЦІЯ ВБУДОВАНОГО SQL (КУРСОР) ===
Використання курсорів для обробки множини рядків

Список транспортних засобів з пробігом більше 1000 км:
========================================

1. BMW Corolla (VIN: CAR2X4DXL8A7L4MPL)
   Пробіг: 34000 км
   Власник: Марія Коваленко

2. Yamaha YZF-R6 (VIN: MOTO2WTAHWSZ6HM2K)
   Пробіг: 18000 км
   Власник: Іван Петренко

3. Volvo FH16 (VIN: TRUCK1RVSD9YWVVDW)
   Пробіг: 15000 км
   Власник: Марія Коваленко

4. Toyota Camry (VIN: CAR1LT3WX3PBUYHSD)
   Пробіг: 12000 км
   Власник: Іван Петренко

5. Harley-Davidson Street 750 (VIN: MOTO1PRVE6M2ZJNX5)
   Пробіг: 5000 км
   Власник: Олег Сидоренко


Всього знайдено: 5 транспортних засобів


Оберіть опцію: 7

=== ДЕМОНСТРАЦІЯ ТРИГЕРА ===
Тригер LogOwnerChanges логує всі зміни власників

Створюємо тестового власника для демонстрації...
✓ Власник створено (ID: 34)
  Тригер повинен зафіксувати INSERT операцію

Перевірка логу тригера...
Лог тригера для власника ID: 34
========================================

Операція: INSERT | Дата: 21/11/2025
  Email: demo@example.com
  Name: Тестовий Власник (Демо)
  Phone: +380501112233


Оновлюємо інформацію про власника...
✓ Власник оновлено
  Тригер повинен зафіксувати UPDATE операцію

Перевірка логу тригера після оновлення...
Лог тригера для власника ID: 34
========================================

Операція: INSERT | Дата: 21/11/2025
  Email: demo@example.com
  Name: Тестовий Власник (Демо)
  Phone: +380501112233

Операція: UPDATE | Дата: 21/11/2025
  Email: demo.updated@example.com
  Name: Тестовий Власник (Демо)
  OldName: Тестовий Власник (Демо)
  Phone: +380507778899


Видаляємо тестового власника...
✓ Власник видалено


=== ДЕМОНСТРАЦІЯ SQL ===
1. Демонстрація SQL-запитів з параметрами (GetVehiclesByBrand)
2. Демонстрація SQL-запиту з оператором -> (GetVehiclesWithOwners)
3. Демонстрація %Query з курсором (GetOwnersWithVehicleCount)
4. Демонстрація динамічного SQL
5. Демонстрація вбудованого SQL (простий вираз)
6. Демонстрація вбудованого SQL (курсор)
7. Демонстрація тригера Owner
8. Демонстрація запитів ServiceRecord
0. Вихід


Оберіть опцію: 8

=== ДЕМОНСТРАЦІЯ ЗАПИТІВ SERVICERECORD ===

Введіть ID транспортного засобу (або Enter для демонстрації інших запитів): 2

Історія обслуговування для транспортного засобу ID: 2
========================================

1. Дата: 21/10/2025
   Опис: Технічне обслуговування
   Вартість: 8223 грн
   Виконано: Автосервіс BMW
   Пробіг: -4016 км
   Транспорт: BMW Corolla (VIN: CAR2X4DXL8A7L4MPL)

2. Дата: 28/02/2025
   Опис: Заміна шин
   Вартість: 7787 грн
   Виконано: Офіційний дилер BMW
   Пробіг: -3469 км
   Транспорт: BMW Corolla (VIN: CAR2X4DXL8A7L4MPL)


Загальна вартість обслуговування: 16010 грн


Записи обслуговування з високою вартістю (>= 1000 грн):
========================================

1. Дата: 14/03/2025 - 9699 грн
   Опис: Заміна гальмівних колодок
   Виконано: Офіційний дилер Harley-Davidson
   Транспорт: Harley-Davidson Street 750
   Власник: Олег Сидоренко

2. Дата: 21/10/2025 - 8223 грн
   Опис: Технічне обслуговування
   Виконано: Автосервіс BMW
   Транспорт: BMW Corolla
   Власник: Марія Коваленко

3. Дата: 11/09/2025 - 8151 грн
   Опис: Ремонт двигуна
   Виконано: Автосервіс Toyota
   Транспорт: Toyota Camry
   Власник: Іван Петренко

4. Дата: 28/02/2025 - 7787 грн
   Опис: Заміна шин
   Виконано: Офіційний дилер BMW
   Транспорт: BMW Corolla
   Власник: Марія Коваленко

5. Дата: 07/09/2025 - 5689 грн
   Опис: Заміна масла
   Виконано: Сервісний центр Toyota
   Транспорт: Toyota Camry
   Власник: Іван Петренко

6. Дата: 24/10/2024 - 4920 грн
   Опис: Ремонт трансмісії
   Виконано: Гараж Harley-Davidson
   Транспорт: Harley-Davidson Street 750
   Власник: Олег Сидоренко

7. Дата: 06/09/2025 - 2701 грн
   Опис: Заміна фільтрів
   Виконано: Гараж Yamaha
   Транспорт: Yamaha YZF-R6
   Власник: Іван Петренко

8. Дата: 21/12/2024 - 1877 грн
   Опис: Технічне обслуговування
   Виконано: Автосервіс Volvo
   Транспорт: Volvo FH16
   Власник: Марія Коваленко

9. Дата: 11/11/2024 - 1731 грн
   Опис: Діагностика
   Виконано: Сервісний центр Volvo
   Транспорт: Volvo FH16
   Власник: Марія Коваленко

10. Дата: 23/08/2025 - 1143 грн
   Опис: Заміна масла
   Виконано: Сервісний центр Yamaha
   Транспорт: Yamaha YZF-R6
   Власник: Іван Петренко
```
