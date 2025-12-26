package com.pdb.mongodb.model;

import org.bson.types.ObjectId;

/**
 * Клас Owner (Власник) - нормалізована модель (окрема колекція)
 */
public class Owner {
    private ObjectId id;
    private Integer ownerId; // Унікальний ідентифікатор власника
    private String name;
    private String email;
    private String phone;

    public Owner() {
    }

    public Owner(Integer ownerId, String name, String email, String phone) {
        this.ownerId = ownerId;
        this.name = name;
        this.email = email;
        this.phone = phone;
    }

    public ObjectId getMongoId() {
        return id;
    }

    public void setMongoId(ObjectId id) {
        this.id = id;
    }

    public Integer getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    // Методи з вимог
    public Integer getId() {
        return ownerId;
    }

    public String getContact() {
        return "Email: " + email + ", Phone: " + phone;
    }

    @Override
    public String toString() {
        return "Owner{" +
                "id=" + id +
                ", ownerId=" + ownerId +
                ", name='" + name + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                '}';
    }
}

