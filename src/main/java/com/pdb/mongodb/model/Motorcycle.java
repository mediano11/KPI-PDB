package com.pdb.mongodb.model;

import java.util.List;

/**
 * Клас Motorcycle (Мотоцикл) - підклас Vehicle
 * Зберігається в колекції vehicles з vehicleType = "Motorcycle"
 */
public class Motorcycle extends Vehicle {
    private String motorcycleType;
    private List<String> requiredGear;

    public Motorcycle() {
        super();
        setVehicleType("Motorcycle");
    }

    public Motorcycle(String brand, String model, String vin, Integer year, String color,
                     Integer ownerId, Engine engine, String motorcycleType, List<String> requiredGear) {
        super("Motorcycle", brand, model, vin, year, color, ownerId, engine);
        this.motorcycleType = motorcycleType;
        this.requiredGear = requiredGear;
    }

    public String getMotorcycleType() {
        return motorcycleType;
    }

    public void setMotorcycleType(String motorcycleType) {
        this.motorcycleType = motorcycleType;
    }

    public List<String> getRequiredGear() {
        return requiredGear;
    }

    public void setRequiredGear(List<String> requiredGear) {
        this.requiredGear = requiredGear;
    }

    @Override
    public Double getMaxSpeed() {
        if (getEngine() != null && getEngine().getHorsePower() != null) {
            return getEngine().getHorsePower() * 3.0;
        }
        return 200.0;
    }

    @Override
    public void displayInfo() {
        super.displayInfo();
        System.out.println("Тип мотоцикла: " + motorcycleType);
        System.out.println("Обов'язкове екіпірування: " + (requiredGear != null ? requiredGear : "немає"));
        System.out.println("Максимальна швидкість: " + getMaxSpeed() + " км/год");
    }
}

