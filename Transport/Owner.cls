Class Transport.Owner Extends %Persistent
{

/// Унікальний ідентифікатор
Property Id As %Integer [ Required ];

/// Ім'я власника
Property Name As %String(MAXLEN = 100) [ Required ];

/// Електронна адреса
Property Email As %String(MAXLEN = 200);

/// Номер телефону
Property Phone As %String(MAXLEN = 50);

/// Транспортні засоби
Relationship Vehicles As Transport.Vehicle [ Cardinality = many, Inverse = Owner ];

Index IdIndex On Id [ Unique ];

/// Конструктор
Method %OnNew(name As %String = "", email As %String = "", phone As %String = "") As %Status
{
    If name '= "" {
        Set ..Name = name
    }
    If email '= "" {
        Set ..Email = email
    }
    If phone '= "" {
        Set ..Phone = phone
    }
    
    // Генерація унікального ID (проста реалізація)
    If ..Id = "" {
        &sql(SELECT MAX(Id) INTO :maxId FROM Transport.Owner)
        If maxId = "" Set maxId = 0
        Set ..Id = maxId + 1
    }
    
    Quit $$$OK
}

/// Отримати ID
Method GetId() As %Integer
{
    Quit ..Id
}

/// Отримати ім'я
Method GetName() As %String
{
    Quit ..Name
}

/// Отримати контактну інформацію
Method GetContact() As %String
{
    Set contact = ..Email
    If ..Phone '= "" {
        If contact '= "" Set contact = contact _ ", "
        Set contact = contact _ ..Phone
    }
    Quit contact
}

Storage Default
{
<Data name="OwnerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Id</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Email</Value>
</Value>
<Value name="5">
<Value>Phone</Value>
</Value>
</Data>
<DataLocation>^Transport.OwnerD</DataLocation>
<DefaultData>OwnerDefaultData</DefaultData>
<IdLocation>^Transport.OwnerD</IdLocation>
<IndexLocation>^Transport.OwnerI</IndexLocation>
<StreamLocation>^Transport.OwnerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
