package com.pdb.mongodb.model;

import org.bson.types.ObjectId;
import java.time.LocalDate;
import java.util.List;

/**
 * Базовий клас Vehicle (Транспортний засіб)
 */
public class Vehicle {
    private ObjectId id;
    private String vehicleType; // "Car", "Motorcycle", "Truck"
    private String brand;
    private String model;
    private String vin;
    private Integer year;
    private String color;
    private Integer age; // Обчислюється автоматично
    private String fullName; // Обчислюється автоматично
    
    // Нормалізовані зв'язки (посилання)
    private Integer ownerId; // Посилання на Owner
    
    // Вбудований об'єкт
    private Engine engine;

    public Vehicle() {
    }

    public Vehicle(String vehicleType, String brand, String model, String vin, 
                   Integer year, String color, Integer ownerId, Engine engine) {
        this.vehicleType = vehicleType;
        this.brand = brand;
        this.model = model;
        this.vin = vin;
        this.year = year;
        this.color = color;
        this.ownerId = ownerId;
        this.engine = engine;
        calculateAge();
        calculateFullName();
    }

    public ObjectId getId() {
        return id;
    }

    public void setId(ObjectId id) {
        this.id = id;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
        calculateFullName();
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
        calculateFullName();
    }

    public String getVin() {
        return vin;
    }

    public void setVin(String vin) {
        this.vin = vin;
    }

    public Integer getYear() {
        return year;
    }

    public void setYear(Integer year) {
        this.year = year;
        calculateAge();
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public Engine getEngine() {
        return engine;
    }

    public void setEngine(Engine engine) {
        this.engine = engine;
    }

    private void calculateAge() {
        if (year != null) {
            this.age = LocalDate.now().getYear() - year;
        }
    }

    private void calculateFullName() {
        if (brand != null && model != null) {
            this.fullName = brand + " " + model;
        }
    }

    // Методи з вимог
    public void start() {
        System.out.println("Транспортний засіб запущено");
        if (engine != null) {
            engine.start();
        }
    }

    public void stop() {
        System.out.println("Транспортний засіб зупинено");
        if (engine != null) {
            engine.stop();
        }
    }

    public void move(Double distance) {
        System.out.println("Транспортний засіб проїхав " + distance + " км");
    }

    public void accelerate(Double speed) {
        System.out.println("Транспортний засіб прискорився до " + speed + " км/год");
    }

    public Double getMaxSpeed() {
        // Базова реалізація, перевизначається в підкласах
        if (engine != null && engine.getHorsePower() != null) {
            return engine.getHorsePower() * 1.5;
        }
        return 120.0;
    }

    public void displayInfo() {
        System.out.println("=== Інформація про транспортний засіб ===");
        System.out.println("Повна назва: " + fullName);
        System.out.println("VIN: " + vin);
        System.out.println("Рік: " + year + " (вік: " + age + " років)");
        System.out.println("Колір: " + color);
        if (engine != null) {
            System.out.println("Двигун: " + engine);
        }
    }

    @Override
    public String toString() {
        return "Vehicle{" +
                "id=" + id +
                ", vehicleType='" + vehicleType + '\'' +
                ", brand='" + brand + '\'' +
                ", model='" + model + '\'' +
                ", vin='" + vin + '\'' +
                ", year=" + year +
                ", color='" + color + '\'' +
                ", age=" + age +
                ", fullName='" + fullName + '\'' +
                ", ownerId=" + ownerId +
                ", engine=" + engine +
                '}';
    }
}

