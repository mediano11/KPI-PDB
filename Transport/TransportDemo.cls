Class Transport.TransportDemo Extends %RegisteredObject
{

/// Головний метод для демонстрації
ClassMethod Main() As %Status
{
    Write !,"=== ДЕМОНСТРАЦІЯ СИСТЕМИ ТРАНСПОРТНИХ ЗАСОБІВ ===",!!
    
    // Створення тестових даних
    #; Set sc = ..CreateSampleData()
    #; If $$$ISERR(sc) Quit sc
    
    // Демонстрація роботи
    Do ..DemonstrateMethods()
    
    // Головне меню
    Do ..MainMenu()
    
    Quit $$$OK
}

/// Створення прикладних даних
ClassMethod CreateSampleData() As %Status
{
    Write !,"Завантаження демо-даних...",!
    
    // Створення власників
    Set owner1 = ##class(Transport.Owner).%New()
    Set owner1.Id = 1
    Set owner1.Name = "Іван Петренко"
    Set owner1.Email = "ivan.petrenko@email.com"
    Set owner1.Phone = "+380501234567"
    Set sc = owner1.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення власника 1",!
        Quit sc
    }
    
    Set owner2 = ##class(Transport.Owner).%New()
    Set owner2.Id = 2
    Set owner2.Name = "Марія Коваленко"
    Set owner2.Email = "maria.kovalenko@email.com"
    Set owner2.Phone = "+380507654321"
    Set sc = owner2.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення власника 2",!
        Quit sc
    }
    
    Set owner3 = ##class(Transport.Owner).%New()
    Set owner3.Id = 3
    Set owner3.Name = "Олег Сидоренко"
    Set owner3.Email = "oleg.sydorenko@email.com"
    Set owner3.Phone = "+380509876543"
    Set sc = owner3.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення власника 3",!
        Quit sc
    }
    
    // Створення автомобілів
    // Автомобіль 1
    Set car1 = ##class(Transport.Car).%New()
    Set car1.Brand = "Toyota"
    Set car1.Model = "Camry"
    Set car1.VIN = "1HGBH41JXMN109186"
    Set car1.Year = 2022
    Set car1.Color = "Чорний"
    Set car1.BodyType = "Седан"
    Set car1.Owner = owner1
    
    Set engine1 = ##class(Transport.Engine).%New()
    Set engine1.Type = "Бензиновий"
    Set engine1.HorsePower = 280
    Set car1.Engine = engine1
    
    Do car1.Passengers.Insert("Іван Петренко")
    Do car1.Passengers.Insert("Марія Петренко")
    
    Set sc = car1.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення автомобіля 1",!
        Quit sc
    }
    
    // Автомобіль 2
    Set car2 = ##class(Transport.Car).%New()
    Set car2.Brand = "BMW"
    Set car2.Model = "X5"
    Set car2.VIN = "5UXKR0C58L9R12345"
    Set car2.Year = 2023
    Set car2.Color = "Білий"
    Set car2.BodyType = "Кросовер"
    Set car2.Owner = owner2
    
    Set engine2 = ##class(Transport.Engine).%New()
    Set engine2.Type = "Дизельний"
    Set engine2.HorsePower = 340
    Set car2.Engine = engine2
    
    Do car2.Passengers.Insert("Марія Коваленко")
    Do car2.Passengers.Insert("Дмитро Коваленко")
    Do car2.Passengers.Insert("Олена Коваленко")
    
    Set sc = car2.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення автомобіля 2",!
        Quit sc
    }
    
    // Мотоцикли
    // Мотоцикл 1
    Set moto1 = ##class(Transport.Motorcycle).%New()
    Set moto1.Brand = "Harley-Davidson"
    Set moto1.Model = "Street 750"
    Set moto1.VIN = "1HD1BZ4145K123456"
    Set moto1.Year = 2021
    Set moto1.Color = "Червоний"
    Set moto1.MotorcycleType = "Круїзер"
    Set moto1.Owner = owner3
    
    Set engine3 = ##class(Transport.Engine).%New()
    Set engine3.Type = "Бензиновий"
    Set engine3.HorsePower = 150
    Set moto1.Engine = engine3
    
    Do moto1.RequiredGear.SetAt("Шолом", 1)
    Do moto1.RequiredGear.SetAt("Захисні рукавиці", 2)
    Do moto1.RequiredGear.SetAt("Захисний жилет", 3)
    Do moto1.RequiredGear.SetAt("Захисні чоботи", 4)
    
    Set sc = moto1.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення мотоцикла 1",!
        Quit sc
    }
    
    // Мотоцикл 2
    Set moto2 = ##class(Transport.Motorcycle).%New()
    Set moto2.Brand = "Yamaha"
    Set moto2.Model = "YZF-R6"
    Set moto2.VIN = "JYARN17E08A123789"
    Set moto2.Year = 2022
    Set moto2.Color = "Синій"
    Set moto2.MotorcycleType = "Спортивний"
    Set moto2.Owner = owner1
    
    Set engine4 = ##class(Transport.Engine).%New()
    Set engine4.Type = "Бензиновий"
    Set engine4.HorsePower = 118
    Set moto2.Engine = engine4
    
    Do moto2.RequiredGear.SetAt("Спортивний шолом", 1)
    Do moto2.RequiredGear.SetAt("Шкіряні рукавиці", 2)
    Do moto2.RequiredGear.SetAt("Шкіряний комбінезон", 3)
    
    Set sc = moto2.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення мотоцикла 2",!
        Quit sc
    }
    
    // Вантажівки
    // Вантажівка 1
    Set truck1 = ##class(Transport.Truck).%New()
    Set truck1.Brand = "Volvo"
    Set truck1.Model = "FH16"
    Set truck1.VIN = "YV1CZ592481234567"
    Set truck1.Year = 2023
    Set truck1.Color = "Синій"
    Set truck1.LoadCapacity = 25
    Set truck1.Owner = owner3
    
    Set engine5 = ##class(Transport.Engine).%New()
    Set engine5.Type = "Дизельний"
    Set engine5.HorsePower = 450
    Set truck1.Engine = engine5
    
    Set sc = truck1.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення вантажівки 1",!
        Quit sc
    }
    
    // Додаємо вантаж до вантажівки 1
    Set cargo1 = ##class(Transport.CargoItem).%New()
    Set cargo1.Name = "Будівельні матеріали"
    Set cargo1.Weight = 15.5
    Set cargo1.Truck = truck1
    Set sc = cargo1.%Save()
    
    Set cargo2 = ##class(Transport.CargoItem).%New()
    Set cargo2.Name = "Металеві конструкції"
    Set cargo2.Weight = 8.2
    Set cargo2.Truck = truck1
    Set sc = cargo2.%Save()
    
    // Вантажівка 2
    Set truck2 = ##class(Transport.Truck).%New()
    Set truck2.Brand = "MAN"
    Set truck2.Model = "TGX"
    Set truck2.VIN = "WMA06XZZ2E1234567"
    Set truck2.Year = 2022
    Set truck2.Color = "Червоний"
    Set truck2.LoadCapacity = 20
    Set truck2.Owner = owner2
    
    Set engine6 = ##class(Transport.Engine).%New()
    Set engine6.Type = "Дизельний"
    Set engine6.HorsePower = 380
    Set truck2.Engine = engine6
    
    Set sc = truck2.%Save()
    If $$$ISERR(sc) {
        Write "Помилка створення вантажівки 2",!
        Quit sc
    }
    
    // Додаємо вантаж до вантажівки 2
    Set cargo3 = ##class(Transport.CargoItem).%New()
    Set cargo3.Name = "Харчові продукти"
    Set cargo3.Weight = 12.3
    Set cargo3.Truck = truck2
    Set sc = cargo3.%Save()
    
    Set cargo4 = ##class(Transport.CargoItem).%New()
    Set cargo4.Name = "Побутова техніка"
    Set cargo4.Weight = 5.7
    Set cargo4.Truck = truck2
    Set sc = cargo4.%Save()
    
    // Створення записів обслуговування
    Set service1 = ##class(Transport.ServiceRecord).%New()
    Set service1.Vehicle = car1
    Set service1.ServiceDate = $H - 30  // 30 днів тому
    Set service1.Description = "Технічне обслуговування: заміна масла, фільтрів, перевірка гальм"
    Set service1.Cost = 2500.00
    Set service1.PerformedBy = "Сервісний центр Toyota"
    Set service1.Mileage = 15000
    Set sc = service1.%Save()
    
    Set service2 = ##class(Transport.ServiceRecord).%New()
    Set service2.Vehicle = car1
    Set service2.ServiceDate = $H - 10  // 10 днів тому
    Set service2.Description = "Заміна гальмівних колодок"
    Set service2.Cost = 3200.00
    Set service2.PerformedBy = "Сервісний центр Toyota"
    Set service2.Mileage = 18500
    Set sc = service2.%Save()
    
    Set service3 = ##class(Transport.ServiceRecord).%New()
    Set service3.Vehicle = moto1
    Set service3.ServiceDate = $H - 15
    Set service3.Description = "Регулярне обслуговування: заміна масла, фільтра повітря"
    Set service3.Cost = 1500.00
    Set service3.PerformedBy = "Мотосервіс Harley-Davidson"
    Set service3.Mileage = 8500
    Set sc = service3.%Save()
    
    Set service4 = ##class(Transport.ServiceRecord).%New()
    Set service4.Vehicle = truck1
    Set service4.ServiceDate = $H - 5
    Set service4.Description = "Капітальний ремонт двигуна, заміна ременя ГРМ"
    Set service4.Cost = 45000.00
    Set service4.PerformedBy = "Сервісний центр Volvo"
    Set service4.Mileage = 125000
    Set sc = service4.%Save()
    
    Write "✓ Демо-дані успішно завантажено!",!
    Write "  Створено: 3 власників, 2 автомобілі, 2 мотоцикли, 2 вантажівки, 4 вантажі, 4 записи обслуговування",!!
    
    Quit $$$OK
}

