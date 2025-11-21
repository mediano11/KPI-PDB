Class Transport.Vehicle Extends (%Persistent, %Populate) [ Abstract ]
{

/// Марка
Property Brand As %String(MAXLEN = 100) [ Required ];

/// Модель
Property Model As %String(MAXLEN = 100) [ Required ];

/// VIN (Vehicle Identification Number)
Property VIN As %String(MAXLEN = 17) [ Required ];

/// Рік випуску
Property Year As %Integer(MAXVAL = 2100, MINVAL = 1900) [ Required ];

/// Колір
Property Color As %String(MAXLEN = 50);

/// Двигун (embedded)
Property Engine As Transport.Engine;

/// Власник
Relationship Owner As Transport.Owner [ Cardinality = one, Inverse = Vehicles ];

/// Історія обслуговування
Relationship ServiceRecords As Transport.ServiceRecord [ Cardinality = children, Inverse = Vehicle ];

/// Поточний пробіг
Property CurrentMileage As %Numeric(SCALE = 2) [ InitialExpression = 0 ];

/// Поточна швидкість
Property CurrentSpeed As %Numeric(SCALE = 2) [ InitialExpression = 0 ];

/// Чи рухається транспорт
Property IsMoving As %Boolean [ InitialExpression = 0 ];

/// Унікальний індекс на VIN
Index VINIndex On VIN [ Unique ];

/// Індекс на власника
Index OwnerIndex On Owner;

Property FullName As %String(MAXLEN = 220) [ Calculated ];

Property Age As %Integer [ Calculated ];

/// Обчислювана властивість - вік транспорту
Method AgeGet() As %Integer
{
    Set currentYear = $Piece($ZDate($H,3),"-",1)
    Quit currentYear - ..Year
}

/// Обчислювана властивість - повна назва (марка + модель)
Method FullNameGet() As %String
{
    Quit ..Brand _ " " _ ..Model
}

/// Запустити транспорт
Method Start() As %Status
{
    If ..Engine = "" {
        Write "Помилка: двигун не встановлено!",!
        Quit $$$ERROR($$$GeneralError,"Двигун не встановлено")
    }
    
    Set sc = ..Engine.Start()
    If $$$ISOK(sc) {
        Write ..FullName_" готовий до руху.",!
    }
    Quit sc
}

/// Зупинити транспорт
Method Stop() As %Status
{
    If ..IsMoving {
        Set ..IsMoving = 0
        Set ..CurrentSpeed = 0
        Write ..FullName_" зупинено.",!
    }
    
    If ..Engine '= "" {
        Set sc = ..Engine.Stop()
    } Else {
        Set sc = $$$OK
    }
    Quit sc
}

/// Рухатися на відстань
Method Move(distance As %Numeric) As %Status
{
    If ..Engine = "" {
        Write "Помилка: двигун не встановлено!",!
        Quit $$$ERROR($$$GeneralError,"Двигун не встановлено")
    }
    
    If '..Engine.IsEngineRunning() {
        Write "Помилка: спочатку запустіть двигун!",!
        Quit $$$ERROR($$$GeneralError,"Двигун не запущено")
    }
    
    Set ..IsMoving = 1
    Set ..CurrentMileage = ..CurrentMileage + distance
    Write ..FullName_" проїхав "_distance_" км. Загальний пробіг: "_..CurrentMileage_" км.",!
    Quit $$$OK
}

/// Прискорити до заданої швидкості
Method Accelerate(speed As %Numeric) As %Status
{
    Set maxSpeed = ..GetMaxSpeed()
    If speed > maxSpeed {
        Write "Попередження: максимальна швидкість "_maxSpeed_" км/год. Обмежено до максимуму.",!
        Set speed = maxSpeed
    }
    
    Set ..CurrentSpeed = speed
    Set ..IsMoving = (speed > 0)
    Write ..FullName_" прискорено до "_speed_" км/год.",!
    Quit $$$OK
}

