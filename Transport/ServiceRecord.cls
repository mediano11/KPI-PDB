Class Transport.ServiceRecord Extends %Persistent
{

/// Дата обслуговування
Property ServiceDate As %Date [ Required ];

/// Опис робіт
Property Description As %String(MAXLEN = 500);

/// Вартість обслуговування
Property Cost As %Numeric(SCALE = 2);

/// Виконано
Property PerformedBy As %String(MAXLEN = 200);

/// Пробіг на момент обслуговування
Property Mileage As %Numeric(SCALE = 2);

/// Транспортний засіб
Relationship Vehicle As Transport.Vehicle [ Cardinality = parent, Inverse = ServiceRecords ];

/// Індекс на дату обслуговування
Index ServiceDateIndex On ServiceDate;

Storage Default
{
<Data name="ServiceRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceDate</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>Cost</Value>
</Value>
<Value name="5">
<Value>PerformedBy</Value>
</Value>
<Value name="6">
<Value>Mileage</Value>
</Value>
<Value name="7">
<Value>Vehicle</Value>
</Value>
</Data>
<DataLocation>^Transport.ServiceRecordD</DataLocation>
<DefaultData>ServiceRecordDefaultData</DefaultData>
<IdLocation>^Transport.ServiceRecordD</IdLocation>
<IndexLocation>^Transport.ServiceRecordI</IndexLocation>
<StreamLocation>^Transport.ServiceRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
