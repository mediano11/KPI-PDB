Class Transport.REST.VehicleService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/vehicle" Method="GET" Call="GetAllVehicles"/>
    <Route Url="/vehicle/:id" Method="GET" Call="GetVehicle"/>
    <Route Url="/vehicle" Method="POST" Call="CreateVehicle"/>
    <Route Url="/vehicle/:id" Method="PUT" Call="UpdateVehicle"/>
    <Route Url="/vehicle/:id" Method="DELETE" Call="DeleteVehicle"/>
</Routes>
}

/// Отримати всі транспортні засоби
ClassMethod GetAllVehicles() As %Status
{
    Set %response.ContentType = "application/json"
    
    Set json = []
    Set rs = ##class(%ResultSet).%New("Transport.Vehicle:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set vehicleId = rs.Get("ID")
        Set vehicle = ##class(Transport.Vehicle).%OpenId(vehicleId)
        If $IsObject(vehicle) {
            Set obj = {}
            Set obj.id = vehicleId
            Set obj.type = vehicle.%ClassName()
            Set obj.brand = vehicle.Brand
            Set obj.model = vehicle.Model
            Set obj.vin = vehicle.VIN
            Set obj.year = vehicle.Year
            Set obj.color = vehicle.Color
            Set obj.currentMileage = vehicle.CurrentMileage
            
            If $IsObject(vehicle.Engine) {
                Set obj.engine = {}
                Set obj.engine.type = vehicle.Engine.Type
                Set obj.engine.horsePower = vehicle.Engine.HorsePower
            }
            
            If $IsObject(vehicle.Owner) {
                Set obj.owner = {}
                Set obj.owner.id = vehicle.Owner.Id
                Set obj.owner.name = vehicle.Owner.Name
            }
            
            If vehicle.%ClassName() = "Car" {
                Set obj.bodyType = vehicle.BodyType
            }
            
            If vehicle.%ClassName() = "Truck" {
                Set obj.loadCapacity = vehicle.LoadCapacity
            }
            
            Do json.%Push(obj)
        }
    }
    
    Write json.%ToJSON()
    Return $$$OK
}

/// Отримати транспортний засіб за ID
ClassMethod GetVehicle(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set vehicle = ##class(Transport.Vehicle).%OpenId(id)
    If '$IsObject(vehicle) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Транспортний засіб не знайдено"
        Write error.%ToJSON()
        Return $$$OK
    }
    
    Set obj = {}
    Set obj.id = vehicle.%Id()
    Set obj.type = vehicle.%ClassName()
    Set obj.brand = vehicle.Brand
    Set obj.model = vehicle.Model
    Set obj.vin = vehicle.VIN
    Set obj.year = vehicle.Year
    Set obj.color = vehicle.Color
    Set obj.currentMileage = vehicle.CurrentMileage
    
    If $IsObject(vehicle.Engine) {
        Set obj.engine = {}
        Set obj.engine.type = vehicle.Engine.Type
        Set obj.engine.horsePower = vehicle.Engine.HorsePower
    }
    
    If $IsObject(vehicle.Owner) {
        Set obj.owner = {}
        Set obj.owner.id = vehicle.Owner.Id
        Set obj.owner.name = vehicle.Owner.Name
    }
    
    If vehicle.%ClassName() = "Car" {
        Set obj.bodyType = vehicle.BodyType
    }
    
    If vehicle.%ClassName() = "Truck" {
        Set obj.loadCapacity = vehicle.LoadCapacity
    }
    
    Write obj.%ToJSON()
    Return $$$OK
}

