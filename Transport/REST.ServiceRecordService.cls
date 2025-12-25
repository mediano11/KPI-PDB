Class Transport.REST.ServiceRecordService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/servicerecord" Method="GET" Call="GetAllServiceRecords"/>
    <Route Url="/servicerecord/:id" Method="GET" Call="GetServiceRecord"/>
    <Route Url="/servicerecord" Method="POST" Call="CreateServiceRecord"/>
    <Route Url="/servicerecord/:id" Method="PUT" Call="UpdateServiceRecord"/>
    <Route Url="/servicerecord/:id" Method="DELETE" Call="DeleteServiceRecord"/>
</Routes>
}

/// Отримати всі записи обслуговування
ClassMethod GetAllServiceRecords() As %Status
{
    Set %response.ContentType = "application/json"
    
    Set json = []
    Set rs = ##class(%ResultSet).%New("Transport.ServiceRecord:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set recordId = rs.Get("ID")
        Set record = ##class(Transport.ServiceRecord).%OpenId(recordId)
        If $IsObject(record) {
            Set obj = {}
            Set obj.id = recordId
            Set obj.serviceDate = $ZDate(record.ServiceDate,3)
            Set obj.description = record.Description
            Set obj.cost = record.Cost
            Set obj.performedBy = record.PerformedBy
            Set obj.mileage = record.Mileage
            
            If $IsObject(record.Vehicle) {
                Set obj.vehicle = {}
                Set obj.vehicle.id = record.Vehicle.%Id()
                Set obj.vehicle.brand = record.Vehicle.Brand
                Set obj.vehicle.model = record.Vehicle.Model
            }
            
            Do json.%Push(obj)
        }
    }
    
    Write json.%ToJSON()
    Return $$$OK
}

/// Отримати запис обслуговування за ID
ClassMethod GetServiceRecord(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set record = ##class(Transport.ServiceRecord).%OpenId(id)
    If '$IsObject(record) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Запис обслуговування не знайдено"
        Write error.%ToJSON()
        Quit $$$OK
    }
    
    Set obj = {}
    Set obj.id = record.%Id()
    Set obj.serviceDate = $ZDate(record.ServiceDate,3)
    Set obj.description = record.Description
    Set obj.cost = record.Cost
    Set obj.performedBy = record.PerformedBy
    Set obj.mileage = record.Mileage
    
    If $IsObject(record.Vehicle) {
        Set obj.vehicle = {}
        Set obj.vehicle.id = record.Vehicle.%Id()
        Set obj.vehicle.brand = record.Vehicle.Brand
        Set obj.vehicle.model = record.Vehicle.Model
    }
    
    Write obj.%ToJSON()
    Quit $$$OK
}

/// Створити новий запис обслуговування
ClassMethod CreateServiceRecord() As %Status
{
    Set %response.ContentType = "application/json"
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        Set record = ##class(Transport.ServiceRecord).%New()
        
        If $Data(data.vehicleId) {
            Set vehicle = ##class(Transport.Vehicle).%OpenId(data.vehicleId)
            If '$IsObject(vehicle) {
                Set %response.Status = "400 Bad Request"
                Set error = {}
                Set error.error = "Транспортний засіб не знайдено"
                Write error.%ToJSON()
            } Else {
                Set record.Vehicle = vehicle
            }
        }
        
        If $IsObject(record.Vehicle) {
            If $Data(data.serviceDate) Set record.ServiceDate = $ZDateH(data.serviceDate,3)
            If $Data(data.description) Set record.Description = data.description
            If $Data(data.cost) Set record.Cost = data.cost
            If $Data(data.performedBy) Set record.PerformedBy = data.performedBy
            If $Data(data.mileage) Set record.Mileage = data.mileage
            
            Set sc = record.%Save()
            
            If $$$ISOK(sc) {
                Set %response.Status = "201 Created"
                Set result = {}
                Set result.id = record.%Id()
                Set result.message = "Запис обслуговування успішно створено"
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

/// Оновити запис обслуговування
ClassMethod UpdateServiceRecord(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set record = ##class(Transport.ServiceRecord).%OpenId(id)
    If '$IsObject(record) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Запис обслуговування не знайдено"
        Write error.%ToJSON()
        Quit $$$OK
    }
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        If $Data(data.vehicleId) {
            Set vehicle = ##class(Transport.Vehicle).%OpenId(data.vehicleId)
            If $IsObject(vehicle) {
                Set record.Vehicle = vehicle
            }
        }
        If $Data(data.serviceDate) Set record.ServiceDate = $ZDateH(data.serviceDate,3)
        If $Data(data.description) Set record.Description = data.description
        If $Data(data.cost) Set record.Cost = data.cost
        If $Data(data.performedBy) Set record.PerformedBy = data.performedBy
        If $Data(data.mileage) Set record.Mileage = data.mileage
        
        Set sc = record.%Save()
        
        If $$$ISOK(sc) {
            Set result = {}
            Set result.message = "Запис обслуговування успішно оновлено"
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

/// Видалити запис обслуговування
ClassMethod DeleteServiceRecord(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set sc = ##class(Transport.ServiceRecord).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Set result = {}
        Set result.message = "Запис обслуговування успішно видалено"
        Write result.%ToJSON()
    } Else {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Запис обслуговування не знайдено"
        Write error.%ToJSON()
    }
    
    Return $$$OK
}

}
