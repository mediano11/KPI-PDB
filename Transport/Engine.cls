Class Transport.Engine Extends %SerialObject
{

/// Тип двигуна
Property Type As %String(MAXLEN = 50);

/// Потужність в кінських силах
Property HorsePower As %Integer;

/// Стан двигуна (0 - вимкнений, 1 - працює)
Property IsRunning As %Boolean [ InitialExpression = 0 ];

/// Запустити двигун
Method Start() As %Status
{
    If ..IsRunning {
        Write "Двигун вже працює!",!
        Quit $$$OK
    }
    Set ..IsRunning = 1
    Write "Двигун запущено. Потужність: "_..HorsePower_" к.с.",!
    Quit $$$OK
}

/// Зупинити двигун
Method Stop() As %Status
{
    If '..IsRunning {
        Write "Двигун вже вимкнений!",!
        Quit $$$OK
    }
    Set ..IsRunning = 0
    Write "Двигун зупинено.",!
    Quit $$$OK
}

/// Перевірити чи працює двигун
Method IsEngineRunning() As %Boolean
{
    Quit ..IsRunning
}

Storage Default
{
<Data name="EngineState">
<Value name="1">
<Value>Type</Value>
</Value>
<Value name="2">
<Value>HorsePower</Value>
</Value>
<Value name="3">
<Value>IsRunning</Value>
</Value>
</Data>
<State>EngineState</State>
<StreamLocation>^Transport.EngineS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