/// Створити новий транспортний засіб
ClassMethod CreateVehicle() As %Status
{
    Set %response.ContentType = "application/json"
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        Set vehicleType = data.type
        If vehicleType = "" {
            Set %response.Status = "400 Bad Request"
            Set error = {}
            Set error.error = "Тип транспорту не вказано"
            Write error.%ToJSON()
        } Else {
        
        Set className = "Transport."_vehicleType
        Set vehicle = $ClassMethod(className, "%New")
        
        Set vehicle.Brand = data.brand
        Set vehicle.Model = data.model
        Set vehicle.VIN = data.vin
        Set vehicle.Year = data.year
        If $Data(data.color) Set vehicle.Color = data.color
        
        // Створення двигуна
        If $Data(data.engine) {
            Set engine = ##class(Transport.Engine).%New()
            If $Data(data.engine.type) Set engine.Type = data.engine.type
            If $Data(data.engine.horsePower) Set engine.HorsePower = data.engine.horsePower
            Set vehicle.Engine = engine
        }
        
        // Специфічні властивості
        If vehicleType = "Car" && $Data(data.bodyType) {
            Set vehicle.BodyType = data.bodyType
        }
        If vehicleType = "Truck" && $Data(data.loadCapacity) {
            Set vehicle.LoadCapacity = data.loadCapacity
        }
        
        // Власник
        If $Data(data.owner) && $Data(data.owner.id) {
            Set owner = ##class(Transport.Owner).%OpenId(data.owner.id)
            If $IsObject(owner) {
                Set vehicle.Owner = owner
            }
        }
        
        Set sc = vehicle.%Save()
        
        If $$$ISOK(sc) {
            Set %response.Status = "201 Created"
            Set result = {}
            Set result.id = vehicle.%Id()
            Set result.message = "Транспортний засіб успішно створено"
            Write result.%ToJSON()
        } Else {
            Set %response.Status = "400 Bad Request"
            Set error = {}
            Set error.error = $System.Status.GetErrorText(sc)
            Write error.%ToJSON()
        }
        }
    } Catch ex {
        Set %response.Status = "400 Bad Request"
        Set error = {}
        Set error.error = ex.AsString()
        Write error.%ToJSON()
    }
    
    Return $$$OK
}

/// Оновити транспортний засіб
ClassMethod UpdateVehicle(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set vehicle = ##class(Transport.Vehicle).%OpenId(id)
    If '$IsObject(vehicle) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Транспортний засіб не знайдено"
        Write error.%ToJSON()
        Return $$$OK
    }
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        If $Data(data.brand) Set vehicle.Brand = data.brand
        If $Data(data.model) Set vehicle.Model = data.model
        If $Data(data.vin) Set vehicle.VIN = data.vin
        If $Data(data.year) Set vehicle.Year = data.year
        If $Data(data.color) Set vehicle.Color = data.color
        
        If $Data(data.engine) {
            If '$IsObject(vehicle.Engine) {
                Set vehicle.Engine = ##class(Transport.Engine).%New()
            }
            If $Data(data.engine.type) Set vehicle.Engine.Type = data.engine.type
            If $Data(data.engine.horsePower) Set vehicle.Engine.HorsePower = data.engine.horsePower
        }
        
        If vehicle.%ClassName() = "Car" && $Data(data.bodyType) {
            Set vehicle.BodyType = data.bodyType
        }
        If vehicle.%ClassName() = "Truck" && $Data(data.loadCapacity) {
            Set vehicle.LoadCapacity = data.loadCapacity
        }
        
        If $Data(data.owner) && $Data(data.owner.id) {
            Set owner = ##class(Transport.Owner).%OpenId(data.owner.id)
            If $IsObject(owner) {
                Set vehicle.Owner = owner
            }
        }
        
        Set sc = vehicle.%Save()
        
        If $$$ISOK(sc) {
            Set result = {}
            Set result.message = "Транспортний засіб успішно оновлено"
            Write result.%ToJSON()
        } Else {
            Set %response.Status = "400 Bad Request"
            Set error = {}
            Set error.error = $System.Status.GetErrorText(sc)
            Write error.%ToJSON()
        }
    } Catch ex {
        Set %response.Status = "400 Bad Request"
        Set error = {}
        Set error.error = ex.AsString()
        Write error.%ToJSON()
    }
    
    Return $$$OK
}

/// Видалити транспортний засіб
ClassMethod DeleteVehicle(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set sc = ##class(Transport.Vehicle).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Set result = {}
        Set result.message = "Транспортний засіб успішно видалено"
        Write result.%ToJSON()
    } Else {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Транспортний засіб не знайдено"
        Write error.%ToJSON()
    }
    
    Return $$$OK
}

}
