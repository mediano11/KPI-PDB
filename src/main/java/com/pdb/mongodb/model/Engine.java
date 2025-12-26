package com.pdb.mongodb.model;

/**
 * Клас Engine (Двигун) - вбудована модель (embeddable в Vehicle)
 */
public class Engine {
    private String type;
    private Integer horsePower;

    public Engine() {
    }

    public Engine(String type, Integer horsePower) {
        this.type = type;
        this.horsePower = horsePower;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Integer getHorsePower() {
        return horsePower;
    }

    public void setHorsePower(Integer horsePower) {
        this.horsePower = horsePower;
    }

    // Методи з вимог
    public void start() {
        System.out.println("Двигун запущено");
    }

    public void stop() {
        System.out.println("Двигун зупинено");
    }

    @Override
    public String toString() {
        return "Engine{" +
                "type='" + type + '\'' +
                ", horsePower=" + horsePower +
                '}';
    }
}

