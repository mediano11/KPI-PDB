Class Transport.SOAP.OwnerService Extends %SOAP.WebService
{

/// Ім'я веб-сервісу
Parameter SERVICENAME = "OwnerService";

/// Namespace для SOAP
Parameter NAMESPACE = "http://tempuri.org";

/// Використовувати літерали в WSDL
Parameter USECLASSNAMESPACES = 1;

/// Створити власника
Method CreateOwner(id As %Integer, name As %String, email As %String, phone As %String) As %String [ WebMethod ]
{
    Set result = ""
    Try {
        Set owner = ##class(Transport.Owner).%New()
        Set owner.Id = id
        Set owner.Name = name
        If email '= "" Set owner.Email = email
        If phone '= "" Set owner.Phone = phone
        
        Set sc = owner.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Успішно створено. ID: "_owner.%Id()
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Отримати власника за ID
Method GetOwner(id As %Integer) As %String [ WebMethod ]
{
    Set owner = ##class(Transport.Owner).%OpenId(id)
    If '$IsObject(owner) {
        Return "Власник не знайдено"
    }
    
    Set result = "ID: "_owner.Id_", Ім'я: "_owner.Name
    If owner.Email '= "" Set result = result_", Email: "_owner.Email
    If owner.Phone '= "" Set result = result_", Телефон: "_owner.Phone
    
    Return result
}

/// Отримати всіх власників
Method GetAllOwners() As %String [ WebMethod ]
{
    Set result = ""
    Set count = 0
    Set rs = ##class(%ResultSet).%New("Transport.Owner:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set ownerId = rs.Get("ID")
        Set owner = ##class(Transport.Owner).%OpenId(ownerId)
        If $IsObject(owner) {
            Set count = count + 1
            If result '= "" Set result = result_"; "
            Set result = result_count_". "_owner.Name_" (ID: "_owner.Id_")"
        }
    }
    
    If result = "" {
        Return "Власники не знайдено"
    }
    
    Return "Всього: "_count_". "_result
}

/// Оновити власника
Method UpdateOwner(id As %Integer, name As %String, email As %String, phone As %String) As %String [ WebMethod ]
{
    Set owner = ##class(Transport.Owner).%OpenId(id)
    If '$IsObject(owner) {
        Return "Власник не знайдено"
    }
    
    Set result = ""
    Try {
        If name '= "" Set owner.Name = name
        If email '= "" Set owner.Email = email
        If phone '= "" Set owner.Phone = phone
        
        Set sc = owner.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Власника успішно оновлено"
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Видалити власника
Method DeleteOwner(id As %Integer) As %String [ WebMethod ]
{
    Set sc = ##class(Transport.Owner).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Return "Власника успішно видалено"
    } Else {
        Return "Помилка: "_$System.Status.GetErrorText(sc)
    }
}

}
