Class Transport.REST.OwnerService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONTENTTYPE = "application/json";

XData UrlMap [ XMLNamespace = "http://www.intersystems.com/urlmap" ]
{
<Routes>
    <Route Url="/owner" Method="GET" Call="GetAllOwners"/>
    <Route Url="/owner/:id" Method="GET" Call="GetOwner"/>
    <Route Url="/owner" Method="POST" Call="CreateOwner"/>
    <Route Url="/owner/:id" Method="PUT" Call="UpdateOwner"/>
    <Route Url="/owner/:id" Method="DELETE" Call="DeleteOwner"/>
</Routes>
}

/// Отримати всіх власників
ClassMethod GetAllOwners() As %Status
{
    Set %response.ContentType = "application/json"
    
    Set json = []
    Set rs = ##class(%ResultSet).%New("Transport.Owner:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set ownerId = rs.Get("ID")
        Set owner = ##class(Transport.Owner).%OpenId(ownerId)
        If $IsObject(owner) {
            Set obj = {}
            Set obj.id = owner.Id
            Set obj.databaseId = ownerId
            Set obj.name = owner.Name
            Set obj.email = owner.Email
            Set obj.phone = owner.Phone
            Do json.%Push(obj)
        }
    }
    
    Write json.%ToJSON()
    Return $$$OK
}

/// Отримати власника за ID
ClassMethod GetOwner(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set owner = ##class(Transport.Owner).%OpenId(id)
    If '$IsObject(owner) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Власник не знайдено"
        Write error.%ToJSON()
        Quit $$$OK
    }
    
    Set obj = {}
    Set obj.id = owner.Id
    Set obj.databaseId = owner.%Id()
    Set obj.name = owner.Name
    Set obj.email = owner.Email
    Set obj.phone = owner.Phone
    
    Write obj.%ToJSON()
    Quit $$$OK
}

/// Створити нового власника
ClassMethod CreateOwner() As %Status
{
    Set %response.ContentType = "application/json"
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        Set owner = ##class(Transport.Owner).%New()
        Set owner.Id = data.id
        Set owner.Name = data.name
        If $Data(data.email) Set owner.Email = data.email
        If $Data(data.phone) Set owner.Phone = data.phone
        
        Set sc = owner.%Save()
        
        If $$$ISOK(sc) {
            Set %response.Status = "201 Created"
            Set result = {}
            Set result.id = owner.%Id()
            Set result.message = "Власника успішно створено"
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

/// Оновити власника
ClassMethod UpdateOwner(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set owner = ##class(Transport.Owner).%OpenId(id)
    If '$IsObject(owner) {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Власник не знайдено"
        Write error.%ToJSON()
        Quit $$$OK
    }
    
    Try {
        Set data = {}.%FromJSON(%request.Content)
        
        If $Data(data.id) Set owner.Id = data.id
        If $Data(data.name) Set owner.Name = data.name
        If $Data(data.email) Set owner.Email = data.email
        If $Data(data.phone) Set owner.Phone = data.phone
        
        Set sc = owner.%Save()
        
        If $$$ISOK(sc) {
            Set result = {}
            Set result.message = "Власника успішно оновлено"
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

/// Видалити власника
ClassMethod DeleteOwner(id As %String) As %Status
{
    Set %response.ContentType = "application/json"
    
    Set sc = ##class(Transport.Owner).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Set result = {}
        Set result.message = "Власника успішно видалено"
        Write result.%ToJSON()
    } Else {
        Set %response.Status = "404 Not Found"
        Set error = {}
        Set error.error = "Власник не знайдено"
        Write error.%ToJSON()
    }
    
    Return $$$OK
}

}
