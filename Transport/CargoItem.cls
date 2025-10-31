Class Transport.CargoItem Extends %Persistent
{

/// Назва вантажу
Property Name As %String(MAXLEN = 200) [ Required ];

/// Вага (тонни)
Property Weight As %Numeric(SCALE = 2) [ Required ];

/// Вантажівка
Relationship Truck As Transport.Truck [ Cardinality = parent, Inverse = Cargo ];

Storage Default
{
<Data name="CargoItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Weight</Value>
</Value>
<Value name="4">
<Value>Truck</Value>
</Value>
</Data>
<DataLocation>^Transport.CargoItemD</DataLocation>
<DefaultData>CargoItemDefaultData</DefaultData>
<IdLocation>^Transport.CargoItemD</IdLocation>
<IndexLocation>^Transport.CargoItemI</IndexLocation>
<StreamLocation>^Transport.CargoItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
