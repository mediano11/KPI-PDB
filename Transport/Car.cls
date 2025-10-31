Class Transport.Car Extends Transport.Vehicle
{

/// Тип кузова
Property BodyType As %String(MAXLEN = 50);

/// Список пасажирів
Property Passengers As list Of %String(MAXLEN = 100);

/// Максимальна швидкість для автомобіля
Method GetMaxSpeed() As %Numeric
{
    // Базуючись на типі кузова та потужності двигуна
    Set baseSpeed = 180
    
    If ..BodyType = "Седан" {
        Set maxSpeed = baseSpeed + 20
    } ElseIf ..BodyType = "Кросовер" {
        Set maxSpeed = baseSpeed + 10
    } ElseIf ..BodyType = "Спорткар" {
        Set maxSpeed = baseSpeed + 60
    } Else {
        Set maxSpeed = baseSpeed
    }
    
    // Ураховуємо потужність двигуна
    If ..Engine '= "" {
        If ..Engine.HorsePower > 300 {
            Set maxSpeed = maxSpeed + 30
        } ElseIf ..Engine.HorsePower > 200 {
            Set maxSpeed = maxSpeed + 15
        }
    }
    
    Quit maxSpeed
}

/// Відображення інформації про автомобіль
Method DisplayInfo()
{
    Write !,"╔══════════════════════════════════════"
    Write !,"║         АВТОМОБІЛЬ"
    Write !,"║ Марка: "_$ZStrip(..Brand,"<",30)_""
    Write !,"║ Модель: "_$ZStrip(..Model,"<",28)_""
    Write !,"║ VIN: "_$ZStrip(..VIN,"<",30)_""
    Write !,"║ Рік: "_..Year_""
    Write !,"║ Колір: "_$ZStrip(..Color,"<",28)_""
    Write !,"║ Тип кузова: "_$ZStrip(..BodyType,"<",24)_""
    
    If ..Engine '= "" {
        Write !,"║ Двигун: "_$ZStrip(..Engine.Type,"<",27)_""
        Write !,"║ Потужність: "_..Engine.HorsePower_" к.с."
    }
    
    Write !,"║ Макс. швидкість: "_..GetMaxSpeed()_" км/год"
    Write !,"║ Пробіг: "_..CurrentMileage_" км"
    
    If ..Passengers.Count() > 0 {
        Write !,"║ Пасажири: "_..Passengers.Count()_" осіб"
    }
    
    Write !,"╚════════════════════════════════════════",!
}

/// Додати пасажира
Method AddPassenger(name As %String) As %Status
{
    Do ..Passengers.Insert(name)
    Write "Пасажир "_name_" додано до автомобіля.",!
    Quit $$$OK
}

/// Видалити пасажира
Method RemovePassenger(name As %String) As %Status
{
    Set found = 0
    For i=1:1:..Passengers.Count() {
        If ..Passengers.GetAt(i) = name {
            Do ..Passengers.RemoveAt(i)
            Set found = 1
            Quit
        }
    }
    If found {
        Write "Пасажир "_name_" видалено.",!
    } Else {
        Write "Пасажир "_name_" не знайдено.",!
    }
    Quit $$$OK
}

Storage Default
{
<Data name="CarDefaultData">
<Subscript>"Car"</Subscript>
<Value name="1">
<Value>BodyType</Value>
</Value>
<Value name="2">
<Value>Passengers</Value>
</Value>
</Data>
<DefaultData>CarDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
