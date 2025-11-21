Class Transport.SQLDemo Extends %RegisteredObject
{

/// Головний метод для демонстрації SQL-запитів
ClassMethod Main() As %Status
{
    Write !!,"========================================",!
    Write "  ДЕМОНСТРАЦІЯ SQL-ЗАПИТІВ ТА ТРИГЕРІВ",!
    Write "========================================",!!
    
    Do ..Menu()
    
    Quit $$$OK
}

/// Меню демонстрації
ClassMethod Menu()
{
    Set exit = 0
    For {
        Write !!,"=== ДЕМОНСТРАЦІЯ SQL ===",!
        Write "1. Демонстрація SQL-запитів з параметрами (GetVehiclesByBrand)",!
        Write "2. Демонстрація SQL-запиту з оператором -> (GetVehiclesWithOwners)",!
        Write "3. Демонстрація %Query з курсором (GetOwnersWithVehicleCount)",!
        Write "4. Демонстрація динамічного SQL",!
        Write "5. Демонстрація вбудованого SQL (простий вираз)",!
        Write "6. Демонстрація вбудованого SQL (курсор)",!
        Write "7. Демонстрація тригера Owner",!
        Write "8. Демонстрація запитів ServiceRecord",!
        Write "0. Вихід",!
        Write !,"Оберіть опцію: "
        Read choice
        
        If choice=0 Set exit=1 Quit
        If choice=1 Do ..DemoSQLQueryWithParameter()
        If choice=2 Do ..DemoSQLQueryWithArrow()
        If choice=3 Do ..DemoQueryWithCursor()
        If choice=4 Do ..DemoDynamicSQL()
        If choice=5 Do ..DemoEmbeddedSQLSimple()
        If choice=6 Do ..DemoEmbeddedSQLCursor()
        If choice=7 Do ..DemoTrigger()
        If choice=8 Do ..DemoServiceRecordQueries()
    }
    Quit
}

/// Демонстрація SQL-запиту з параметром
ClassMethod DemoSQLQueryWithParameter()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ SQL-ЗАПИТУ З ПАРАМЕТРОМ ===",!
    Write "Запит: GetVehiclesByBrand",!!
    
    Write "Введіть марку транспорту (наприклад, Toyota, BMW): "
    Read brandName
    
    If brandName = "" {
        Write "Марка не введена",!
        Quit
    }
    
    Write !!,"Транспортні засоби марки '"_brandName_"':",!
    Write "========================================",!
    
    Set resultSet = ##class(%ResultSet).%New("Transport.Vehicle:GetVehiclesByBrand")
    If '$IsObject(resultSet) {
        Write "Помилка створення resultSet",!
        Quit
    }
    
    Set sc = resultSet.Execute(brandName)
    
    If $$$ISERR(sc) {
        Write "Помилка виконання запиту: "_$System.Status.GetErrorText(sc),!
        Do resultSet.Close()
        Quit
    }
    
    Set count = 0
    While resultSet.%Next() {
        Set count = count + 1
        Write !,count_". ID: "_resultSet.Data("ID"),!
        Write "   Марка: "_resultSet.Data("Brand"),!
        Write "   Модель: "_resultSet.Data("Model"),!
        Write "   VIN: "_resultSet.Data("VIN"),!
        Write "   Рік: "_resultSet.Data("Year"),!
        Write "   Колір: "_$Get(resultSet.Data("Color"), "Не вказано"),!
        Write "   Власник: "_$Get(resultSet.Data("OwnerName"), "Не вказано"),!
        Write "   Email: "_$Get(resultSet.Data("OwnerEmail"), "Не вказано"),!
        Write "   Телефон: "_$Get(resultSet.Data("OwnerPhone"), "Не вказано"),!
    }
    
    If count = 0 {
        Write "Транспортних засобів марки '"_brandName_"' не знайдено",!
    } Else {
        Write !!,"Всього знайдено: "_count_" транспортних засобів",!
    }
    
    Do resultSet.Close()
}

