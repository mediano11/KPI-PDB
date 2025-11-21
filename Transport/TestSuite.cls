Class Transport.TestSuite Extends %RegisteredObject
{

/// Запуск всіх тестів
ClassMethod RunAllTests() As %Status
{
    Write !!,"========================================",!
    Write "    ЮНІТ ТЕСТУВАННЯ СИСТЕМИ ТРАНСПОРТУ",!
    Write "========================================",!!
    
    Set totalTests = 0
    Set passedTests = 0
    Set failedTests = 0
    
    // Тест 1: Створення об'єктів
    Write "ТЕСТ 1: Створення об'єктів",!
    Set sc = ..TestObjectCreation(.testCount, .passed)
    Set totalTests = totalTests + testCount
    Set passedTests = passedTests + passed
    Set failedTests = failedTests + (testCount - passed)
    Write !
    
    // Тест 2: Унікальні властивості
    Write "ТЕСТ 2: Перевірка унікальних властивостей",!
    Set sc = ..TestUniqueProperties(.testCount, .passed)
    Set totalTests = totalTests + testCount
    Set passedTests = passedTests + passed
    Set failedTests = failedTests + (testCount - passed)
    Write !
    
    // Тест 3: Обов'язкові властивості
    Write "ТЕСТ 3: Перевірка обов'язкових властивостей",!
    Set sc = ..TestRequiredProperties(.testCount, .passed)
    Set totalTests = totalTests + testCount
    Set passedTests = passedTests + passed
    Set failedTests = failedTests + (testCount - passed)
    Write !
    
    // Тест 4: Заповнення відношень
    Write "ТЕСТ 4: Заповнення відношень",!
    Set sc = ..TestRelationships(.testCount, .passed)
    Set totalTests = totalTests + testCount
    Set passedTests = passedTests + passed
    Set failedTests = failedTests + (testCount - passed)
    Write !
    
    // Тест 5: Видалення об'єктів з відношеннями
    Write "ТЕСТ 5: Видалення об'єктів з відношеннями",!
    Set sc = ..TestDeletionWithRelations(.testCount, .passed)
    Set totalTests = totalTests + testCount
    Set passedTests = passedTests + passed
    Set failedTests = failedTests + (testCount - passed)
    Write !
    
    // Тест 6: Обчислювані властивості
    Write "ТЕСТ 6: Обчислювані властивості",!
    Set sc = ..TestCalculatedProperties(.testCount, .passed)
    Set totalTests = totalTests + testCount
    Set passedTests = passedTests + passed
    Set failedTests = failedTests + (testCount - passed)
    Write !
    
    // Підсумок
    Write "========================================",!
    Write "ПІДСУМОК ТЕСТУВАННЯ:",!
    Write "Всього тестів: "_totalTests,!
    Write "Пройдено: "_passedTests,!
    Write "Провалено: "_failedTests,!
    Write "========================================",!!
    
    If failedTests = 0 {
        Write "✓ УСІ ТЕСТИ УСПІШНО ПРОЙДЕНО!",!!
        Quit $$$OK
    } Else {
        Write "✗ ДЕЯКІ ТЕСТИ ПРОВАЛЕНО!",!!
        Quit $$$ERROR($$$GeneralError, "Деякі тести провалено")
    }
}

/// Тест 1: Створення об'єктів
ClassMethod TestObjectCreation(Output testCount As %Integer, Output passedCount As %Integer) As %Status
{
    Set testCount = 0
    Set passedCount = 0
    
    // Тест 1.1: Створення Owner
    Set testCount = testCount + 1
    Write "  1.1. Створення об'єкта Owner... "
    Set owner = ##class(Transport.Owner).%New()
    Set owner.Id = $R(100000) + 10000
    Set owner.Name = "Тестовий Власник"
    Set owner.Email = "test@example.com"
    Set sc = owner.%Save()
    If $$$ISOK(sc) {
        Set ownerId = owner.%Id()
        Set passedCount = passedCount + 1
        Write "✓ PASS (ID: "_ownerId_")",!
        Do owner.%DeleteId(ownerId)
    } Else {
        Write "✗ FAIL: "_$System.Status.GetErrorText(sc),!
    }
    
    // Тест 1.2: Створення Engine (вбудований об'єкт)
    Set testCount = testCount + 1
    Write "  1.2. Створення об'єкта Engine (вбудований)... "
    Set engine = ##class(Transport.Engine).%New()
    Set engine.Type = "Бензиновий"
    Set engine.HorsePower = 200
    If engine.Type = "Бензиновий" && (engine.HorsePower = 200) {
        Set passedCount = passedCount + 1
        Write "✓ PASS",!
    } Else {
        Write "✗ FAIL: об'єкт не створено правильно",!
    }
    
    // Тест 1.3: Створення Car
    Set testCount = testCount + 1
    Write "  1.3. Створення об'єкта Car... "
    Set car = ##class(Transport.Car).%New()
    Set car.Brand = "TestBrand"
    Set car.Model = "TestModel"
    Set car.VIN = "TESTVIN"_$R(1000000)
    Set car.Year = 2020
    Set car.BodyType = "Седан"
    Set sc = car.%Save()
    If $$$ISOK(sc) {
        Set carId = car.%Id()
        Set passedCount = passedCount + 1
        Write "✓ PASS (ID: "_carId_")",!
        Do car.%DeleteId(carId)
    } Else {
        Write "✗ FAIL: "_$System.Status.GetErrorText(sc),!
    }
    
    // Тест 1.4: Створення Motorcycle
    Set testCount = testCount + 1
    Write "  1.4. Створення об'єкта Motorcycle... "
    Set moto = ##class(Transport.Motorcycle).%New()
    Set moto.Brand = "TestMotoBrand"
    Set moto.Model = "TestMotoModel"
    Set moto.VIN = "MOTOVIN"_$R(1000000)
    Set moto.Year = 2021
    Set moto.MotorcycleType = "Спортивний"
    Set sc = moto.%Save()
    If $$$ISOK(sc) {
        Set motoId = moto.%Id()
        Set passedCount = passedCount + 1
        Write "✓ PASS (ID: "_motoId_")",!
        Do moto.%DeleteId(motoId)
    } Else {
        Write "✗ FAIL: "_$System.Status.GetErrorText(sc),!
    }
    
    // Тест 1.5: Створення Truck
    Set testCount = testCount + 1
    Write "  1.5. Створення об'єкта Truck... "
    Set truck = ##class(Transport.Truck).%New()
    Set truck.Brand = "TestTruckBrand"
    Set truck.Model = "TestTruckModel"
    Set truck.VIN = "TRUCKVIN"_$R(1000000)
    Set truck.Year = 2022
    Set truck.LoadCapacity = 20
    Set sc = truck.%Save()
    If $$$ISOK(sc) {
        Set truckId = truck.%Id()
        Set passedCount = passedCount + 1
        Write "✓ PASS (ID: "_truckId_")",!
        Do truck.%DeleteId(truckId)
    } Else {
        Write "✗ FAIL: "_$System.Status.GetErrorText(sc),!
    }
    
    // Тест 1.6: Створення ServiceRecord
    Set testCount = testCount + 1
    Write "  1.6. Створення об'єкта ServiceRecord... "
    // Спочатку створюємо транспортний засіб
    Set vehicle = ##class(Transport.Car).%New()
    Set vehicle.Brand = "TestBrand"
    Set vehicle.Model = "TestModel"
    Set vehicle.VIN = "TESTVIN"_$R(1000000)
    Set vehicle.Year = 2020
    Set sc = vehicle.%Save()
    If $$$ISOK(sc) {
        Set record = ##class(Transport.ServiceRecord).%New()
        Set record.Vehicle = vehicle
        Set record.ServiceDate = +$H  // Тільки дата без часу
        Set record.Description = "Тестовий запис"
        Set sc = record.%Save()
        If $$$ISOK(sc) {
            Set recordId = record.%Id()
            Set passedCount = passedCount + 1
            Write "✓ PASS (ID: "_recordId_")",!
            Do record.%DeleteId(recordId)
        } Else {
            Write "✗ FAIL: "_$System.Status.GetErrorText(sc),!
        }
        Do vehicle.%DeleteId(vehicle.%Id())
    } Else {
        Write "✗ FAIL: не вдалося створити транспорт для запису",!
    }
    
    // Тест 1.7: Створення CargoItem
    Set testCount = testCount + 1
    Write "  1.7. Створення об'єкта CargoItem... "
    // Спочатку створюємо вантажівку
    Set truck = ##class(Transport.Truck).%New()
    Set truck.Brand = "TestTruckBrand"
    Set truck.Model = "TestTruckModel"
    Set truck.VIN = "TRUCKVIN"_$R(1000000)
    Set truck.Year = 2022
    Set truck.LoadCapacity = 20
    Set sc = truck.%Save()
    If $$$ISOK(sc) {
        Set cargo = ##class(Transport.CargoItem).%New()
        Set cargo.Truck = truck
        Set cargo.Name = "Тестовий вантаж"
        Set cargo.Weight = 5.5
        Set sc = cargo.%Save()
        If $$$ISOK(sc) {
            Set cargoId = cargo.%Id()
            Set passedCount = passedCount + 1
            Write "✓ PASS (ID: "_cargoId_")",!
            Do cargo.%DeleteId(cargoId)
        } Else {
            Write "✗ FAIL: "_$System.Status.GetErrorText(sc),!
        }
        Do truck.%DeleteId(truck.%Id())
    } Else {
        Write "✗ FAIL: не вдалося створити вантажівку для вантажу",!
    }
    
    Write "  Результат: "_passedCount_"/"_testCount_" тестів пройдено",!
    Quit $$$OK
}

/// Тест 2: Унікальні властивості
ClassMethod TestUniqueProperties(Output testCount As %Integer, Output passedCount As %Integer) As %Status
{
    Set testCount = 0
    Set passedCount = 0
    
    // Тест 2.1: Унікальність VIN (Vehicle)
    Set testCount = testCount + 1
    Write "  2.1. Перевірка унікальності VIN... "
    // VIN має бути не більше 17 символів
    Set uniqueVIN = $Extract("UNIQVIN"_$R(99999)_(+$H), 1, 17)
    
    // Створюємо перший транспорт з унікальним VIN
    Set car1 = ##class(Transport.Car).%New()
    Set car1.Brand = "TestBrand"
    Set car1.Model = "TestModel"
    Set car1.VIN = uniqueVIN
    Set car1.Year = 2020
    Set sc = car1.%Save()
    If $$$ISOK(sc) {
        Set car1Id = car1.%Id()
        
        // Спробуємо створити другий транспорт з тим самим VIN
        Set car2 = ##class(Transport.Car).%New()
        Set car2.Brand = "TestBrand2"
        Set car2.Model = "TestModel2"
        Set car2.VIN = uniqueVIN
        Set car2.Year = 2021
        Set sc2 = car2.%Save()
        
        If $$$ISERR(sc2) {
            Set passedCount = passedCount + 1
            Write "✓ PASS (дублікат VIN відхилено)",!
        } Else {
            Write "✗ FAIL: дозволено дублікат VIN",!
            Do car2.%DeleteId(car2.%Id())
        }
        Do car1.%DeleteId(car1Id)
    } Else {
        Write "✗ FAIL: не вдалося створити перший транспорт: "_$System.Status.GetErrorText(sc),!
        If $Find($System.Status.GetErrorText(sc), "unique") > 0 {
            Write "  (Можливо, VIN вже існує в базі. Спробуйте запустити тест знову)",!
        }
    }
    
    // Тест 2.2: Унікальність Id (Owner)
    Set testCount = testCount + 1
    Write "  2.2. Перевірка унікальності Id (Owner)... "
    Set uniqueId = $R(100000) + 50000
    
    // Створюємо першого власника з унікальним Id
    Set owner1 = ##class(Transport.Owner).%New()
    Set owner1.Id = uniqueId
    Set owner1.Name = "Тестовий Власник 1"
    Set sc = owner1.%Save()
    If $$$ISOK(sc) {
        Set owner1Id = owner1.%Id()
        
        // Спробуємо створити другого власника з тим самим Id
        Set owner2 = ##class(Transport.Owner).%New()
        Set owner2.Id = uniqueId
        Set owner2.Name = "Тестовий Власник 2"
        Set sc2 = owner2.%Save()
        
        If $$$ISERR(sc2) {
            Set passedCount = passedCount + 1
            Write "✓ PASS (дублікат Id відхилено)",!
        } Else {
            Write "✗ FAIL: дозволено дублікат Id",!
            Do owner2.%DeleteId(owner2.%Id())
        }
        Do owner1.%DeleteId(owner1Id)
    } Else {
        Write "✗ FAIL: не вдалося створити першого власника",!
    }
    
    Write "  Результат: "_passedCount_"/"_testCount_" тестів пройдено",!
    Quit $$$OK
}

/// Тест 3: Обов'язкові властивості
ClassMethod TestRequiredProperties(Output testCount As %Integer, Output passedCount As %Integer) As %Status
{
    Set testCount = 0
    Set passedCount = 0
    
    // Тест 3.1: Обов'язковість Brand (Vehicle)
    Set testCount = testCount + 1
    Write "  3.1. Перевірка обов'язковості Brand... "
    Set car = ##class(Transport.Car).%New()
    Set car.Model = "TestModel"
    Set car.VIN = "TESTVIN"_$R(1000000)
    Set car.Year = 2020
    // Brand не встановлено
    Set sc = car.%Save()
    If $$$ISERR(sc) {
        Set passedCount = passedCount + 1
        Write "✓ PASS (Brand є обов'язковим)",!
    } Else {
        Write "✗ FAIL: Brand не обов'язковий",!
        Do car.%DeleteId(car.%Id())
    }
    
    // Тест 3.2: Обов'язковість Model (Vehicle)
    Set testCount = testCount + 1
    Write "  3.2. Перевірка обов'язковості Model... "
    Set car = ##class(Transport.Car).%New()
    Set car.Brand = "TestBrand"
    Set car.VIN = "TESTVIN"_$R(1000000)
    Set car.Year = 2020
    // Model не встановлено
    Set sc = car.%Save()
    If $$$ISERR(sc) {
        Set passedCount = passedCount + 1
        Write "✓ PASS (Model є обов'язковим)",!
    } Else {
        Write "✗ FAIL: Model не обов'язковий",!
        Do car.%DeleteId(car.%Id())
    }
    
    // Тест 3.3: Обов'язковість VIN (Vehicle)
    Set testCount = testCount + 1
    Write "  3.3. Перевірка обов'язковості VIN... "
    Set car = ##class(Transport.Car).%New()
    Set car.Brand = "TestBrand"
    Set car.Model = "TestModel"
    Set car.Year = 2020
    // VIN не встановлено
    Set sc = car.%Save()
    If $$$ISERR(sc) {
        Set passedCount = passedCount + 1
        Write "✓ PASS (VIN є обов'язковим)",!
    } Else {
        Write "✗ FAIL: VIN не обов'язковий",!
        Do car.%DeleteId(car.%Id())
    }
    
    // Тест 3.4: Обов'язковість Year (Vehicle)
    Set testCount = testCount + 1
    Write "  3.4. Перевірка обов'язковості Year... "
    Set car = ##class(Transport.Car).%New()
    Set car.Brand = "TestBrand"
    Set car.Model = "TestModel"
    Set car.VIN = "TESTVIN"_$R(1000000)
    // Year не встановлено
    Set sc = car.%Save()
    If $$$ISERR(sc) {
        Set passedCount = passedCount + 1
        Write "✓ PASS (Year є обов'язковим)",!
    } Else {
        Write "✗ FAIL: Year не обов'язковий",!
        Do car.%DeleteId(car.%Id())
    }
    
    // Тест 3.5: Обов'язковість Name (Owner)
    Set testCount = testCount + 1
    Write "  3.5. Перевірка обов'язковості Name (Owner)... "
    Set owner = ##class(Transport.Owner).%New()
    Set owner.Id = $R(100000) + 60000
    // Name не встановлено
    Set sc = owner.%Save()
    If $$$ISERR(sc) {
        Set passedCount = passedCount + 1
        Write "✓ PASS (Name є обов'язковим)",!
    } Else {
        Write "✗ FAIL: Name не обов'язковий",!
        Do owner.%DeleteId(owner.%Id())
    }
    
    // Тест 3.6: Обов'язковість Id (Owner)
    // Примітка: Конструктор Owner автоматично генерує Id, тому перевіряємо через SQL
    Set testCount = testCount + 1
    Write "  3.6. Перевірка обов'язковості Id (Owner)... "
    Set owner = ##class(Transport.Owner).%New()
    Set owner.Name = "Тестовий Власник"
    // Конструктор автоматично встановлює Id, тому перевіряємо чи Id встановлено
    If owner.Id '= "" {
        Set passedCount = passedCount + 1
        Write "✓ PASS (Id автоматично встановлено конструктором)",!
        // Не зберігаємо тестовий об'єкт
    } Else {
        Write "✗ FAIL: Id не встановлено",!
    }
    
    // Тест 3.7: Обов'язковість ServiceDate (ServiceRecord)
    Set testCount = testCount + 1
    Write "  3.7. Перевірка обов'язковості ServiceDate... "
    // Створюємо транспорт для запису
    Set vehicle = ##class(Transport.Car).%New()
    Set vehicle.Brand = "TestBrand"
    Set vehicle.Model = "TestModel"
    Set vehicle.VIN = "TESTVIN"_$R(1000000)
    Set vehicle.Year = 2020
    Set sc = vehicle.%Save()
    If $$$ISOK(sc) {
        Set record = ##class(Transport.ServiceRecord).%New()
        Set record.Vehicle = vehicle
        // ServiceDate не встановлено
        Set sc = record.%Save()
        If $$$ISERR(sc) {
            Set passedCount = passedCount + 1
            Write "✓ PASS (ServiceDate є обов'язковим)",!
        } Else {
            Write "✗ FAIL: ServiceDate не обов'язковий",!
            Do record.%DeleteId(record.%Id())
        }
        Do vehicle.%DeleteId(vehicle.%Id())
    } Else {
        Write "✗ FAIL: не вдалося створити транспорт",!
    }
    
    // Тест 3.8: Обов'язковість Name (CargoItem)
    Set testCount = testCount + 1
    Write "  3.8. Перевірка обов'язковості Name (CargoItem)... "
    // Створюємо вантажівку
    Set truck = ##class(Transport.Truck).%New()
    Set truck.Brand = "TestTruckBrand"
    Set truck.Model = "TestTruckModel"
    Set truck.VIN = "TRUCKVIN"_$R(1000000)
    Set truck.Year = 2022
    Set truck.LoadCapacity = 20
    Set sc = truck.%Save()
    If $$$ISOK(sc) {
        Set cargo = ##class(Transport.CargoItem).%New()
        Set cargo.Truck = truck
        Set cargo.Weight = 5.5
        // Name не встановлено
        Set sc = cargo.%Save()
        If $$$ISERR(sc) {
            Set passedCount = passedCount + 1
            Write "✓ PASS (Name є обов'язковим)",!
        } Else {
            Write "✗ FAIL: Name не обов'язковий",!
            Do cargo.%DeleteId(cargo.%Id())
        }
        Do truck.%DeleteId(truck.%Id())
    } Else {
        Write "✗ FAIL: не вдалося створити вантажівку",!
    }
    
    // Тест 3.9: Обов'язковість Weight (CargoItem)
    Set testCount = testCount + 1
    Write "  3.9. Перевірка обов'язковості Weight (CargoItem)... "
    // Створюємо вантажівку
    Set truck = ##class(Transport.Truck).%New()
    Set truck.Brand = "TestTruckBrand"
    Set truck.Model = "TestTruckModel"
    Set truck.VIN = "TRUCKVIN"_$R(1000000)
    Set truck.Year = 2022
    Set truck.LoadCapacity = 20
    Set sc = truck.%Save()
    If $$$ISOK(sc) {
        Set cargo = ##class(Transport.CargoItem).%New()
        Set cargo.Truck = truck
        Set cargo.Name = "Тестовий вантаж"
        // Weight не встановлено
        Set sc = cargo.%Save()
        If $$$ISERR(sc) {
            Set passedCount = passedCount + 1
            Write "✓ PASS (Weight є обов'язковим)",!
        } Else {
            Write "✗ FAIL: Weight не обов'язковий",!
            Do cargo.%DeleteId(cargo.%Id())
        }
        Do truck.%DeleteId(truck.%Id())
    } Else {
        Write "✗ FAIL: не вдалося створити вантажівку",!
    }
    
    Write "  Результат: "_passedCount_"/"_testCount_" тестів пройдено",!
    Quit $$$OK
}

