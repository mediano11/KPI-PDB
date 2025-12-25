Class Transport.SOAP.VehicleService Extends %SOAP.WebService
{

/// Ім'я веб-сервісу
Parameter SERVICENAME = "VehicleService";

/// Namespace для SOAP
Parameter NAMESPACE = "http://tempuri.org";

/// Використовувати літерали в WSDL
Parameter USECLASSNAMESPACES = 1;

/// Створити транспортний засіб
Method CreateVehicle(type As %String, brand As %String, model As %String, vin As %String, year As %Integer, color As %String, engineType As %String, horsePower As %Integer, bodyType As %String, loadCapacity As %Numeric, ownerId As %Integer) As %String [ WebMethod ]
{
    Set result = ""
    Try {
        Set className = "Transport."_type
        Set vehicle = $ClassMethod(className, "%New")
        
        Set vehicle.Brand = brand
        Set vehicle.Model = model
        Set vehicle.VIN = vin
        Set vehicle.Year = year
        If color '= "" Set vehicle.Color = color
        
        // Створення двигуна
        If engineType '= "" || (horsePower '= "") {
            Set engine = ##class(Transport.Engine).%New()
            If engineType '= "" Set engine.Type = engineType
            If horsePower '= "" Set engine.HorsePower = horsePower
            Set vehicle.Engine = engine
        }
        
        // Специфічні властивості
        If type = "Car" && (bodyType '= "") {
            Set vehicle.BodyType = bodyType
        }
        If type = "Truck" && (loadCapacity '= "") {
            Set vehicle.LoadCapacity = loadCapacity
        }
        
        // Власник
        If ownerId '= "" {
            Set owner = ##class(Transport.Owner).%OpenId(ownerId)
            If $IsObject(owner) {
                Set vehicle.Owner = owner
            }
        }
        
        Set sc = vehicle.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Успішно створено. ID: "_vehicle.%Id()
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Отримати транспортний засіб за ID
Method GetVehicle(id As %Integer) As %String [ WebMethod ]
{
    Set vehicle = ##class(Transport.Vehicle).%OpenId(id)
    If '$IsObject(vehicle) {
        Return "Транспортний засіб не знайдено"
    }
    
    Set result = "ID: "_vehicle.%Id()_", Тип: "_vehicle.%ClassName()_", Марка: "_vehicle.Brand_", Модель: "_vehicle.Model_", VIN: "_vehicle.VIN_", Рік: "_vehicle.Year
    If vehicle.Color '= "" Set result = result_", Колір: "_vehicle.Color
    If $IsObject(vehicle.Engine) {
        Set result = result_", Двигун: "_vehicle.Engine.Type_" ("_vehicle.Engine.HorsePower_" к.с.)"
    }
    If $IsObject(vehicle.Owner) {
        Set result = result_", Власник: "_vehicle.Owner.Name
    }
    
    Return result
}

/// Отримати всі транспортні засоби
Method GetAllVehicles() As %String [ WebMethod ]
{
    Set result = ""
    Set count = 0
    Set rs = ##class(%ResultSet).%New("Transport.Vehicle:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set vehicleId = rs.Get("ID")
        Set vehicle = ##class(Transport.Vehicle).%OpenId(vehicleId)
        If $IsObject(vehicle) {
            Set count = count + 1
            If result '= "" Set result = result_"; "
            Set result = result_count_". "_vehicle.%ClassName()_" "_vehicle.Brand_" "_vehicle.Model_" (ID: "_vehicleId_")"
        }
    }
    
    If result = "" {
        Return "Транспортні засоби не знайдено"
    }
    
    Return "Всього: "_count_". "_result
}

/// Оновити транспортний засіб
Method UpdateVehicle(id As %Integer, brand As %String, model As %String, vin As %String, year As %Integer, color As %String) As %String [ WebMethod ]
{
    Set vehicle = ##class(Transport.Vehicle).%OpenId(id)
    If '$IsObject(vehicle) {
        Return "Транспортний засіб не знайдено"
    }
    
    Set result = ""
    Try {
        If brand '= "" Set vehicle.Brand = brand
        If model '= "" Set vehicle.Model = model
        If vin '= "" Set vehicle.VIN = vin
        If year '= "" Set vehicle.Year = year
        If color '= "" Set vehicle.Color = color
        
        Set sc = vehicle.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Транспортний засіб успішно оновлено"
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Видалити транспортний засіб
Method DeleteVehicle(id As %Integer) As %String [ WebMethod ]
{
    Set sc = ##class(Transport.Vehicle).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Return "Транспортний засіб успішно видалено"
    } Else {
        Return "Помилка: "_$System.Status.GetErrorText(sc)
    }
}

}