/// Демонстрація SQL-запиту з оператором ->
ClassMethod DemoSQLQueryWithArrow()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ SQL-ЗАПИТУ З ОПЕРАТОРОМ -> ===",!
    Write "Запит: GetVehiclesWithOwners",!!
    Write "Використовує оператор -> для доступу до властивостей Owner",!!
    
    Set resultSet = ##class(%ResultSet).%New("Transport.Vehicle:GetVehiclesWithOwners")
    If '$IsObject(resultSet) {
        Write "Помилка створення resultSet",!
        Quit
    }
    
    Set sc = resultSet.Execute()
    
    If $$$ISERR(sc) {
        Write "Помилка виконання запиту: "_$System.Status.GetErrorText(sc),!
        Do resultSet.Close()
        Quit
    }
    
    Write "Всі транспортні засоби з інформацією про власників:",!
    Write "========================================",!
    
    Set count = 0
    While resultSet.%Next() {
        Set count = count + 1
        Write !,count_". "_resultSet.Data("Brand")_" "_resultSet.Data("Model")_" ("_resultSet.Data("VIN")_")",!
        Write "   Рік: "_resultSet.Data("Year")_" | Колір: "_$Get(resultSet.Data("Color"), "Не вказано"),!
        Write "   Пробіг: "_resultSet.Data("CurrentMileage")_" км",!
        Write "   Власник: "_$Get(resultSet.Data("OwnerName"), "Не вказано"),!
        Write "   Email: "_$Get(resultSet.Data("OwnerEmail"), "Не вказано"),!
    }
    
    Write !!,"Всього: "_count_" транспортних засобів",!
    Do resultSet.Close()
}

/// Демонстрація %Query з курсором
ClassMethod DemoQueryWithCursor()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ %QUERY З КУРСОРОМ ===",!
    Write "Запит: GetOwnersWithVehicleCount",!
    Write "Використовує вбудований SQL з курсором",!!
    
    Set resultSet = ##class(%ResultSet).%New("Transport.Owner:GetOwnersWithVehicleCount")
    If '$IsObject(resultSet) {
        Write "Помилка створення resultSet",!
        Quit
    }
    
    Set sc = resultSet.Execute()
    
    If $$$ISERR(sc) {
        Write "Помилка виконання запиту: "_$System.Status.GetErrorText(sc),!
        Do resultSet.Close()
        Quit
    }
    
    Write "Власники з кількістю транспортних засобів:",!
    Write "========================================",!
    
    Set count = 0
    While resultSet.%Next() {
        Set count = count + 1
        Write !,count_". "_resultSet.Data("OwnerName"),!
        Write "   ID: "_resultSet.Data("OwnerId"),!
        Write "   Email: "_$Get(resultSet.Data("Email"), "Не вказано"),!
        Write "   Телефон: "_$Get(resultSet.Data("Phone"), "Не вказано"),!
        Write "   Кількість транспортних засобів: "_resultSet.Data("VehicleCount"),!
    }
    
    Write !!,"Всього: "_count_" власників",!
    Do resultSet.Close()
}

/// Демонстрація динамічного SQL
ClassMethod DemoDynamicSQL()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ ДИНАМІЧНОГО SQL ===",!
    Write "Використання %SQL.Statement для динамічних запитів",!!
    
    Write "Введіть мінімальний рік випуску: "
    Read minYear
    If minYear = "" Set minYear = 2020
    
    Set query = "SELECT Brand, Model, Year "_
            "FROM Transport.Vehicle "_
            "WHERE Year >= ? "_
            "ORDER BY Year DESC"
    
    Write !!,"Виконується запит:",!
    Write query,!
    Write "Параметр: "_minYear,!!
    
    Set statement = ##class(%SQL.Statement).%New()
    Set sc = statement.%Prepare(query)
    
    If $$$ISERR(sc) {
        Write "Помилка підготовки запиту: "_$System.Status.GetErrorText(sc),!
        Quit
    }
    
    Set resultSet = statement.%Execute(minYear)
    
    Write "Результати:",!
    Write "========================================",!
    
    Set count = 0
    While resultSet.%Next() {
        Set count = count + 1

        Write !,count_". "_resultSet.Brand_" "_resultSet.Model_" ("_resultSet.Year_")",!
    }
    
    If count = 0 {
        Write "Транспортних засобів з року "_minYear_" не знайдено",!
    } Else {
        Write !!,"Всього знайдено: "_count_" транспортних засобів",!
    }
}