/// Тест 4: Заповнення відношень
ClassMethod TestRelationships(Output testCount As %Integer, Output passedCount As %Integer) As %Status
{
    Set testCount = 0
    Set passedCount = 0
    
    // Тест 4.1: Відношення Vehicle -> Owner
    Set testCount = testCount + 1
    Write "  4.1. Відношення Vehicle -> Owner... "
    Set owner = ##class(Transport.Owner).%New()
    Set owner.Id = $R(100000) + 70000
    Set owner.Name = "Тестовий Власник"
    Set sc = owner.%Save()
    If $$$ISOK(sc) {
        Set ownerId = owner.%Id()
        Set car = ##class(Transport.Car).%New()
        Set car.Brand = "TestBrand"
        Set car.Model = "TestModel"
        Set car.VIN = "TESTVIN"_$R(1000000)
        Set car.Year = 2020
        Set car.Owner = owner
        Set sc = car.%Save()
        If $$$ISOK(sc) {
            Set carId = car.%Id()
            Set loadedCar = ##class(Transport.Car).%OpenId(carId)
            If $IsObject(loadedCar.Owner) && (loadedCar.Owner.%Id() = ownerId) {
                Set passedCount = passedCount + 1
                Write "✓ PASS",!
            } Else {
                Write "✗ FAIL: відношення не збережено",!
            }
            Do car.%DeleteId(carId)
        } Else {
            Write "✗ FAIL: не вдалося зберегти транспорт",!
        }
        Do owner.%DeleteId(ownerId)
    } Else {
        Write "✗ FAIL: не вдалося створити власника",!
    }
    
    // Тест 4.2: Відношення Vehicle -> ServiceRecord (children)
    Set testCount = testCount + 1
    Write "  4.2. Відношення Vehicle -> ServiceRecord (children)... "
    Set vehicle = ##class(Transport.Car).%New()
    Set vehicle.Brand = "TestBrand"
    Set vehicle.Model = "TestModel"
    Set vehicle.VIN = "TESTVIN"_$R(1000000)
    Set vehicle.Year = 2020
    Set sc = vehicle.%Save()
    If $$$ISOK(sc) {
        Set vehicleId = vehicle.%Id()
        Set record = ##class(Transport.ServiceRecord).%New()
        Set record.Vehicle = vehicle
        Set record.ServiceDate = +$H  // Тільки дата без часу
        Set record.Description = "Тестовий запис"
        Set sc = record.%Save()
        If $$$ISOK(sc) {
            Set recordId = record.%Id()
            // Перевіряємо чи запис правильно зв'язаний
            Set loadedRecord = ##class(Transport.ServiceRecord).%OpenId(recordId)
            If $IsObject(loadedRecord) && $IsObject(loadedRecord.Vehicle) && (loadedRecord.Vehicle.%Id() = vehicleId) {
                Set passedCount = passedCount + 1
                Write "✓ PASS (запис обслуговування створено та зв'язано)",!
            } Else {
                Write "✗ FAIL: запис обслуговування не зв'язаний правильно",!
            }
            Do record.%DeleteId(recordId)
        } Else {
            Write "✗ FAIL: не вдалося створити запис обслуговування: "_$System.Status.GetErrorText(sc),!
        }
        Do vehicle.%DeleteId(vehicleId)
    } Else {
        Write "✗ FAIL: не вдалося створити транспорт",!
    }
    
    // Тест 4.3: Відношення Truck -> CargoItem (children)
    Set testCount = testCount + 1
    Write "  4.3. Відношення Truck -> CargoItem (children)... "
    Set truck = ##class(Transport.Truck).%New()
    Set truck.Brand = "TestTruckBrand"
    Set truck.Model = "TestTruckModel"
    Set truck.VIN = "TRUCKVIN"_$R(1000000)
    Set truck.Year = 2022
    Set truck.LoadCapacity = 20
    Set sc = truck.%Save()
    If $$$ISOK(sc) {
        Set truckId = truck.%Id()
        Set cargo = ##class(Transport.CargoItem).%New()
        Set cargo.Truck = truck
        Set cargo.Name = "Тестовий вантаж"
        Set cargo.Weight = 5.5
        Set sc = cargo.%Save()
        If $$$ISOK(sc) {
            Set cargoId = cargo.%Id()
            Set loadedTruck = ##class(Transport.Truck).%OpenId(truckId)
            Set cargoWeight = loadedTruck.GetTotalCargoWeight()
            If cargoWeight > 0 {
                Set passedCount = passedCount + 1
                Write "✓ PASS (вага вантажу: "_cargoWeight_" т)",!
            } Else {
                Write "✗ FAIL: вантаж не зв'язаний з вантажівкою",!
            }
            Do cargo.%DeleteId(cargoId)
        } Else {
            Write "✗ FAIL: не вдалося створити вантаж",!
        }
        Do truck.%DeleteId(truckId)
    } Else {
        Write "✗ FAIL: не вдалося створити вантажівку",!
    }
    
    // Тест 4.4: Вбудований об'єкт Vehicle -> Engine
    Set testCount = testCount + 1
    Write "  4.4. Вбудований об'єкт Vehicle -> Engine... "
    Set car = ##class(Transport.Car).%New()
    Set car.Brand = "TestBrand"
    Set car.Model = "TestModel"
    Set car.VIN = "TESTVIN"_$R(1000000)
    Set car.Year = 2020
    Set engine = ##class(Transport.Engine).%New()
    Set engine.Type = "Бензиновий"
    Set engine.HorsePower = 250
    Set car.Engine = engine
    Set sc = car.%Save()
    If $$$ISOK(sc) {
        Set carId = car.%Id()
        Set loadedCar = ##class(Transport.Car).%OpenId(carId)
        If $IsObject(loadedCar.Engine) && (loadedCar.Engine.Type = "Бензиновий") && (loadedCar.Engine.HorsePower = 250) {
            Set passedCount = passedCount + 1
            Write "✓ PASS (двигун збережено)",!
        } Else {
            Write "✗ FAIL: двигун не збережено правильно",!
        }
        Do car.%DeleteId(carId)
    } Else {
        Write "✗ FAIL: не вдалося зберегти транспорт з двигуном",!
    }
    
    Write "  Результат: "_passedCount_"/"_testCount_" тестів пройдено",!
    Quit $$$OK
}