/// Абстрактний метод - максимальна швидкість (має бути реалізований в нащадках)
Method GetMaxSpeed() As %Numeric [ Abstract ]
{
    Quit 0
}

/// Абстрактний метод - відображення інформації (має бути реалізований в нащадках)
Method DisplayInfo() [ Abstract ]
{
}

/// Отримати детальну інформацію
Method GetDetails() As %String
{
    // Символ переходу на новий рядок
    Set nl = $Char(13,10)
    Set info = "=== Інформація про транспорт ===" _ nl
    Set info = info _ "Марка: " _ ..Brand _ nl
    Set info = info _ "Модель: " _ ..Model _ nl
    Set info = info _ "VIN: " _ ..VIN _ nl
    Set info = info _ "Рік: " _ ..Year _ nl
    Set info = info _ "Колір: " _ ..Color _ nl
    
    If $IsObject(..Engine) {
        Set info = info _ "Двигун: " _ ..Engine.Type _ " (" _ ..Engine.HorsePower _ " к.с.)" _ nl
    }
    
    // Перевірка наявності додаткових властивостей
    
    
    Quit info
}

/// Запит: Отримати транспортні засоби за маркою з інформацією про власника
/// Використовує оператор -> для доступу до властивостей власника
Query GetVehiclesByBrand(brandName As %String = "") As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Brand, Model, VIN, Year, Color, 
           Owner->Name As OwnerName, 
           Owner->Email As OwnerEmail,
           Owner->Phone As OwnerPhone
    FROM Transport.Vehicle
    WHERE Brand = :brandName
    ORDER BY Year DESC
}

/// Запит: Отримати всі транспортні засоби з інформацією про власників
/// Демонстрація зовнішнього з'єднання та оператора ->
Query GetVehiclesWithOwners() As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, Brand, Model, VIN, Year, Color, CurrentMileage,
           Owner->Name As OwnerName,
           Owner->Email As OwnerEmail
    FROM Transport.Vehicle
    ORDER BY Owner->Name, Brand
}

/// Метод класу: Підрахунок транспортних засобів за маркою (вбудований SQL - простий вираз)
ClassMethod CountByBrand(brandName As %String) As %Integer
{
    New SQLCODE
    &sql(SELECT COUNT(*) INTO :count FROM Transport.Vehicle WHERE Brand = :brandName)
    If SQLCODE = 0 {
        Quit count
    }
    Quit 0
}

/// Метод класу: Отримати середній пробіг для марки (вбудований SQL - простий вираз)
ClassMethod GetAverageMileageByBrand(brandName As %String) As %Numeric
{
    New SQLCODE
    &sql(SELECT AVG(CurrentMileage) INTO :avgMileage FROM Transport.Vehicle WHERE Brand = :brandName)
    If SQLCODE = 0 && (avgMileage '= "") {
        Quit avgMileage
    }
    Quit 0
}

Storage Default
{
<Data name="VehicleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Brand</Value>
</Value>
<Value name="3">
<Value>Model</Value>
</Value>
<Value name="4">
<Value>VIN</Value>
</Value>
<Value name="5">
<Value>Year</Value>
</Value>
<Value name="6">
<Value>Color</Value>
</Value>
<Value name="7">
<Value>Engine</Value>
</Value>
<Value name="8">
<Value>Owner</Value>
</Value>
<Value name="9">
<Value>CurrentMileage</Value>
</Value>
<Value name="10">
<Value>CurrentSpeed</Value>
</Value>
<Value name="11">
<Value>IsMoving</Value>
</Value>
</Data>
<DataLocation>^Transport.VehicleD</DataLocation>
<DefaultData>VehicleDefaultData</DefaultData>
<IdLocation>^Transport.VehicleD</IdLocation>
<IndexLocation>^Transport.VehicleI</IndexLocation>
<StreamLocation>^Transport.VehicleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