/// Демонстрація вбудованого SQL (простий вираз)
ClassMethod DemoEmbeddedSQLSimple()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ ВБУДОВАНОГО SQL (ПРОСТИЙ ВИРАЗ) ===",!
    Write "Використання &sql() для простих SQL виразів",!!
    
    Write "Введіть марку транспорту: "
    Read brandName
    
    If brandName = "" {
        Write "Марка не введена",!
        Quit
    }
    
    // Використовуємо метод класу з вбудованим SQL
    Set count = ##class(Transport.Vehicle).CountByBrand(brandName)
    Set avgMileage = ##class(Transport.Vehicle).GetAverageMileageByBrand(brandName)
    
    Write !!,"Статистика для марки '"_brandName_"':",!
    Write "========================================",!
    Write "Кількість транспортних засобів: "_count,!
    If avgMileage > 0 {
        Write "Середній пробіг: "_$Justify(avgMileage, 0, 2)_" км",!
    } Else {
        Write "Середній пробіг: немає даних",!
    }
}

/// Демонстрація вбудованого SQL (курсор)
ClassMethod DemoEmbeddedSQLCursor()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ ВБУДОВАНОГО SQL (КУРСОР) ===",!
    Write "Використання курсорів для обробки множини рядків",!!
    
    Write "Список транспортних засобів з пробігом більше 1000 км:",!
    Write "========================================",!
    
    // Оголошуємо курсор
    &sql(DECLARE VehicleMileageCursor CURSOR FOR
        SELECT %ID, Brand, Model, VIN, CurrentMileage, Owner->Name As OwnerName
        INTO :vehicleId, :brand, :model, :vin, :mileage, :ownerName
        FROM Transport.Vehicle
        WHERE CurrentMileage > 1000
        ORDER BY CurrentMileage DESC
    )
    
    &sql(OPEN VehicleMileageCursor)
    
    If SQLCODE '= 0 {
        Write "Помилка відкриття курсору: SQLCODE = "_SQLCODE,!
        Quit
    }
    
    Set count = 0
    For {
        &sql(FETCH VehicleMileageCursor)
        Quit:SQLCODE'=0
        
        Set count = count + 1
        Write !,count_". "_brand_" "_model_" (VIN: "_vin_")",!
        Write "   Пробіг: "_mileage_" км",!
        Write "   Власник: "_$Get(ownerName, "Не вказано"),!
    }
    
    &sql(CLOSE VehicleMileageCursor)
    
    If count = 0 {
        Write "Транспортних засобів з пробігом більше 1000 км не знайдено",!
    } Else {
        Write !!,"Всього знайдено: "_count_" транспортних засобів",!
    }
}

/// Демонстрація тригера
ClassMethod DemoTrigger()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ ТРИГЕРА ===",!
    Write "Тригер LogOwnerChanges логує всі зміни власників",!!
    
    Write "Створюємо тестового власника для демонстрації...",!
    
    // Створюємо тестового власника
    Set owner = ##class(Transport.Owner).%New()
    Set owner.Id = $R(100000) + 90000
    Set owner.Name = "Тестовий Власник (Демо)"
    Set owner.Email = "demo@example.com"
    Set owner.Phone = "+380501112233"
    
    Set sc = owner.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення власника: "_$System.Status.GetErrorText(sc),!
        Quit
    }
    
    Set ownerId = owner.%Id()
    Write "✓ Власник створено (ID: "_ownerId_")",!
    Write "  Тригер повинен зафіксувати INSERT операцію",!!
    
    Write "Перевірка логу тригера...",!
    Do ..ShowTriggerLog(ownerId)
    
    Write !!,"Оновлюємо інформацію про власника...",!
    Set owner.Email = "demo.updated@example.com"
    Set owner.Phone = "+380507778899"
    Set sc = owner.%Save()
    
    If $$$ISOK(sc) {
        Write "✓ Власник оновлено",!
        Write "  Тригер повинен зафіксувати UPDATE операцію",!!
        
        Write "Перевірка логу тригера після оновлення...",!
        Do ..ShowTriggerLog(ownerId)
        
        Write !!,"Видаляємо тестового власника...",!
        Do owner.%DeleteId(ownerId)
        Write "✓ Власник видалено",!
    } Else {
        Write "Помилка оновлення: "_$System.Status.GetErrorText(sc),!
    }
}

