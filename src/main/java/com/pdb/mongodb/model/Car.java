package com.pdb.mongodb.model;

import java.util.List;

/**
 * Клас Car (Автомобіль) - підклас Vehicle
 * Зберігається в колекції vehicles з vehicleType = "Car"
 */
public class Car extends Vehicle {
    private String bodyType;
    private List<String> passengers;

    public Car() {
        super();
        setVehicleType("Car");
    }

    public Car(String brand, String model, String vin, Integer year, String color,
               Integer ownerId, Engine engine, String bodyType, List<String> passengers) {
        super("Car", brand, model, vin, year, color, ownerId, engine);
        this.bodyType = bodyType;
        this.passengers = passengers;
    }

    public String getBodyType() {
        return bodyType;
    }

    public void setBodyType(String bodyType) {
        this.bodyType = bodyType;
    }

    public List<String> getPassengers() {
        return passengers;
    }

    public void setPassengers(List<String> passengers) {
        this.passengers = passengers;
    }

    @Override
    public Double getMaxSpeed() {
        if (getEngine() != null && getEngine().getHorsePower() != null) {
            return getEngine().getHorsePower() * 2.0;
        }
        return 180.0;
    }

    @Override
    public void displayInfo() {
        super.displayInfo();
        System.out.println("Тип кузова: " + bodyType);
        System.out.println("Пасажири: " + (passengers != null ? passengers : "немає"));
        System.out.println("Максимальна швидкість: " + getMaxSpeed() + " км/год");
    }
}