/// Демонстрація роботи методів
ClassMethod DemonstrateMethods()
{
    Write !,"=== ДЕМОНСТРАЦІЯ РОБОТИ МЕТОДІВ ===",!

    Set id = ""
    Set count = 0

    // Проходимо по всіх транспортних засобах
    For {
        Set id = $Order(^Transport.VehicleD(id))
        Quit:id=""
        Set vehicle = ##class(Transport.Vehicle).%OpenId(id)
        Quit:'$IsObject(vehicle)

        Set count = count + 1
        Write !!,count,". ",vehicle.%ClassName(),!
        Do vehicle.DisplayInfo()

        // Демонстрація спільних методів
        Write !,"→ Запуск:",!
        Do vehicle.Start()

        Write !,"→ Рух на 100 км:",!
        Do vehicle.Move(100)

        Write !,"→ Прискорення до 120 км/год:",!
        Do vehicle.Accelerate(120)

        Write !,"→ Зупинка:",!
        Do vehicle.Stop()

        If vehicle.%IsA("Transport.Car") {
            Do vehicle.AddPassenger("Іван")
            Write !,"→ Пасажир доданий",!
        }
        ElseIf vehicle.%IsA("Transport.Motorcycle") {
            If vehicle.HasGear("Шолом") {
                Write !,"✓ Спорядження перевірено (є шолом)",!
            }
        }
        ElseIf vehicle.%IsA("Transport.Truck") {
            Write !,"→ Поточна вага вантажу: "_vehicle.GetTotalCargoWeight()_" т",!
        }



        // Збереження змін
        Do vehicle.%Save()
    }

    If count=0 {
        Write !,"Немає транспортних засобів у базі.",!
    } Else {
        Write !!,"=== Демонстрація завершена. Перевірено "_count_" засобів ===",!!
    }
}