/// Відображення логу тригера
ClassMethod ShowTriggerLog(ownerId As %Integer)
{
    Write "Лог тригера для власника ID: "_ownerId,!
    Write "========================================",!
    
    // Структура глобалу: ^Transport.OwnerLog(ownerId, operation, date, field)
    Set operation = ""
    Set found = 0
    
    // Спочатку проходимося по операціях
    For {
        Set operation = $Order(^Transport.OwnerLog(ownerId, operation))
        Quit:operation=""
        
        Set date = ""
        // Потім по датам для кожної операції
        For {
            Set date = $Order(^Transport.OwnerLog(ownerId, operation, date))
            Quit:date=""
            
            Set found = 1
            Write !,"Операція: "_operation_" | Дата: "_$ZD(date, 4),!
            
            Set field = ""
            // Потім по полях для кожної дати
            For {
                Set field = $Order(^Transport.OwnerLog(ownerId, operation, date, field))
                Quit:field=""
                
                If $Data(^Transport.OwnerLog(ownerId, operation, date, field)) {
                    Set value = ^Transport.OwnerLog(ownerId, operation, date, field)
                    Write "  "_field_": "_value,!
                }
            }
        }
    }
    
    If 'found {
        Write "Записів у лозі не знайдено",!
        Write "Перевірка наявності даних в глобалі...",!
        If $Data(^Transport.OwnerLog(ownerId)) {
            Write "Глобал існує для власника ID: "_ownerId,!
        } Else {
            Write "Глобал не існує для власника ID: "_ownerId,!
        }
    }
}

/// Демонстрація запитів ServiceRecord
ClassMethod DemoServiceRecordQueries()
{
    Write !!,"=== ДЕМОНСТРАЦІЯ ЗАПИТІВ SERVICERECORD ===",!!
    
    Write "Введіть ID транспортного засобу (або Enter для демонстрації інших запитів): "
    Read vehicleId
    
    If vehicleId '= "" {
        Write !!,"Історія обслуговування для транспортного засобу ID: "_vehicleId,!
        Write "========================================",!
        
        Set resultSet = ##class(%ResultSet).%New("Transport.ServiceRecord:GetServiceHistoryByVehicle")
        If '$IsObject(resultSet) {
            Write "Помилка створення resultSet",!
            Quit
        }
        
        Set sc = resultSet.Execute(vehicleId)
        
        If $$$ISERR(sc) {
            Write "Помилка виконання запиту: "_$System.Status.GetErrorText(sc),!
            Do resultSet.Close()
        } Else {
            Set count = 0
            While resultSet.%Next() {
                Set count = count + 1
                Write !,count_". Дата: "_$ZD(resultSet.Data("ServiceDate"), 4),!
                Write "   Опис: "_$Get(resultSet.Data("Description"), "Не вказано"),!
                Write "   Вартість: "_resultSet.Data("Cost")_" грн",!
                Write "   Виконано: "_$Get(resultSet.Data("PerformedBy"), "Не вказано"),!
                Write "   Пробіг: "_resultSet.Data("Mileage")_" км",!
                Write "   Транспорт: "_resultSet.Data("VehicleBrand")_" "_resultSet.Data("VehicleModel")_" (VIN: "_resultSet.Data("VehicleVIN")_")",!
            }
            
            If count = 0 {
                Write "Записів обслуговування не знайдено",!
            }
            
            // Використовуємо вбудований SQL для підрахунку загальної вартості
            Set totalCost = ##class(Transport.ServiceRecord).GetTotalServiceCostByVehicle(vehicleId)
            If totalCost > 0 {
                Write !!,"Загальна вартість обслуговування: "_totalCost_" грн",!
            }
            
            Do resultSet.Close()
        }
    }
    
    Write !!,"Записи обслуговування з високою вартістю (>= 1000 грн):",!
    Write "========================================",!
    
    Set resultSet2 = ##class(%ResultSet).%New("Transport.ServiceRecord:GetExpensiveServices")
    If '$IsObject(resultSet2) {
        Write "Помилка створення resultSet",!
        Quit
    }
    
    Set sc = resultSet2.Execute(1000)
    
    If $$$ISERR(sc) {
        Write "Помилка виконання запиту: "_$System.Status.GetErrorText(sc),!
        Do resultSet2.Close()
    } Else {
        Set count = 0
        While resultSet2.%Next() {
            Set count = count + 1
            Write !,count_". Дата: "_$ZD(resultSet2.Data("ServiceDate"), 4)_" - "_resultSet2.Data("Cost")_" грн",!
            Write "   Опис: "_$Get(resultSet2.Data("Description"), "Не вказано"),!
            Write "   Виконано: "_$Get(resultSet2.Data("PerformedBy"), "Не вказано"),!
            Write "   Транспорт: "_resultSet2.Data("VehicleBrand")_" "_resultSet2.Data("VehicleModel"),!
            Write "   Власник: "_$Get(resultSet2.Data("OwnerName"), "Не вказано"),!
        }
        
        If count = 0 {
            Write "Записів не знайдено",!
        }
        
        Do resultSet2.Close()
    }
}

}
