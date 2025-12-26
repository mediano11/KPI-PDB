package com.pdb.mongodb;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

import java.util.Arrays;
import java.util.List;

import static com.mongodb.client.model.Filters.*;

/**
 * Головна програма для роботи з MongoDB базою даних транспортних засобів
 */
public class Main {
    private MongoDBConnection connection;
    private MongoDatabase database;

    public static void main(String[] args) {
        Main main = new Main();
        try {
            // Ініціалізація бази даних
            main.initializeDatabase();
            
            // Виконання завдань
            main.displayAllDocuments();
            main.keyValueQuery();
            main.aggregationQuery();
            
        } catch (Exception e) {
            System.err.println("Помилка: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (main.connection != null) {
                main.connection.close();
            }
        }
    }

    private void initializeDatabase() {
        connection = new MongoDBConnection();
        database = connection.getDatabase();
        
        DatabaseInitializer initializer = new DatabaseInitializer(database);
        initializer.initializeDatabase();
    }

    /**
     * Завдання 1: Виведення усіх документів колекцій
     */
    private void displayAllDocuments() {
        System.out.println("\n" + "-".repeat(40));
        System.out.println("ЗАВДАННЯ 1: ВИВЕДЕННЯ УСІХ ДОКУМЕНТІВ КОЛЕКЦІЙ");
        System.out.println("-".repeat(40));

        // Виведення власників
        System.out.println("\n--- КОЛЕКЦІЯ: owners ---");
        MongoCollection<Document> ownersCollection = database.getCollection("owners");
        int ownerCount = 1;
        for (Document owner : ownersCollection.find()) {
            System.out.println("\nВласник #" + ownerCount++ + ":");
            System.out.println("  ID: " + owner.getInteger("ownerId"));
            System.out.println("  Ім'я: " + owner.getString("name"));
            System.out.println("  Email: " + owner.getString("email"));
            System.out.println("  Телефон: " + owner.getString("phone"));
        }

        // Виведення транспортних засобів
        System.out.println("\n--- КОЛЕКЦІЯ: vehicles ---");
        MongoCollection<Document> vehiclesCollection = database.getCollection("vehicles");
        int vehicleCount = 1;
        for (Document vehicle : vehiclesCollection.find()) {
            System.out.println("\nТранспортний засіб #" + vehicleCount++ + ":");
            System.out.println("  Тип: " + vehicle.getString("vehicleType"));
            System.out.println("  Марка: " + vehicle.getString("brand"));
            System.out.println("  Модель: " + vehicle.getString("model"));
            System.out.println("  VIN: " + vehicle.getString("vin"));
            System.out.println("  Рік: " + vehicle.getInteger("year"));
            System.out.println("  Колір: " + vehicle.getString("color"));
            System.out.println("  Вік: " + vehicle.getInteger("age") + " років");
            System.out.println("  ID власника: " + vehicle.getInteger("ownerId"));
            
            // Вбудований двигун
            Document engine = vehicle.get("engine", Document.class);
            if (engine != null) {
                System.out.println("  Двигун: " + engine.getString("type") + 
                                 ", Потужність: " + engine.getInteger("horsePower") + " к.с.");
            }
            
            // Додаткові поля для різних типів транспортних засобів
            if ("Car".equals(vehicle.getString("vehicleType"))) {
                System.out.println("  Тип кузова: " + vehicle.getString("bodyType"));
                System.out.println("  Пасажири: " + vehicle.getList("passengers", String.class));
            } else if ("Motorcycle".equals(vehicle.getString("vehicleType"))) {
                System.out.println("  Тип мотоцикла: " + vehicle.getString("motorcycleType"));
                System.out.println("  Екіпірування: " + vehicle.getList("requiredGear", String.class));
            } else if ("Truck".equals(vehicle.getString("vehicleType"))) {
                System.out.println("  Вантажопідйомність: " + vehicle.getDouble("loadCapacity") + " тонн");
                @SuppressWarnings("unchecked")
                List<Document> cargo = vehicle.getList("cargo", Document.class);
                if (cargo != null && !cargo.isEmpty()) {
                    System.out.println("  Вантаж:");
                    for (Document item : cargo) {
                        System.out.println("    - " + item.getString("name") + 
                                         " (" + item.getDouble("weight") + " тонн)");
                    }
                }
            }
        }

        // Виведення сервісних записів
        System.out.println("\n--- КОЛЕКЦІЯ: serviceRecords ---");
        MongoCollection<Document> serviceRecordsCollection = database.getCollection("serviceRecords");
        int recordCount = 1;
        for (Document record : serviceRecordsCollection.find()) {
            System.out.println("\nСервісний запис #" + recordCount++ + ":");
            System.out.println("  Дата: " + record.getString("serviceDate"));
            System.out.println("  Опис: " + record.getString("description"));
            System.out.println("  Вартість: " + record.getDouble("cost") + " грн");
            System.out.println("  Виконав: " + record.getString("performedBy"));
            System.out.println("  Пробіг: " + record.getDouble("mileage") + " км");
            System.out.println("  VIN транспортного засобу: " + record.getString("vehicleVin"));
        }
    }

