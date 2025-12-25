Class Transport.SOAP.ServiceRecordService Extends %SOAP.WebService
{

/// Ім'я веб-сервісу
Parameter SERVICENAME = "ServiceRecordService";

/// Namespace для SOAP
Parameter NAMESPACE = "http://tempuri.org";

/// Використовувати літерали в WSDL
Parameter USECLASSNAMESPACES = 1;

/// Створити запис обслуговування
Method CreateServiceRecord(vehicleId As %Integer, serviceDate As %String, description As %String, cost As %Numeric, performedBy As %String, mileage As %Numeric) As %String [ WebMethod ]
{
    Set result = ""
    Try {
        Set vehicle = ##class(Transport.Vehicle).%OpenId(vehicleId)
        If '$IsObject(vehicle) {
            Return "Транспортний засіб не знайдено"
        }
        
        Set record = ##class(Transport.ServiceRecord).%New()
        Set record.Vehicle = vehicle
        Set record.ServiceDate = $ZDateH(serviceDate,3)
        If description '= "" Set record.Description = description
        If cost '= "" Set record.Cost = cost
        If performedBy '= "" Set record.PerformedBy = performedBy
        If mileage '= "" Set record.Mileage = mileage
        
        Set sc = record.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Успішно створено. ID: "_record.%Id()
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Отримати запис обслуговування за ID
Method GetServiceRecord(id As %Integer) As %String [ WebMethod ]
{
    Set record = ##class(Transport.ServiceRecord).%OpenId(id)
    If '$IsObject(record) {
        Return "Запис обслуговування не знайдено"
    }
    
    Set result = "ID: "_record.%Id()_", Дата: "_$ZDate(record.ServiceDate,3)
    If record.Description '= "" Set result = result_", Опис: "_record.Description
    If record.Cost '= "" Set result = result_", Вартість: "_record.Cost_" грн"
    If record.PerformedBy '= "" Set result = result_", Виконано: "_record.PerformedBy
    If record.Mileage '= "" Set result = result_", Пробіг: "_record.Mileage_" км"
    If $IsObject(record.Vehicle) {
        Set result = result_", Транспорт: "_record.Vehicle.Brand_" "_record.Vehicle.Model
    }
    
    Return result
}

/// Отримати всі записи обслуговування
Method GetAllServiceRecords() As %String [ WebMethod ]
{
    Set result = ""
    Set count = 0
    Set rs = ##class(%ResultSet).%New("Transport.ServiceRecord:Extent")
    Do rs.Execute()
    
    While rs.Next() {
        Set recordId = rs.Get("ID")
        Set record = ##class(Transport.ServiceRecord).%OpenId(recordId)
        If $IsObject(record) {
            Set count = count + 1
            If result '= "" Set result = result_"; "
            Set result = result_count_". "_$ZDate(record.ServiceDate,3)_" - "_record.Description_" (ID: "_recordId_")"
        }
    }
    
    If result = "" {
        Return "Записи обслуговування не знайдено"
    }
    
    Return "Всього: "_count_". "_result
}

/// Оновити запис обслуговування
Method UpdateServiceRecord(id As %Integer, serviceDate As %String, description As %String, cost As %Numeric, performedBy As %String, mileage As %Numeric) As %String [ WebMethod ]
{
    Set record = ##class(Transport.ServiceRecord).%OpenId(id)
    If '$IsObject(record) {
        Return "Запис обслуговування не знайдено"
    }
    
    Set result = ""
    Try {
        If serviceDate '= "" Set record.ServiceDate = $ZDateH(serviceDate,3)
        If description '= "" Set record.Description = description
        If cost '= "" Set record.Cost = cost
        If performedBy '= "" Set record.PerformedBy = performedBy
        If mileage '= "" Set record.Mileage = mileage
        
        Set sc = record.%Save()
        
        If $$$ISOK(sc) {
            Set result = "Запис обслуговування успішно оновлено"
        } Else {
            Set result = "Помилка: "_$System.Status.GetErrorText(sc)
        }
    } Catch ex {
        Set result = "Помилка: "_ex.AsString()
    }
    Return result
}

/// Видалити запис обслуговування
Method DeleteServiceRecord(id As %Integer) As %String [ WebMethod ]
{
    Set sc = ##class(Transport.ServiceRecord).%DeleteId(id)
    
    If $$$ISOK(sc) {
        Return "Запис обслуговування успішно видалено"
    } Else {
        Return "Помилка: "_$System.Status.GetErrorText(sc)
    }
}

}
