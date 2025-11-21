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

/// Запит на основі COS: Отримати власників з кількістю їх транспортних засобів
/// Використовує вбудований SQL з курсором
Query GetOwnersWithVehicleCount() As %Query(ROWSPEC = "OwnerId:%Integer,OwnerName:%String,Email:%String,Phone:%String,VehicleCount:%Integer")
{
}

ClassMethod GetOwnersWithVehicleCountExecute(ByRef qHandle As %Binary) As %Status
{
    // Оголошуємо курсор для підрахунку транспортних засобів кожного власника
    &sql(DECLARE OwnerVehicleCursor CURSOR FOR
        SELECT Owner, COUNT(*) AS VehicleCount
        INTO :ownerId, :vehicleCount
        FROM Transport.Vehicle
        WHERE Owner IS NOT NULL
        GROUP BY Owner
    )
    
    &sql(OPEN OwnerVehicleCursor)
    
    // Створюємо глобал для збереження результатів
    Set qHandle("vehicleCount") = ""
    Set qHandle("ownerIds") = ""
    
    // Зчитуємо дані з курсору
    For {
        &sql(FETCH OwnerVehicleCursor)
        Quit:SQLCODE'=0
        
        Set qHandle("vehicleCount", ownerId) = vehicleCount
        Set qHandle("ownerIds") = qHandle("ownerIds")_$ListBuild(ownerId)
    }
    
    &sql(CLOSE OwnerVehicleCursor)
    
    // Відкриваємо курсор для всіх власників
    &sql(DECLARE AllOwnersCursor CURSOR FOR
        SELECT %ID, Name, Email, Phone
        INTO :ownerId, :ownerName, :ownerEmail, :ownerPhone
        FROM Transport.Owner
        ORDER BY Name
    )
    
    &sql(OPEN AllOwnersCursor)
    Set qHandle("cursorOpen") = 1
    
    Quit $$$OK
}

ClassMethod GetOwnersWithVehicleCountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOwnersWithVehicleCountExecute ]
{
    New SQLCODE
    New ownerId, ownerName, ownerEmail, ownerPhone, vehicleCount
    
    &sql(FETCH AllOwnersCursor INTO :ownerId, :ownerName, :ownerEmail, :ownerPhone)
    
    If SQLCODE = 0 {
        // Отримуємо кількість транспортних засобів для цього власника
        Set vehicleCount = $Get(qHandle("vehicleCount", ownerId), 0)
        Set Row = $ListBuild(ownerId, ownerName, $Get(ownerEmail), $Get(ownerPhone), vehicleCount)
        Set AtEnd = 0
    } Else {
        Set Row = ""
        Set AtEnd = 1
    }
    
    Quit $$$OK
}

ClassMethod GetOwnersWithVehicleCountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOwnersWithVehicleCountExecute ]
{
    New SQLCODE
    
    If $Get(qHandle("cursorOpen")) {
        &sql(CLOSE AllOwnersCursor)
    }
    
    Kill qHandle
    Quit $$$OK
}

/// Запит SQL: Отримати власників за ім'ям (з параметром)
Query GetOwnersByName(namePattern As %String = "") As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Id, Name, Email, Phone
    FROM Transport.Owner
    WHERE Name %STARTSWITH :namePattern
    ORDER BY Name
}

/// Тригер: Логування змін власників
Trigger LogOwnerChanges [ Event = INSERT/UPDATE, Foreach = row/object, Time = AFTER ]
{
    Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "Name") = {Name*N}
    Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "Email") = {Email*N}
    Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "Phone") = {Phone*N}
    If {%%OPERATION} = "UPDATE" {
        Set ^Transport.OwnerLog({%%ID}, {%%OPERATION}, $H, "OldName") = {Name*O}
    }
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
