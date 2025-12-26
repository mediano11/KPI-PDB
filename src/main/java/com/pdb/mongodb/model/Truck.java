package com.pdb.mongodb.model;

import java.util.List;

/**
 * Клас Truck (Вантажівка) - підклас Vehicle
 * Зберігається в колекції vehicles з vehicleType = "Truck"
 * Містить вбудований список CargItem (parent-children)
 */
public class Truck extends Vehicle {
    private Double loadCapacity;
    private List<CargItem> cargo; // Вбудований список вантажів

    public Truck() {
        super();
        setVehicleType("Truck");
    }

    public Truck(String brand, String model, String vin, Integer year, String color,
                Integer ownerId, Engine engine, Double loadCapacity, List<CargItem> cargo) {
        super("Truck", brand, model, vin, year, color, ownerId, engine);
        this.loadCapacity = loadCapacity;
        this.cargo = cargo;
    }

    public Double getLoadCapacity() {
        return loadCapacity;
    }

    public void setLoadCapacity(Double loadCapacity) {
        this.loadCapacity = loadCapacity;
    }

    public List<CargItem> getCargo() {
        return cargo;
    }

    public void setCargo(List<CargItem> cargo) {
        this.cargo = cargo;
    }

    @Override
    public Double getMaxSpeed() {
        if (getEngine() != null && getEngine().getHorsePower() != null) {
            return getEngine().getHorsePower() * 1.2;
        }
        return 100.0;
    }

    @Override
    public void displayInfo() {
        super.displayInfo();
        System.out.println("Вантажопідйомність: " + loadCapacity + " тонн");
        System.out.println("Вантаж: " + (cargo != null ? cargo : "немає"));
        if (cargo != null && !cargo.isEmpty()) {
            Double totalWeight = cargo.stream().mapToDouble(CargItem::getWeight).sum();
            System.out.println("Загальна вага вантажу: " + totalWeight + " тонн");
        }
        System.out.println("Максимальна швидкість: " + getMaxSpeed() + " км/год");
    }
}