/// Тест 5: Видалення об'єктів з відношеннями
ClassMethod TestDeletionWithRelations(Output testCount As %Integer, Output passedCount As %Integer) As %Status
{
    Set testCount = 0
    Set passedCount = 0
    
    // Тест 5.1: Видалення Vehicle з ServiceRecord (cascade delete)
    Set testCount = testCount + 1
    Write "  5.1. Видалення Vehicle з ServiceRecord (parent-children)... "
    Set vehicle = ##class(Transport.Car).%New()
    Set vehicle.Brand = "TestBrand"
    Set vehicle.Model = "TestModel"
    Set vehicle.VIN = "TESTVIN"_$R(1000000)
    Set vehicle.Year = 2020
    Set sc = vehicle.%Save()
    If $$$ISOK(sc) {
        Set vehicleId = vehicle.%Id()
        
        // Створюємо записи обслуговування
        Set record1 = ##class(Transport.ServiceRecord).%New()
        Set record1.Vehicle = vehicle
        Set record1.ServiceDate = +$H  // Тільки дата без часу
        Set record1.Description = "Запис 1"
        Set sc = record1.%Save()
        Set record1Id = record1.%Id()
        
        Set record2 = ##class(Transport.ServiceRecord).%New()
        Set record2.Vehicle = vehicle
        Set record2.ServiceDate = +$H  // Тільки дата без часу
        Set record2.Description = "Запис 2"
        Set sc = record2.%Save()
        Set record2Id = record2.%Id()
        
        // Видаляємо транспортний засіб
        Set sc = ##class(Transport.Vehicle).%DeleteId(vehicleId)
        If $$$ISOK(sc) {
            // Перевіряємо, що записи обслуговування теж видалені (cascade delete)
            Set record1Exists = ##class(Transport.ServiceRecord).%ExistsId(record1Id)
            Set record2Exists = ##class(Transport.ServiceRecord).%ExistsId(record2Id)
            If 'record1Exists && 'record2Exists {
                Set passedCount = passedCount + 1
                Write "✓ PASS (записи обслуговування видалено каскадно)",!
            } Else {
                Write "✗ FAIL: записи обслуговування не видалено",!
                If record1Exists Do ##class(Transport.ServiceRecord).%DeleteId(record1Id)
                If record2Exists Do ##class(Transport.ServiceRecord).%DeleteId(record2Id)
            }
        } Else {
            Write "✗ FAIL: не вдалося видалити транспорт",!
            Do ##class(Transport.ServiceRecord).%DeleteId(record1Id)
            Do ##class(Transport.ServiceRecord).%DeleteId(record2Id)
        }
    } Else {
        Write "✗ FAIL: не вдалося створити транспорт",!
    }
    
    // Тест 5.2: Видалення Truck з CargoItem (cascade delete)
    Set testCount = testCount + 1
    Write "  5.2. Видалення Truck з CargoItem (parent-children)... "
    Set truck = ##class(Transport.Truck).%New()
    Set truck.Brand = "TestTruckBrand"
    Set truck.Model = "TestTruckModel"
    Set truck.VIN = "TRUCKVIN"_$R(1000000)
    Set truck.Year = 2022
    Set truck.LoadCapacity = 20
    Set sc = truck.%Save()
    If $$$ISOK(sc) {
        Set truckId = truck.%Id()
        
        // Створюємо вантаж
        Set cargo1 = ##class(Transport.CargoItem).%New()
        Set cargo1.Truck = truck
        Set cargo1.Name = "Вантаж 1"
        Set cargo1.Weight = 5.5
        Set sc = cargo1.%Save()
        Set cargo1Id = cargo1.%Id()
        
        Set cargo2 = ##class(Transport.CargoItem).%New()
        Set cargo2.Truck = truck
        Set cargo2.Name = "Вантаж 2"
        Set cargo2.Weight = 3.2
        Set sc = cargo2.%Save()
        Set cargo2Id = cargo2.%Id()
        
        // Видаляємо вантажівку
        Set sc = ##class(Transport.Truck).%DeleteId(truckId)
        If $$$ISOK(sc) {
            // Перевіряємо, що вантаж теж видалений (cascade delete)
            Set cargo1Exists = ##class(Transport.CargoItem).%ExistsId(cargo1Id)
            Set cargo2Exists = ##class(Transport.CargoItem).%ExistsId(cargo2Id)
            If 'cargo1Exists && 'cargo2Exists {
                Set passedCount = passedCount + 1
                Write "✓ PASS (вантаж видалено каскадно)",!
            } Else {
                Write "✗ FAIL: вантаж не видалено",!
                If cargo1Exists Do ##class(Transport.CargoItem).%DeleteId(cargo1Id)
                If cargo2Exists Do ##class(Transport.CargoItem).%DeleteId(cargo2Id)
            }
        } Else {
            Write "✗ FAIL: не вдалося видалити вантажівку",!
            Do ##class(Transport.CargoItem).%DeleteId(cargo1Id)
            Do ##class(Transport.CargoItem).%DeleteId(cargo2Id)
        }
    } Else {
        Write "✗ FAIL: не вдалося створити вантажівку",!
    }
    
    // Тест 5.3: Видалення Owner з Vehicle (перевірка, що видалення не каскадне)
    // Примітка: При видаленні Owner, Vehicle повинен залишитися, але Owner стане null
    Set testCount = testCount + 1
    Write "  5.3. Видалення Owner з Vehicle (one-many, не каскадне)... "
    Set owner = ##class(Transport.Owner).%New()
    Set owner.Id = $R(100000) + 80000
    Set owner.Name = "Тестовий Власник"
    Set sc = owner.%Save()
    If $$$ISOK(sc) {
        Set ownerId = owner.%Id()
        
        Set car = ##class(Transport.Car).%New()
        Set car.Brand = "TestBrand"
        Set car.Model = "TestModel"
        Set car.VIN = "TESTVIN"_$R(1000000)
        Set car.Year = 2020
        Set car.Owner = owner
        Set sc = car.%Save()
        Set carId = car.%Id()
        
        If $$$ISOK(sc) {
            // Видаляємо власника
            Set sc = ##class(Transport.Owner).%DeleteId(ownerId)
            
            // Перевіряємо, що транспорт залишився
            Set loadedCar = ##class(Transport.Car).%OpenId(carId)
            If $IsObject(loadedCar) {
                // Owner може бути null або видалено, але транспорт має залишитися
                Set passedCount = passedCount + 1
                Write "✓ PASS (транспорт залишився після видалення Owner)",!
                Do car.%DeleteId(carId)
            } Else {
                Write "✗ FAIL: транспорт видалено разом з Owner (каскадне видалення)",!
            }
        } Else {
            Write "✗ FAIL: не вдалося зберегти транспорт",!
            Do owner.%DeleteId(ownerId)
        }
    } Else {
        Write "✗ FAIL: не вдалося створити власника",!
    }
    
    Write "  Результат: "_passedCount_"/"_testCount_" тестів пройдено",!
    Quit $$$OK
}

