Class Transport.SOAP.CargoItemService Extends %SOAP.WebService
{

/// Ім'я веб-сервісу
Parameter SERVICENAME = "CargoItemService";

/// Namespace для SOAP
Parameter NAMESPACE = "http://tempuri.org";

/// Використовувати літерали в WSDL
Parameter USECLASSNAMESPACES = 1;

/// Створити вантаж
Method CreateCargoItem(truckId As %Integer, name As %String, weight As %Numeric) As %String [ WebMethod ]
{
    Set result = ""
    Try {
        Set truck = ##class(Transport.Truck).%OpenId(truckId)
        If '$IsObject(truck) {
            Return "Вантажівка не знайдена"
        }
        
        Set cargo = ##class(Transport.CargoItem).%New()
        Set cargo.Truck = truck
        Set cargo.Name = name
        Set cargo.Weight = weight
        
        Set sc = cargo.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Успішно створено. ID: "_cargo.%Id()
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Отримати вантаж за ID
Method GetCargoItem(id As %Integer) As %String [ WebMethod ]
{
    Set cargo = ##class(Transport.CargoItem).%OpenId(id)
    If '$IsObject(cargo) {
        Return "Вантаж не знайдено"
    }
    
    Set result = "ID: "_cargo.%Id()_", Назва: "_cargo.Name_", Вага: "_cargo.Weight_" т"
    If $IsObject(cargo.Truck) {
        Set result = result_", Вантажівка: "_cargo.Truck.Brand_" "_cargo.Truck.Model
    }
    
    Return result
}

/// Отримати весь вантаж
Method GetAllCargoItems() As %String [ WebMethod ]
{
    Set result = ""
    Set count = 0
    Set rs = ##class(%ResultSet).%New("Transport.CargoItem:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set cargoId = rs.Get("ID")
        Set cargo = ##class(Transport.CargoItem).%OpenId(cargoId)
        If $IsObject(cargo) {
            Set count = count + 1
            If result '= "" Set result = result_"; "
            Set result = result_count_". "_cargo.Name_" ("_cargo.Weight_" т) (ID: "_cargoId_")"
        }
    }
    
    If result = "" {
        Return "Вантаж не знайдено"
    }
    
    Return "Всього: "_count_". "_result
}

/// Оновити вантаж
Method UpdateCargoItem(id As %Integer, name As %String, weight As %Numeric) As %String [ WebMethod ]
{
    Set cargo = ##class(Transport.CargoItem).%OpenId(id)
    If '$IsObject(cargo) {
        Return "Вантаж не знайдено"
    }
    
    Set result = ""
    Try {
        If name '= "" Set cargo.Name = name
        If weight '= "" Set cargo.Weight = weight
        
        Set sc = cargo.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Вантаж успішно оновлено"
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Видалити вантаж
Method DeleteCargoItem(id As %Integer) As %String [ WebMethod ]
{
    Set sc = ##class(Transport.CargoItem).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Return "Вантаж успішно видалено"
    } Else {
        Return "Помилка: "_$System.Status.GetErrorText(sc)
    }
}

}