    /**
     * Завдання 2: Запит ключ-значення з мінімум двома умовами
     * Знайти автомобілі, випущені після 2020 року, з двигуном потужністю більше 200 к.с.
     */
    private void keyValueQuery() {
        System.out.println("\n" + "-".repeat(40));
        System.out.println("ЗАВДАННЯ 2: ЗАПИТ КЛЮЧ-ЗНАЧЕННЯ З МІНІМУМ ДВОМА УМОВАМИ");
        System.out.println("Умова: Знайти автомобілі (Car), випущені після 2020 року,");
        System.out.println("       з двигуном потужністю більше 200 к.с.");
        System.out.println("-".repeat(40));

        MongoCollection<Document> vehiclesCollection = database.getCollection("vehicles");

        // Запит з двома умовами:
        // 1. vehicleType == "Car"
        // 2. year > 2020
        // 3. engine.horsePower > 200
        var query = and(
            eq("vehicleType", "Car"),
            gt("year", 2020),
            gt("engine.horsePower", 200)
        );

        System.out.println("\nРезультати запиту:");
        int count = 1;
        for (Document vehicle : vehiclesCollection.find(query)) {
            System.out.println("\nАвтомобіль #" + count++ + ":");
            System.out.println("  Марка: " + vehicle.getString("brand"));
            System.out.println("  Модель: " + vehicle.getString("model"));
            System.out.println("  VIN: " + vehicle.getString("vin"));
            System.out.println("  Рік: " + vehicle.getInteger("year"));
            System.out.println("  Колір: " + vehicle.getString("color"));
            
            Document engine = vehicle.get("engine", Document.class);
            if (engine != null) {
                System.out.println("  Двигун: " + engine.getString("type") + 
                                 ", Потужність: " + engine.getInteger("horsePower") + " к.с.");
            }
            System.out.println("  Тип кузова: " + vehicle.getString("bodyType"));
            System.out.println("  ID власника: " + vehicle.getInteger("ownerId"));
        }

        if (count == 1) {
            System.out.println("  Документів, що відповідають умовам, не знайдено.");
        } else {
            System.out.println("\nВсього знайдено: " + (count - 1) + " автомобілів");
        }
    }

    /**
     * Завдання 3: Агрегація з мінімум 4 етапами (обов'язково lookup та group)
     * Агрегація: Для кожного власника підрахувати загальну вартість сервісних обслуговувань
     * та середній пробіг транспортних засобів
     */
    private void aggregationQuery() {
        System.out.println("\n" + "-".repeat(80));
        System.out.println("ЗАВДАННЯ 3: АГРЕГАЦІЯ З МІНІМУМ 4 ЕТАПАМИ");
        System.out.println("Завдання: Для кожного власника підрахувати:");
        System.out.println("          - загальну вартість сервісних обслуговувань");
        System.out.println("          - середній пробіг транспортних засобів");
        System.out.println("          - кількість транспортних засобів");
        System.out.println("-".repeat(80));

        MongoCollection<Document> serviceRecordsCollection = database.getCollection("serviceRecords");

        List<Document> pipeline = Arrays.asList(
            // Етап 1: $lookup - з'єднання з колекцією vehicles для отримання ownerId
            new Document("$lookup",
                new Document("from", "vehicles")
                    .append("localField", "vehicleVin")
                    .append("foreignField", "vin")
                    .append("as", "vehicle")
            ),
            
            // Етап 2: $unwind - розгортання масиву vehicle
            new Document("$unwind",
                new Document("path", "$vehicle")
                    .append("preserveNullAndEmptyArrays", false)
            ),
            
            // Етап 3: $lookup - з'єднання з колекцією owners для отримання інформації про власника
            new Document("$lookup",
                new Document("from", "owners")
                    .append("localField", "vehicle.ownerId")
                    .append("foreignField", "ownerId")
                    .append("as", "owner")
            ),
            
            // Етап 4: $unwind - розгортання масиву owner
            new Document("$unwind",
                new Document("path", "$owner")
                    .append("preserveNullAndEmptyArrays", false)
            ),
            
            // Етап 5: $group - групування по власнику з агрегаціями
            new Document("$group",
                new Document("_id", "$owner.ownerId")
                    .append("ownerName", new Document("$first", "$owner.name"))
                    .append("totalServiceCost", new Document("$sum", "$cost"))
                    .append("averageMileage", new Document("$avg", "$mileage"))
                    .append("serviceCount", new Document("$sum", 1))
                    .append("vehicles", new Document("$addToSet", "$vehicle.vin"))
            ),
            
            // Етап 6: $project - формування фінального вигляду документів
            new Document("$project",
                new Document("_id", 0)
                    .append("ownerId", "$_id")
                    .append("ownerName", 1)
                    .append("totalServiceCost", new Document("$round", Arrays.asList("$totalServiceCost", 2)))
                    .append("averageMileage", new Document("$round", Arrays.asList("$averageMileage", 2)))
                    .append("serviceCount", 1)
                    .append("vehicleCount", new Document("$size", "$vehicles"))
            ),
            
            // Етап 7: $sort - сортування за загальною вартістю (від більшого до меншого)
            new Document("$sort", new Document("totalServiceCost", -1))
        );

        System.out.println("\nРезультати агрегації:");
        System.out.println("-".repeat(80));
        
        int count = 1;
        for (Document result : serviceRecordsCollection.aggregate(pipeline)) {
            System.out.println("\nВласник #" + count++ + ":");
            System.out.println("  ID власника: " + result.getInteger("ownerId"));
            System.out.println("  Ім'я: " + result.getString("ownerName"));
            System.out.println("  Загальна вартість обслуговувань: " + 
                             result.getDouble("totalServiceCost") + " грн");
            System.out.println("  Середній пробіг: " + 
                             result.getDouble("averageMileage") + " км");
            System.out.println("  Кількість сервісних записів: " + 
                             result.getInteger("serviceCount"));
            System.out.println("  Кількість транспортних засобів: " + 
                             result.getInteger("vehicleCount"));
        }

        System.out.println("\n" + "-".repeat(80));
        System.out.println("Використано етапи: $lookup (2 рази), $unwind (2 рази),");
        System.out.println("                  $group, $project, $sort");
        System.out.println("Всього етапів: 7");
    }
}