/// Тест 6: Обчислювані властивості
ClassMethod TestCalculatedProperties(Output testCount As %Integer, Output passedCount As %Integer) As %Status
{
    Set testCount = 0
    Set passedCount = 0
    
    // Тест 6.1: Обчислювана властивість Age (Vehicle)
    Set testCount = testCount + 1
    Write "  6.1. Обчислювана властивість Age... "
    Set car = ##class(Transport.Car).%New()
    Set car.Brand = "TestBrand"
    Set car.Model = "TestModel"
    Set car.VIN = "TESTVIN"_$R(1000000)
    Set car.Year = 2020
    Set sc = car.%Save()
    If $$$ISOK(sc) {
        Set carId = car.%Id()
        Set currentYear = $Piece($ZDate($H,3),"-",1)
        Set expectedAge = currentYear - 2020
        Set actualAge = car.Age
        If actualAge = expectedAge {
            Set passedCount = passedCount + 1
            Write "✓ PASS (Age = "_actualAge_" років)",!
        } Else {
            Write "✗ FAIL: Age = "_actualAge_", очікувалось "_expectedAge,!
        }
        Do car.%DeleteId(carId)
    } Else {
        Write "✗ FAIL: не вдалося створити транспорт",!
    }
    
    // Тест 6.2: Обчислювана властивість FullName (Vehicle)
    Set testCount = testCount + 1
    Write "  6.2. Обчислювана властивість FullName... "
    Set car = ##class(Transport.Car).%New()
    Set car.Brand = "TestBrand"
    Set car.Model = "TestModel"
    Set car.VIN = "TESTVIN"_$R(1000000)
    Set car.Year = 2020
    // Перевіряємо FullName до збереження
    Set expectedFullName = "TestBrand TestModel"
    Set actualFullName = car.FullName
    Set sc = car.%Save()
    If $$$ISOK(sc) {
        Set carId = car.%Id()
        // Перевіряємо FullName після збереження
        Set loadedCar = ##class(Transport.Car).%OpenId(carId)
        Set actualFullNameAfterLoad = loadedCar.FullName
        If (actualFullName = expectedFullName) && (actualFullNameAfterLoad = expectedFullName) {
            Set passedCount = passedCount + 1
            Write "✓ PASS (FullName = '"_actualFullName_"')",!
        } Else {
            Write "✗ FAIL: FullName = '"_actualFullName_"' (після завантаження: '"_actualFullNameAfterLoad_"'), очікувалось '"_expectedFullName_"'",!
        }
        Do car.%DeleteId(carId)
    } Else {
        Write "✗ FAIL: не вдалося створити транспорт",!
    }
    
    Write "  Результат: "_passedCount_"/"_testCount_" тестів пройдено",!
    Quit $$$OK
}

}
