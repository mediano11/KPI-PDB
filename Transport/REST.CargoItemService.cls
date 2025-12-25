Class Transport.REST.CargoItemService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/cargoitem" Method="GET" Call="GetAllCargoItems"/>
    <Route Url="/cargoitem/:id" Method="GET" Call="GetCargoItem"/>
    <Route Url="/cargoitem" Method="POST" Call="CreateCargoItem"/>
    <Route Url="/cargoitem/:id" Method="PUT" Call="UpdateCargoItem"/>
    <Route Url="/cargoitem/:id" Method="DELETE" Call="DeleteCargoItem"/>
</Routes>
}

/// Отримати весь вантаж
ClassMethod GetAllCargoItems() As %Status
{
    Set %response.ContentType = "application/json"
    
    Set json = []
    Set rs = ##class(%ResultSet).%New("Transport.CargoItem:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set cargoId = rs.Get("ID")
        Set cargo = ##class(Transport.CargoItem).%OpenId(cargoId)
        If $IsObject(cargo) {
            Set obj = {}
            Set obj.id = cargoId
            Set obj.name = cargo.Name
            Set obj.weight = cargo.Weight
            
            If $IsObject(cargo.Truck) {
                Set obj.truck = {}
                Set obj.truck.id = cargo.Truck.%Id()
                Set obj.truck.brand = cargo.Truck.Brand
                Set obj.truck.model = cargo.Truck.Model
            }
            
            Do json.%Push(obj)
        }
    }
    
    Write json.%ToJSON()
    Return $$$OK
}

/// Отримати вантаж за ID
ClassMethod GetCargoItem(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set cargo = ##class(Transport.CargoItem).%OpenId(id)
    If '$IsObject(cargo) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Вантаж не знайдено"
        Write error.%ToJSON()
        Quit $$$OK
    }
    
    Set obj = {}
    Set obj.id = cargo.%Id()
    Set obj.name = cargo.Name
    Set obj.weight = cargo.Weight
    
    If $IsObject(cargo.Truck) {
        Set obj.truck = {}
        Set obj.truck.id = cargo.Truck.%Id()
        Set obj.truck.brand = cargo.Truck.Brand
        Set obj.truck.model = cargo.Truck.Model
    }
    
    Write obj.%ToJSON()
    Quit $$$OK
}

/// Створити новий вантаж
ClassMethod CreateCargoItem() As %Status
{
    Set %response.ContentType = "application/json"
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        Set cargo = ##class(Transport.CargoItem).%New()
        
        If $Data(data.truckId) {
            Set truck = ##class(Transport.Truck).%OpenId(data.truckId)
            If '$IsObject(truck) {
                Set %response.Status = "400 Bad Request"
                Set error = {}
                Set error.error = "Вантажівка не знайдена"
                Write error.%ToJSON()
            } Else {
                Set cargo.Truck = truck
                Set cargo.Name = data.name
                Set cargo.Weight = data.weight
                
                Set sc = cargo.%Save()
                
                If $$$ISOK(sc) {
                    Set %response.Status = "201 Created"
                    Set result = {}
                    Set result.id = cargo.%Id()
                    Set result.message = "Вантаж успішно створено"
                    Write result.%ToJSON()
                } Else {
                    Set %response.Status = "400 Bad Request"
                    Set error = {}
                    Set error.error = $System.Status.GetErrorText(sc)
                    Write error.%ToJSON()
                }
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

/// Оновити вантаж
ClassMethod UpdateCargoItem(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set cargo = ##class(Transport.CargoItem).%OpenId(id)
    If '$IsObject(cargo) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Вантаж не знайдено"
        Write error.%ToJSON()
        Quit $$$OK
    }
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        If $Data(data.truckId) {
            Set truck = ##class(Transport.Truck).%OpenId(data.truckId)
            If $IsObject(truck) {
                Set cargo.Truck = truck
            }
        }
        If $Data(data.name) Set cargo.Name = data.name
        If $Data(data.weight) Set cargo.Weight = data.weight
        
        Set sc = cargo.%Save()
        
        If $$$ISOK(sc) {
            Set result = {}
            Set result.message = "Вантаж успішно оновлено"
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

/// Видалити вантаж
ClassMethod DeleteCargoItem(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set sc = ##class(Transport.CargoItem).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Set result = {}
        Set result.message = "Вантаж успішно видалено"
        Write result.%ToJSON()
    } Else {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Вантаж не знайдено"
        Write error.%ToJSON()
    }
    
    Return $$$OK
}

}
