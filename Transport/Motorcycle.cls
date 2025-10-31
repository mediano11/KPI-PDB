Class Transport.Motorcycle Extends Transport.Vehicle
{

/// Тип мотоцикла
Property MotorcycleType As %String(MAXLEN = 50);

/// Обов'язкове спорядження (масив рядків)
Property RequiredGear As array Of %String(MAXLEN = 100);

/// Максимальна швидкість для мотоцикла
Method GetMaxSpeed() As %Numeric
{
    Set baseSpeed = 200
    
    If ..MotorcycleType = "Спортивний" {
        Set maxSpeed = baseSpeed + 80
    } ElseIf ..MotorcycleType = "Круїзер" {
        Set maxSpeed = baseSpeed + 40
    } ElseIf ..MotorcycleType = "Туристичний" {
        Set maxSpeed = baseSpeed + 20
    } Else {
        Set maxSpeed = baseSpeed
    }
    
    // Ураховуємо потужність двигуна
    If ..Engine '= "" {
        If ..Engine.HorsePower > 150 {
            Set maxSpeed = maxSpeed + 50
        } ElseIf ..Engine.HorsePower > 100 {
            Set maxSpeed = maxSpeed + 25
        }
    }
    
    Quit maxSpeed
}

/// Відображення інформації про мотоцикл
Method DisplayInfo()
{
    Write !,"╔════════════════════════════════════════"
    Write !,"║         МОТОЦИКЛ"   
    Write !,"║ Марка: "_$ZStrip(..Brand,"<",30)_""
    Write !,"║ Модель: "_$ZStrip(..Model,"<",28)_""
    Write !,"║ VIN: "_$ZStrip(..VIN,"<",30)_""
    Write !,"║ Рік: "_..Year_""
    Write !,"║ Колір: "_$ZStrip(..Color,"<",28)_""
    Write !,"║ Тип: "_$ZStrip(..MotorcycleType,"<",28)_""
    
    If ..Engine '= "" {
        Write !,"║ Двигун: "_$ZStrip(..Engine.Type,"<",27)_""
        Write !,"║ Потужність: "_..Engine.HorsePower_" к.с."
    }
    
    Write !,"║ Макс. швидкість: "_..GetMaxSpeed()_" км/год"
    Write !,"║ Пробіг: "_..CurrentMileage_" км"
    
    Set gearCount = ..RequiredGear.Count()
    If gearCount > 0 {
        Write !,"║ Обов'язкове спорядження ("_gearCount_"):"
        Set key = ""
        Set i = 0
        For {
            Set key = ..RequiredGear.Next(key)
            Quit:key=""
            Set i = i + 1
            If i <= 3 {
                Write !,"║   - "_$ZStrip(..RequiredGear.GetAt(key),"<",26)_""
            }
        }
        If gearCount > 3 {
            Write !,"║   ... і ще "_(gearCount-3)_" одиниць"
        }
    }
    
    Write !,"╚════════════════════════════════════════",!
}

/// Додати обов'язкове спорядження
Method AddGear(item As %String) As %Status
{
    Set key = ..RequiredGear.Count() + 1
    Do ..RequiredGear.SetAt(item, key)
    Write "Спорядження '"_item_"' додано.",!
    Quit $$$OK
}

/// Перевірити наявність спорядження
Method HasGear(item As %String) As %Boolean
{
    Set result = 0
    Set count = ..RequiredGear.Count()

    For i = 1:1:count {
        If ..RequiredGear.GetAt(i) = item {
            Set result = 1
            Quit
        }
    }

    Quit result
}

Storage Default
{
<Data name="MotorcycleDefaultData">
<Subscript>"Motorcycle"</Subscript>
<Value name="1">
<Value>MotorcycleType</Value>
</Value>
<Value name="2">
<Value>RequiredGear</Value>
</Value>
</Data>
<DefaultData>MotorcycleDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