/// Головне меню
ClassMethod MainMenu()
{
    Set exit = 0
    For {
        Write !!,"=== ГОЛОВНЕ МЕНЮ ===",!
        Write "1. Переглянути всі транспортні засоби",!
        Write "2. Переглянути всіх власників",!
        Write "3. Знайти транспортний засіб за VIN",!
        Write "4. Переглянути історію обслуговування",!
        Write "5. Додати новий запис обслуговування",!
        Write "6. Статистика по типу транспорту",!
        Write "7. Продемонструвати роботу методів",!
        Write "0. Вихід",!
        Write !,"Оберіть опцію: "
        Read choice
        
        If choice=0 Set exit=1 Quit
        If choice=1 Do ..ViewAllVehicles()
        If choice=2 Do ..ViewAllOwners()
        If choice=3 Do ..FindVehicleByVIN()
        If choice=4 Do ..ViewServiceRecords()
        If choice=5 Do ..AddServiceRecord()
        If choice=6 Do ..Statistics()
        If choice=7 Do ..DemonstrateMethods()
    }
    Quit
}

/// Перегляд всіх транспортних засобів
ClassMethod ViewAllVehicles() As %Status
{
    Write !!,"=== ВСІ ТРАНСПОРТНІ ЗАСОБИ ===",!
    
    Set count = 0
    Set id = ""

    // Перебір усіх екземплярів Vehicle (включаючи Car, Motorcycle, Truck)
    For {
        Set id = $Order(^Transport.VehicleD(id))
        Quit:id=""
        Set vehicle = ##class(Transport.Vehicle).%OpenId(id)
        Quit:'$IsObject(vehicle)
        
        Set count = count + 1
        Write !,count,". ",vehicle.%ClassName(),!
        Do vehicle.DisplayInfo()
    }
    
    If count=0 {
        Write "Немає даних",!
    } Else {
        Write !!,"Всього: "_count_" транспортних засобів",!
    }
    
    Quit $$$OK
}

