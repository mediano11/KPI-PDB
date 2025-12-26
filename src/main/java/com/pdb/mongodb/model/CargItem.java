package com.pdb.mongodb.model;

/**
 * Клас CargItem (Вантаж) - вбудована модель (embeddable в Truck)
 */
public class CargItem {
    private String name;
    private Double weight;

    public CargItem() {
    }

    public CargItem(String name, Double weight) {
        this.name = name;
        this.weight = weight;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Double getWeight() {
        return weight;
    }

    public void setWeight(Double weight) {
        this.weight = weight;
    }

    @Override
    public String toString() {
        return "CargItem{" +
                "name='" + name + '\'' +
                ", weight=" + weight +
                '}';
    }
}

