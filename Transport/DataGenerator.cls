Class Transport.DataGenerator Extends %RegisteredObject
{

/// Автоматична генерація даних для всіх класів
/// Кількість об'єктів для кожного класу
ClassMethod GenerateAll(count As %Integer = 5) As %Status
{
    Write !,"=== ГЕНЕРАЦІЯ ДАНИХ ДЛЯ ВСІХ КЛАСІВ ===",!
    Write "Кількість об'єктів на клас: "_count,!!
    
    // Очищення існуючих даних (опціонально)
    // #; Do ..CleanData()
    
    // 1. Генерація власників
    Set sc = ..GenerateOwners(count)
    If $$$ISERR(sc) {
        Write "Помилка генерації власників: "_$System.Status.GetErrorText(sc),!
        Quit sc
    }
    
    // 2. Генерація транспортних засобів (автомобілі, мотоцикли, вантажівки)
    Set sc = ..GenerateVehicles(count)
    If $$$ISERR(sc) {
        Write "Помилка генерації транспортних засобів: "_$System.Status.GetErrorText(sc),!
        Quit sc
    }
    
    // 3. Генерація записів обслуговування
    Set sc = ..GenerateServiceRecords(count * 2)
    If $$$ISERR(sc) {
        Write "Помилка генерації записів обслуговування: "_$System.Status.GetErrorText(sc),!
        Quit sc
    }
    
    // 4. Генерація вантажу для вантажівок
    Set sc = ..GenerateCargoItems(count * 2)
    If $$$ISERR(sc) {
        Write "Помилка генерації вантажу: "_$System.Status.GetErrorText(sc),!
        Quit sc
    }
    
    Write !!,"✓ Генерація даних завершена успішно!",!
    
    Quit $$$OK
}

/// Генерація власників
ClassMethod GenerateOwners(count As %Integer) As %Status
{
    Write "Генерація власників...",!
    
    Set names = $ListBuild("Іван Петренко", "Марія Коваленко", "Олег Сидоренко", "Анна Мельник", "Дмитро Шевченко", "Олена Бондар", "Василь Іваненко", "Наталія Кравченко", "Сергій Ткаченко", "Юлія Григоренко")
    Set domains = $ListBuild("gmail.com", "ukr.net", "email.com", "yahoo.com")
    
    &sql(SELECT MAX(Id) INTO :maxId FROM Transport.Owner)
    If maxId = "" Set maxId = 0
    
    For i = 1:1:count {
        Set owner = ##class(Transport.Owner).%New()
        
        Set nameIndex = (i - 1) # $ListLength(names) + 1
        Set owner.Name = $List(names, nameIndex)
        Set owner.Id = maxId + i
        Set owner.Email = $ZConvert($Piece(owner.Name, " ", 1), "L")_"."_$ZConvert($Piece(owner.Name, " ", 2), "L")_"@"_$List(domains, (i - 1) # $ListLength(domains) + 1)
        Set owner.Phone = "+380"_($R(90) + 10)_$TR($J($R(10000000), 7), " ", "0")
        
        Set sc = owner.%Save()
        If $$$ISERR(sc) {
            Write "  Помилка збереження власника "_i_": "_$System.Status.GetErrorText(sc),!
            Continue
        }
    }
    
    Write "  Створено "_count_" власників",!
    Quit $$$OK
}

/// Генерація транспортних засобів
ClassMethod GenerateVehicles(count As %Integer) As %Status
{
    Write "Генерація транспортних засобів...",!
    
    Set carBrands = $ListBuild("Toyota", "BMW", "Mercedes-Benz", "Audi", "Volkswagen", "Ford", "Honda", "Nissan", "Hyundai", "Kia")
    Set carModels = $ListBuild("Camry", "Corolla", "RAV4", "X5", "X3", "C-Class", "E-Class", "A4", "A6", "Golf", "Passat", "Focus", "Civic", "Accord", "Altima", "Sonata", "Elantra", "Sportage", "Sorento")
    Set carBodyTypes = $ListBuild("Седан", "Кросовер", "Хетчбек", "Універсал", "Спорткар")
    Set carColors = $ListBuild("Чорний", "Білий", "Сірий", "Синій", "Червоний", "Сріблястий")
    
    Set motoBrands = $ListBuild("Harley-Davidson", "Yamaha", "Honda", "Kawasaki", "Suzuki", "Ducati", "Triumph", "BMW")
    Set motoModels = $ListBuild("Street 750", "YZF-R6", "CBR600RR", "Ninja ZX-6R", "GSX-R600", "Panigale V2", "Street Triple", "S1000RR")
    Set motoTypes = $ListBuild("Круїзер", "Спортивний", "Туристичний", "Класичний", "Кроссовий")
    Set motoColors = $ListBuild("Червоний", "Синій", "Чорний", "Жовтий", "Зелений", "Білий")
    Set motoGear = $ListBuild("Шолом", "Захисні рукавиці", "Захисний жилет", "Захисні чоботи", "Спортивний шолом", "Шкіряні рукавиці", "Шкіряний комбінезон")
    
    Set truckBrands = $ListBuild("Volvo", "MAN", "Scania", "Mercedes-Benz", "DAF", "Iveco", "Renault", "Ford")
    Set truckModels = $ListBuild("FH16", "TGX", "R-Series", "Actros", "XF", "Stralis", "Magnum", "F-MAX")
    Set truckColors = $ListBuild("Синій", "Червоний", "Білий", "Сірий", "Чорний")
    
    Set engineTypes = $ListBuild("Бензиновий", "Дизельний", "Гібридний", "Електричний")
    
    // Отримуємо всіх власників
    Set owners = ""
    &sql(DECLARE OwnerCursor CURSOR FOR SELECT %ID INTO :ownerId FROM Transport.Owner)
    &sql(OPEN OwnerCursor)
    Set ownerCount = 0
    For {
        &sql(FETCH OwnerCursor)
        Quit:SQLCODE'=0
        Set ownerCount = ownerCount + 1
        Set owners = owners_$ListBuild(ownerId)
    }
    &sql(CLOSE OwnerCursor)
    
    If ownerCount = 0 {
        Write "  Попередження: немає власників для призначення транспортним засобам",!
    }
    
    // Генерація автомобілів
    Set carCount = 0
    Set carTotal = count \ 3 + 1
    For i = 1:1:carTotal {
        Set car = ##class(Transport.Car).%New()
        
        Set brandIndex = (i - 1) # $ListLength(carBrands) + 1
        Set modelIndex = (i - 1) # $ListLength(carModels) + 1
        Set car.Brand = $List(carBrands, brandIndex)
        Set car.Model = $List(carModels, modelIndex)
        Set car.VIN = ..GenerateVIN("CAR"_i)
        Set car.Year = 2018 + (i # 6)  // Роки від 2018 до 2023
        Set car.Color = $List(carColors, (i - 1) # $ListLength(carColors) + 1)
        Set car.BodyType = $List(carBodyTypes, (i - 1) # $ListLength(carBodyTypes) + 1)
        
        // Призначаємо власника
        If ownerCount > 0 {
            Set ownerIndex = (i - 1) # ownerCount + 1
            Set car.Owner = ##class(Transport.Owner).%OpenId($List(owners, ownerIndex))
        }
        
        // Створюємо двигун
        Set engine = ##class(Transport.Engine).%New()
        Set engine.Type = $List(engineTypes, (i - 1) # 2 + 1)  // Бензиновий або Дизельний
        Set engine.HorsePower = 150 + ($R(250))  // Від 150 до 400 к.с.
        Set car.Engine = engine
        
        // Додаємо пасажирів
        Set passengerCount = 1 + $R(3)
        For p = 1:1:passengerCount {
            Do car.Passengers.Insert("Пасажир "_p_" в "_car.Brand_" "_car.Model)
        }
        
        Set sc = car.%Save()
        If $$$ISOK(sc) {
            Set carCount = carCount + 1
        } Else {
            Write "  Помилка збереження автомобіля "_i_": "_$System.Status.GetErrorText(sc),!
        }
    }
    Write "  Створено "_carCount_" автомобілів",!
    
    // Генерація мотоциклів
    Set motoCount = 0
    Set motoTotal = count \ 3 + 1
    For i = 1:1:motoTotal {
        Set moto = ##class(Transport.Motorcycle).%New()
        
        Set brandIndex = (i - 1) # $ListLength(motoBrands) + 1
        Set modelIndex = (i - 1) # $ListLength(motoModels) + 1
        Set moto.Brand = $List(motoBrands, brandIndex)
        Set moto.Model = $List(motoModels, modelIndex)
        Set moto.VIN = ..GenerateVIN("MOTO"_i)
        Set moto.Year = 2019 + (i # 5)  // Роки від 2019 до 2023
        Set moto.Color = $List(motoColors, (i - 1) # $ListLength(motoColors) + 1)
        Set moto.MotorcycleType = $List(motoTypes, (i - 1) # $ListLength(motoTypes) + 1)
        
        // Призначаємо власника
        If ownerCount > 0 {
            Set ownerIndex = (carTotal + i - 1) # ownerCount + 1
            Set moto.Owner = ##class(Transport.Owner).%OpenId($List(owners, ownerIndex))
        }
        
        // Створюємо двигун
        Set engine = ##class(Transport.Engine).%New()
        Set engine.Type = "Бензиновий"
        Set engine.HorsePower = 80 + ($R(150))  // Від 80 до 230 к.с.
        Set moto.Engine = engine
        
        // Додаємо спорядження
        Set gearCount = 3 + $R(4)
        For g = 1:1:gearCount {
            Set gearIndex = (g - 1) # $ListLength(motoGear) + 1
            Do moto.RequiredGear.SetAt($List(motoGear, gearIndex), g)
        }
        
        Set sc = moto.%Save()
        If $$$ISOK(sc) {
            Set motoCount = motoCount + 1
        } Else {
            Write "  Помилка збереження мотоцикла "_i_": "_$System.Status.GetErrorText(sc),!
        }
    }
    Write "  Створено "_motoCount_" мотоциклів",!
    
    // Генерація вантажівок
    Set truckCount = 0
    Set truckTotal = count \ 3
    For i = 1:1:truckTotal {
        Set truck = ##class(Transport.Truck).%New()
        
        Set brandIndex = (i - 1) # $ListLength(truckBrands) + 1
        Set modelIndex = (i - 1) # $ListLength(truckModels) + 1
        Set truck.Brand = $List(truckBrands, brandIndex)
        Set truck.Model = $List(truckModels, modelIndex)
        Set truck.VIN = ..GenerateVIN("TRUCK"_i)
        Set truck.Year = 2020 + (i # 4)  // Роки від 2020 до 2023
        Set truck.Color = $List(truckColors, (i - 1) # $ListLength(truckColors) + 1)
        Set truck.LoadCapacity = 10 + ($R(20))  // Від 10 до 30 тонн
        
        // Призначаємо власника
        If ownerCount > 0 {
            Set ownerIndex = (carTotal + motoTotal + i - 1) # ownerCount + 1
            Set truck.Owner = ##class(Transport.Owner).%OpenId($List(owners, ownerIndex))
        }
        
        // Створюємо двигун
        Set engine = ##class(Transport.Engine).%New()
        Set engine.Type = "Дизельний"
        Set engine.HorsePower = 300 + ($R(250))  // Від 300 до 550 к.с.
        Set truck.Engine = engine
        
        Set sc = truck.%Save()
        If $$$ISOK(sc) {
            Set truckCount = truckCount + 1
        } Else {
            Write "  Помилка збереження вантажівки "_i_": "_$System.Status.GetErrorText(sc),!
        }
    }
    Write "  Створено "_truckCount_" вантажівок",!
    
    Quit $$$OK
}

/// Генерація записів обслуговування
ClassMethod GenerateServiceRecords(count As %Integer) As %Status
{
    Write "Генерація записів обслуговування...",!
    
    Set descriptions = $ListBuild("Заміна масла", "Технічне обслуговування", "Заміна гальмівних колодок", "Заміна фільтрів", "Діагностика", "Ремонт двигуна", "Заміна шин", "Ремонт трансмісії")
    Set performers = $ListBuild("Сервісний центр", "Автосервіс", "Офіційний дилер", "Гараж")
    
    &sql(DECLARE VehicleCursor CURSOR FOR SELECT %ID INTO :vehicleId FROM Transport.Vehicle)
    &sql(OPEN VehicleCursor)
    Set vehicleCount = 0
    Set vehicles = ""
    For {
        &sql(FETCH VehicleCursor)
        Quit:SQLCODE'=0
        Set vehicleCount = vehicleCount + 1
        Set vehicles = vehicles_$ListBuild(vehicleId)
    }
    &sql(CLOSE VehicleCursor)
    
    If vehicleCount = 0 {
        Write "  Попередження: немає транспортних засобів для створення записів обслуговування",!
        Quit $$$OK
    }
    
    Set created = 0
    For i = 1:1:count {
        Set record = ##class(Transport.ServiceRecord).%New()
        
        // Вибираємо випадковий транспортний засіб
        Set vehicleIndex = (i - 1) # vehicleCount + 1
        Set vehicle = ##class(Transport.Vehicle).%OpenId($List(vehicles, vehicleIndex))
        If '$IsObject(vehicle) Continue
        
        Set record.Vehicle = vehicle
        Set record.ServiceDate = +($H - (30 + $R(365)))  // Від 30 днів до 1 року тому (тільки дата)
        Set record.Description = $List(descriptions, (i - 1) # $ListLength(descriptions) + 1)
        Set record.Cost = 500 + ($R(10000))  // Від 500 до 10500 грн
        Set record.PerformedBy = $List(performers, (i - 1) # $ListLength(performers) + 1)_" "_vehicle.Brand
        Set record.Mileage = vehicle.CurrentMileage - (1000 + $R(10000))
        
        Set sc = record.%Save()
        If $$$ISERR(sc) {
            Write "  Помилка збереження запису "_i_": "_$System.Status.GetErrorText(sc),!
            Continue
        }
        Set created = created + 1
    }
    
    Write "  Створено "_created_" записів обслуговування",!
    Quit $$$OK
}

/// Генерація вантажу для вантажівок
ClassMethod GenerateCargoItems(count As %Integer) As %Status
{
    Write "Генерація вантажу...",!
    
    Set cargoNames = $ListBuild("Будівельні матеріали", "Металеві конструкції", "Харчові продукти", "Побутова техніка", "Деревина", "Цемент", "Зерно", "Меблі", "Електроніка", "Хімічні речовини")
    
    &sql(DECLARE TruckCursor CURSOR FOR SELECT %ID INTO :truckId FROM Transport.Truck)
    &sql(OPEN TruckCursor)
    Set truckCount = 0
    Set trucks = ""
    For {
        &sql(FETCH TruckCursor)
        Quit:SQLCODE'=0
        Set truckCount = truckCount + 1
        Set trucks = trucks_$ListBuild(truckId)
    }
    &sql(CLOSE TruckCursor)
    
    If truckCount = 0 {
        Write "  Попередження: немає вантажівок для додавання вантажу",!
        Quit $$$OK
    }
    
    Set created = 0
    For i = 1:1:count {
        // Вибираємо випадкову вантажівку
        Set truckIndex = (i - 1) # truckCount + 1
        Set truck = ##class(Transport.Truck).%OpenId($List(trucks, truckIndex))
        If '$IsObject(truck) Continue
        
        Set cargo = ##class(Transport.CargoItem).%New()
        Set cargo.Name = $List(cargoNames, (i - 1) # $ListLength(cargoNames) + 1)
        Set cargo.Weight = 1 + ($R(200) / 10)  // Від 1 до 20 тонн
        Set cargo.Truck = truck
        
        // Перевірка вантажопідйомності
        Set currentWeight = truck.GetTotalCargoWeight()
        If (currentWeight + cargo.Weight) > truck.LoadCapacity {
            Set cargo.Weight = truck.LoadCapacity - currentWeight - 0.1
            If cargo.Weight < 0 Continue  // Вантажівка повна
        }
        
        Set sc = cargo.%Save()
        If $$$ISERR(sc) {
            Write "  Помилка збереження вантажу "_i_": "_$System.Status.GetErrorText(sc),!
            Continue
        }
        Set created = created + 1
    }
    
    Write "  Створено "_created_" одиниць вантажу",!
    Quit $$$OK
}

/// Генерація унікального VIN
ClassMethod GenerateVIN(prefix As %String) As %String
{
    Set chars = "ABCDEFGHJKLMNPRSTUVWXYZ0123456789"
    Set vin = prefix
    For i = 1:1:(17 - $Length(prefix)) {
        Set vin = vin_$Extract(chars, $R($Length(chars)) + 1)
    }
    Quit vin
}

}
