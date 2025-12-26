package com.pdb.mongodb;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

/**
 * Клас для підключення до MongoDB
 */
public class MongoDBConnection {
    private static final String CONNECTION_STRING = "mongodb://localhost:27017";
    private static final String DATABASE_NAME = "vehicle_db";
    
    private MongoClient mongoClient;
    private MongoDatabase database;

    public MongoDBConnection() {
        connect();
    }

    private void connect() {
        try {
            mongoClient = MongoClients.create(CONNECTION_STRING);
            database = mongoClient.getDatabase(DATABASE_NAME);
            System.out.println("Підключено до MongoDB: " + DATABASE_NAME);
        } catch (Exception e) {
            System.err.println("Помилка підключення до MongoDB: " + e.getMessage());
            throw new RuntimeException("Не вдалося підключитися до MongoDB", e);
        }
    }

    public MongoDatabase getDatabase() {
        return database;
    }

    public MongoClient getMongoClient() {
        return mongoClient;
    }

    public void close() {
        if (mongoClient != null) {
            mongoClient.close();
            System.out.println("З'єднання з MongoDB закрито");
        }
    }
}

