Class Transport.Truck Extends Transport.Vehicle
{

/// Вантажопідйомність (тонни)
Property LoadCapacity As %Numeric(SCALE = 2);

/// Вантаж (список)
Relationship Cargo As Transport.CargoItem [ Cardinality = children, Inverse = Truck ];

/// Максимальна швидкість для вантажівки
Method GetMaxSpeed() As %Numeric
{
    // Вантажівки мають обмежену швидкість залежно від вантажопідйомності
    Set baseSpeed = 120
    
    If ..LoadCapacity > 20 {
        Set maxSpeed = baseSpeed - 20  // Важкі вантажівки
    } ElseIf ..LoadCapacity > 10 {
        Set maxSpeed = baseSpeed - 10  // Середні вантажівки
    } Else {
        Set maxSpeed = baseSpeed       // Легкі вантажівки
    }
    
    // Ураховуємо потужність двигуна
    If ..Engine '= "" {
        If ..Engine.HorsePower > 400 {
            Set maxSpeed = maxSpeed + 20
        } ElseIf ..Engine.HorsePower > 300 {
            Set maxSpeed = maxSpeed + 10
        }
    }
    
    Quit maxSpeed
}

/// Відображення інформації про вантажівку
Method DisplayInfo()
{
    Write !,"╔════════════════════════════════════════"
    Write !,"║         ВАНТАЖІВКА"
    Write !,"║ Марка: "_$ZStrip(..Brand,"<",30)_""
    Write !,"║ Модель: "_$ZStrip(..Model,"<",28)_""
    Write !,"║ VIN: "_$ZStrip(..VIN,"<",30)_""
    Write !,"║ Рік: "_..Year_""
    Write !,"║ Колір: "_$ZStrip(..Color,"<",28)_""
    Write !,"║ Вантажопідйомність: "_..LoadCapacity_" т"
    
    If ..Engine '= "" {
        Write !,"║ Двигун: "_$ZStrip(..Engine.Type,"<",27)_""
        Write !,"║ Потужність: "_..Engine.HorsePower_" к.с."
    }
    
    Write !,"║ Макс. швидкість: "_..GetMaxSpeed()_" км/год"
    Write !,"║ Пробіг: "_..CurrentMileage_" км"
    
    Set id = ..%Id()
    &sql(SELECT COUNT(*) INTO :cargoCount FROM Transport.CargoItem WHERE Truck = :id)
    If cargoCount = "" Set cargoCount = 0
    
    If cargoCount > 0 {
        Set totalWeight = ..GetTotalCargoWeight()
        Write !,"║ Вантаж: "_cargoCount_" одиниць ("_totalWeight_" т)"
    } Else {
        Write !,"║ Вантаж: відсутній"
    }
    
    Write !,"╚════════════════════════════════════════",!
}

/// Додати вантаж
Method AddCargo(cargoItem As Transport.CargoItem) As %Status
{
    Set currentWeight = ..GetTotalCargoWeight()
    If (currentWeight + cargoItem.Weight) > ..LoadCapacity {
        Write "Помилка: перевищено вантажопідйомність! Доступно: "_(..LoadCapacity - currentWeight)_" т",!
        Quit $$$ERROR($$$GeneralError,"Перевищено вантажопідйомність")
    }
    
    Set cargoItem.Truck = $This
    Set sc = cargoItem.%Save()
    If $$$ISOK(sc) {
        Write "Вантаж '"_cargoItem.Name_"' ("_cargoItem.Weight_" т) додано.",!
    }
    Quit sc
}

/// Отримати загальну вагу вантажу
Method GetTotalCargoWeight() As %Numeric
{
    Set totalWeight = 0
    Set id = ..%Id()
    
    // Використовуємо SQL для підрахунку ваги вантажу
    &sql(SELECT SUM(Weight) INTO :totalWeight FROM Transport.CargoItem WHERE Truck = :id)
    
    If totalWeight = "" Set totalWeight = 0
    
    Quit totalWeight
}

Storage Default
{
<Data name="TruckDefaultData">
<Subscript>"Truck"</Subscript>
<Value name="1">
<Value>LoadCapacity</Value>
</Value>
</Data>
<DefaultData>TruckDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
