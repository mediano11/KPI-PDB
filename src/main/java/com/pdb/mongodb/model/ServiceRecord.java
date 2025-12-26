package com.pdb.mongodb.model;

import org.bson.types.ObjectId;
import java.time.LocalDate;

/**
 * Клас ServiceRecord (Сервісний запис) - нормалізована модель (окрема колекція)
 */
public class ServiceRecord {
    private ObjectId id;
    private LocalDate serviceDate;
    private String description;
    private Double cost;
    private String performedBy;
    private Double mileage;
    
    // Нормалізований зв'язок (посилання на Vehicle через VIN)
    private String vehicleVin;

    public ServiceRecord() {
    }

    public ServiceRecord(LocalDate serviceDate, String description, Double cost,
                        String performedBy, Double mileage, String vehicleVin) {
        this.serviceDate = serviceDate;
        this.description = description;
        this.cost = cost;
        this.performedBy = performedBy;
        this.mileage = mileage;
        this.vehicleVin = vehicleVin;
    }

    public ObjectId getId() {
        return id;
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public LocalDate getServiceDate() {
        return serviceDate;
    }

    public void setServiceDate(LocalDate serviceDate) {
        this.serviceDate = serviceDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Double getCost() {
        return cost;
    }

    public void setCost(Double cost) {
        this.cost = cost;
    }

    public String getPerformedBy() {
        return performedBy;
    }

    public void setPerformedBy(String performedBy) {
        this.performedBy = performedBy;
    }

    public Double getMileage() {
        return mileage;
    }

    public void setMileage(Double mileage) {
        this.mileage = mileage;
    }

    public String getVehicleVin() {
        return vehicleVin;
    }

    public void setVehicleVin(String vehicleVin) {
        this.vehicleVin = vehicleVin;
    }

    @Override
    public String toString() {
        return "ServiceRecord{" +
                "id=" + id +
                ", serviceDate=" + serviceDate +
                ", description='" + description + '\'' +
                ", cost=" + cost +
                ", performedBy='" + performedBy + '\'' +
                ", mileage=" + mileage +
                ", vehicleVin='" + vehicleVin + '\'' +
                '}';
    }
}