/// Перегляд всіх власників
ClassMethod ViewAllOwners()
{
    Write !!,"=== ВСІ ВЛАСНИКИ ===",!
    
    Set count = 0
    Set id = ""
    For {
        Set id = $Order(^Transport.OwnerD(id))
        Quit:id=""
        Set owner = ##class(Transport.Owner).%OpenId(id)
        If $IsObject(owner) {
            Set count = count + 1
            Write !,count,". ",owner.Name,!
            Write "   ID: "_owner.Id,!
            Write "   Email: "_owner.Email,!
            Write "   Телефон: "_owner.Phone,!
            Write "   Контакт: "_owner.GetContact(),!
        }
    }
    
    If count=0 {
        Write "Немає даних",!
    } Else {
        Write !!,"Всього: "_count_" власників",!
    }
}

/// Пошук транспорту за VIN
ClassMethod FindVehicleByVIN()
{
    Write !!,"=== ПОШУК ТРАНСПОРТНОГО ЗАСОБУ ===",!
    Write "Введіть VIN: "
    Read vin
    
    // Шукаємо в автомобілях
    &sql(SELECT %ID INTO :id FROM Transport.Car WHERE VIN = :vin)
    If SQLCODE = 0 {
        Set vehicle = ##class(Transport.Car).%OpenId(id)
        If $IsObject(vehicle) {
            Write !!,"✓ ЗНАЙДЕНО: АВТОМОБІЛЬ",!
            Do vehicle.DisplayInfo()
            Quit
        }
    }
    
    // Шукаємо в мотоциклах
    &sql(SELECT %ID INTO :id FROM Transport.Motorcycle WHERE VIN = :vin)
    If SQLCODE = 0 {
        Set vehicle = ##class(Transport.Motorcycle).%OpenId(id)
        If $IsObject(vehicle) {
            Write !!,"✓ ЗНАЙДЕНО: МОТОЦИКЛ",!
            Do vehicle.DisplayInfo()
            Quit
        }
    }
    
    // Шукаємо в вантажівках
    &sql(SELECT %ID INTO :id FROM Transport.Truck WHERE VIN = :vin)
    If SQLCODE = 0 {
        Set vehicle = ##class(Transport.Truck).%OpenId(id)
        If $IsObject(vehicle) {
            Write !!,"✓ ЗНАЙДЕНО: ВАНТАЖІВКА",!
            Do vehicle.DisplayInfo()
            Quit
        }
    }
    
    Write !!,"⚠ Транспортний засіб не знайдено",!
}

