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

/// Запит: Отримати історію обслуговування для транспортного засобу
/// Використовує оператор -> для доступу до властивостей Vehicle
Query GetServiceHistoryByVehicle(vehicleId As %Integer) As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, ServiceDate, Description, Cost, PerformedBy, Mileage,
           Vehicle->Brand As VehicleBrand,
           Vehicle->Model As VehicleModel,
           Vehicle->VIN As VehicleVIN
    FROM Transport.ServiceRecord
    WHERE Vehicle = :vehicleId
    ORDER BY ServiceDate DESC
}

/// Запит: Отримати записи обслуговування з високою вартістю
Query GetExpensiveServices(minCost As %Numeric = 1000) As %SQLQuery(CONTAINID = 1)
{
    SELECT %ID, ServiceDate, Description, Cost, PerformedBy,
           Vehicle->Brand As VehicleBrand,
           Vehicle->Model As VehicleModel,
           Vehicle->Owner->Name As OwnerName
    FROM Transport.ServiceRecord
    WHERE Cost >= :minCost
    ORDER BY Cost DESC
}

/// Метод класу: Підрахунок записів обслуговування за період (вбудований SQL - простий вираз)
ClassMethod CountServicesByPeriod(startDate As %Date, endDate As %Date) As %Integer
{
    New SQLCODE
    &sql(SELECT COUNT(*) INTO :count 
         FROM ServiceRecord 
         WHERE ServiceDate BETWEEN :startDate AND :endDate)
    If SQLCODE = 0 {
        Quit count
    }
    Quit 0
}

/// Метод класу: Обчислити загальну вартість обслуговування для транспортного засобу (вбудований SQL)
ClassMethod GetTotalServiceCostByVehicle(vehicleId As %Integer) As %Numeric
{
    New SQLCODE
    &sql(SELECT SUM(Cost) INTO :totalCost 
         FROM ServiceRecord 
         WHERE Vehicle = :vehicleId)
    If SQLCODE = 0 && (totalCost '= "") {
        Quit totalCost
    }
    Quit 0
}

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