/// Перегляд історії обслуговування
ClassMethod ViewServiceRecords()
{
    Write !!,"=== ІСТОРІЯ ОБСЛУГОВУВАННЯ ===",!
    Write "Введіть ID транспортного засобу: "
    Read vehicleId
    
    // Спробуємо відкрити як один з типів транспортних засобів
    Set vehicle = ##class(Transport.Car).%OpenId(vehicleId)
    If '$IsObject(vehicle) {
        Set vehicle = ##class(Transport.Motorcycle).%OpenId(vehicleId)
    }
    If '$IsObject(vehicle) {
        Set vehicle = ##class(Transport.Truck).%OpenId(vehicleId)
    }
    
    If '$IsObject(vehicle) {
        Write "Транспортний засіб не знайдено",!
        Quit
    }
    
    Write !!,"Транспорт: "_vehicle.Brand_" "_vehicle.Model_" (VIN: "_vehicle.VIN_")",!
    Write !,"--- Записи обслуговування ---",!
    
    // Використовуємо SQL запит для ефективності
    &sql(DECLARE C1 CURSOR FOR
        SELECT %ID, ServiceDate, Description, Cost, PerformedBy, Mileage
        INTO :id, :serviceDate, :description, :cost, :performedBy, :mileage
        FROM Transport.ServiceRecord
        WHERE Vehicle = :vehicleId
        ORDER BY ServiceDate DESC)
    
    &sql(OPEN C1)
    Set count = 0
    
    For {
        &sql(FETCH C1)
        Quit:SQLCODE'=0
        
        Set count = count + 1
        Write !,count,". Дата: "_$ZD(serviceDate,4),!
        Write "   Опис: "_description,!
        Write "   Вартість: "_cost_" грн",!
        Write "   Виконано: "_performedBy,!
        Write "   Пробіг: "_mileage_" км",!
    }
    
    &sql(CLOSE C1)
    
    If count=0 {
        Write "Немає записів обслуговування",!
    } Else {
        Write !!,"Всього: "_count_" записів",!
    }
}

/// Додавання нового запису обслуговування
ClassMethod AddServiceRecord()
{
    Write !!,"=== ДОДАВАННЯ ЗАПИСУ ОБСЛУГОВУВАННЯ ===",!
    Write "Введіть ID транспортного засобу: "
    Read vehicleId
    
    // Спробуємо відкрити як один з типів транспортних засобів
    Set vehicle = ##class(Transport.Car).%OpenId(vehicleId)
    If '$IsObject(vehicle) {
        Set vehicle = ##class(Transport.Motorcycle).%OpenId(vehicleId)
    }
    If '$IsObject(vehicle) {
        Set vehicle = ##class(Transport.Truck).%OpenId(vehicleId)
    }
    
    If '$IsObject(vehicle) {
        Write "Транспортний засіб не знайдено",!
        Quit
    }
    
    Write "Опис робіт: "
    Read description
    
    Write "Вартість: "
    Read cost
    
    Write "Виконано: "
    Read performedBy
    
    Set record = ##class(Transport.ServiceRecord).%New()
    Set record.Vehicle = vehicle
    Set record.ServiceDate = $P($H, ",", 1)
    Set record.Description = description
    Set record.Cost = cost
    Set record.PerformedBy = performedBy
    Set record.Mileage = vehicle.CurrentMileage
    
    Set sc = record.%Save()
    If $$$ISOK(sc) {
        Write !!,"✓ Запис обслуговування успішно додано!",!
    } Else {
        Write !!,"✗ Помилка збереження: "_$System.Status.GetErrorText(sc),!
    }
}

/// Статистика по типу транспорту
ClassMethod Statistics()
{
    Write !!,"=== СТАТИСТИКА ПО ТИПУ ТРАНСПОРТУ ===",!
    
    // Автомобілі
    &sql(SELECT COUNT(*) INTO :carCount FROM Transport.Car)
    Write !,"Автомобілі: "_carCount,!
    
    // Мотоцикли
    &sql(SELECT COUNT(*) INTO :motoCount FROM Transport.Motorcycle)
    Write "Мотоцикли: "_motoCount,!
    
    // Вантажівки
    &sql(SELECT COUNT(*) INTO :truckCount FROM Transport.Truck)
    Write "Вантажівки: "_truckCount,!
    
    Write !!,"Всього транспортних засобів: "_(carCount + motoCount + truckCount),!
}

}
