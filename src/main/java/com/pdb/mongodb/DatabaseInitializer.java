package com.pdb.mongodb;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.IndexOptions;
import com.pdb.mongodb.model.*;
import org.bson.Document;
import org.bson.types.ObjectId;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import static com.mongodb.client.model.Filters.eq;

/**
 * Клас для ініціалізації бази даних та створення колекцій з документами
 */
public class DatabaseInitializer {
    private MongoDatabase database;

    public DatabaseInitializer(MongoDatabase database) {
        this.database = database;
    }

    public void initializeDatabase() {
        System.out.println("\n=== Ініціалізація бази даних ===");
        
        // Створення колекцій
        createCollections();
        
        // Створення індексів
        createIndexes();
        
        // Заповнення даними
        insertOwners();
        insertVehicles();
        insertServiceRecords();
        
        System.out.println("База даних успішно ініціалізована!\n");
    }

    private void createCollections() {
        // Колекції створюються автоматично при першому додаванні документа
        System.out.println("Колекції будуть створені автоматично...");
    }

    private void createIndexes() {
        // Створення унікальних індексів
        MongoCollection<Document> vehicles = database.getCollection("vehicles");
        vehicles.createIndex(new Document("vin", 1), new IndexOptions().unique(true));
        
        MongoCollection<Document> owners = database.getCollection("owners");
        owners.createIndex(new Document("ownerId", 1), new IndexOptions().unique(true));
        
        System.out.println("Індекси створено");
    }

    private void insertOwners() {
        MongoCollection<Document> ownersCollection = database.getCollection("owners");
        
        List<Owner> owners = Arrays.asList(
            new Owner(1, "Іван Петренко", "ivan.petrenko@email.com", "+380501234567"),
            new Owner(2, "Марія Коваленко", "maria.kovalenko@email.com", "+380507654321"),
            new Owner(3, "Олександр Сидоренко", "oleksandr.sydorenko@email.com", "+380509876543"),
            new Owner(4, "Олена Мельник", "olena.melnyk@email.com", "+380501112233")
        );

        for (Owner owner : owners) {
            Document doc = new Document("ownerId", owner.getOwnerId())
                    .append("name", owner.getName())
                    .append("email", owner.getEmail())
                    .append("phone", owner.getPhone());
            ownersCollection.insertOne(doc);
        }
        
        System.out.println("Додано 4 власників");
    }

    private void insertVehicles() {
        MongoCollection<Document> vehiclesCollection = database.getCollection("vehicles");

        // 4 автомобілі
        List<Car> cars = Arrays.asList(
            new Car("Toyota", "Camry", "VIN001", 2020, "Червоний", 1,
                   new Engine("Бензиновий", 200), "Седан", Arrays.asList("Іван Петренко", "Марія Петренко")),
            new Car("Honda", "Civic", "VIN002", 2019, "Сірий", 2,
                   new Engine("Бензиновий", 180), "Хетчбек", Arrays.asList("Марія Коваленко")),
            new Car("BMW", "X5", "VIN003", 2021, "Чорний", 1,
                   new Engine("Дизельний", 250), "Позашляховик", Arrays.asList("Іван Петренко", "Марія Петренко", "Діти")),
            new Car("Mercedes", "C-Class", "VIN004", 2022, "Білий", 3,
                   new Engine("Бензиновий", 220), "Седан", Arrays.asList("Олександр Сидоренко"))
        );

        for (Car car : cars) {
            Document engineDoc = new Document("type", car.getEngine().getType())
                    .append("horsePower", car.getEngine().getHorsePower());
            
            Document carDoc = new Document("vehicleType", "Car")
                    .append("brand", car.getBrand())
                    .append("model", car.getModel())
                    .append("vin", car.getVin())
                    .append("year", car.getYear())
                    .append("color", car.getColor())
                    .append("age", car.getAge())
                    .append("fullName", car.getFullName())
                    .append("ownerId", car.getOwnerId())
                    .append("engine", engineDoc) // Вбудований об'єкт
                    .append("bodyType", car.getBodyType())
                    .append("passengers", car.getPassengers());
            
            vehiclesCollection.insertOne(carDoc);
        }

        // 4 мотоцикли
        List<Motorcycle> motorcycles = Arrays.asList(
            new Motorcycle("Yamaha", "YZF-R1", "VIN101", 2020, "Синій", 2,
                         new Engine("Бензиновий", 150), "Спортивний", 
                         Arrays.asList("Шолом", "Черевики", "Перчатки", "Захисний костюм")),
            new Motorcycle("Honda", "CBR600RR", "VIN102", 2019, "Червоний", 4,
                         new Engine("Бензиновий", 120), "Спортивний", 
                         Arrays.asList("Шолом", "Черевики", "Перчатки")),
            new Motorcycle("Kawasaki", "Ninja ZX-10R", "VIN103", 2021, "Зелений", 3,
                         new Engine("Бензиновий", 200), "Спортивний", 
                         Arrays.asList("Шолом", "Черевики", "Перчатки", "Захисний костюм", "Захисний налітник")),
            new Motorcycle("Ducati", "Panigale V4", "VIN104", 2022, "Червоний", 1,
                         new Engine("Бензиновий", 215), "Спортивний", 
                         Arrays.asList("Шолом", "Черевики", "Перчатки"))
        );

        for (Motorcycle motorcycle : motorcycles) {
            Document engineDoc = new Document("type", motorcycle.getEngine().getType())
                    .append("horsePower", motorcycle.getEngine().getHorsePower());
            
            Document motorcycleDoc = new Document("vehicleType", "Motorcycle")
                    .append("brand", motorcycle.getBrand())
                    .append("model", motorcycle.getModel())
                    .append("vin", motorcycle.getVin())
                    .append("year", motorcycle.getYear())
                    .append("color", motorcycle.getColor())
                    .append("age", motorcycle.getAge())
                    .append("fullName", motorcycle.getFullName())
                    .append("ownerId", motorcycle.getOwnerId())
                    .append("engine", engineDoc) // Вбудований об'єкт
                    .append("motorcycleType", motorcycle.getMotorcycleType())
                    .append("requiredGear", motorcycle.getRequiredGear());
            
            vehiclesCollection.insertOne(motorcycleDoc);
        }

        // 4 вантажівки
        List<Truck> trucks = Arrays.asList(
            new Truck("Volvo", "FH16", "VIN201", 2020, "Білий", 1,
                     new Engine("Дизельний", 500), 20.0,
                     Arrays.asList(
                         new CargItem("Меблі", 5.5),
                         new CargItem("Побутова техніка", 3.2)
                     )),
            new Truck("Mercedes", "Actros", "VIN202", 2019, "Сірий", 2,
                     new Engine("Дизельний", 450), 18.0,
                     Arrays.asList(
                         new CargItem("Будівельні матеріали", 12.0),
                         new CargItem("Цемент", 5.0)
                     )),
            new Truck("Scania", "R-Series", "VIN203", 2021, "Червоний", 3,
                     new Engine("Дизельний", 480), 22.0,
                     Arrays.asList(
                         new CargItem("Продукти харчування", 8.0),
                         new CargItem("Напої", 4.5),
                         new CargItem("Консерви", 2.0)
                     )),
            new Truck("MAN", "TGX", "VIN204", 2022, "Синій", 4,
                     new Engine("Дизельний", 520), 25.0,
                     Arrays.asList(
                         new CargItem("Автозапчастини", 10.0),
                         new CargItem("Шини", 3.5)
                     ))
        );

        for (Truck truck : trucks) {
            Document engineDoc = new Document("type", truck.getEngine().getType())
                    .append("horsePower", truck.getEngine().getHorsePower());
            
            List<Document> cargoDocs = new ArrayList<>();
            if (truck.getCargo() != null) {
                for (CargItem item : truck.getCargo()) {
                    cargoDocs.add(new Document("name", item.getName())
                            .append("weight", item.getWeight()));
                }
            }
            
            Document truckDoc = new Document("vehicleType", "Truck")
                    .append("brand", truck.getBrand())
                    .append("model", truck.getModel())
                    .append("vin", truck.getVin())
                    .append("year", truck.getYear())
                    .append("color", truck.getColor())
                    .append("age", truck.getAge())
                    .append("fullName", truck.getFullName())
                    .append("ownerId", truck.getOwnerId())
                    .append("engine", engineDoc) // Вбудований об'єкт
                    .append("loadCapacity", truck.getLoadCapacity())
                    .append("cargo", cargoDocs); // Вбудований масив (parent-children)
            
            vehiclesCollection.insertOne(truckDoc);
        }

        System.out.println("Додано 12 транспортних засобів (4 автомобілі, 4 мотоцикли, 4 вантажівки)");
    }

    private void insertServiceRecords() {
        MongoCollection<Document> serviceRecordsCollection = database.getCollection("serviceRecords");

        List<ServiceRecord> records = Arrays.asList(
            new ServiceRecord(LocalDate.of(2023, 1, 15), "Заміна масла та фільтрів", 2500.0, 
                            "Сервісний центр Toyota", 15000.0, "VIN001"),
            new ServiceRecord(LocalDate.of(2023, 6, 20), "Технічний огляд", 1200.0, 
                            "СТО Автосервіс", 30000.0, "VIN001"),
            new ServiceRecord(LocalDate.of(2023, 3, 10), "Заміна гальмівних колодок", 3500.0, 
                            "Сервісний центр Honda", 25000.0, "VIN002"),
            new ServiceRecord(LocalDate.of(2023, 9, 5), "Ремонт підвіски", 8500.0, 
                            "СТО Механік", 45000.0, "VIN002"),
            new ServiceRecord(LocalDate.of(2023, 2, 28), "Заміна масла", 4500.0, 
                            "Сервісний центр BMW", 20000.0, "VIN003"),
            new ServiceRecord(LocalDate.of(2023, 8, 12), "Заміна ременя ГРМ", 12000.0, 
                            "СТО Профі", 55000.0, "VIN003"),
            new ServiceRecord(LocalDate.of(2023, 4, 18), "Заміна масла та фільтрів", 5000.0, 
                            "Сервісний центр Mercedes", 18000.0, "VIN004"),
            new ServiceRecord(LocalDate.of(2023, 11, 30), "Технічне обслуговування", 3500.0, 
                            "СТО Автомайстер", 35000.0, "VIN004"),
            new ServiceRecord(LocalDate.of(2023, 5, 22), "Заміна масла в двигуні", 1800.0, 
                            "Мотосервіс", 12000.0, "VIN101"),
            new ServiceRecord(LocalDate.of(2023, 10, 8), "Регулювання карбюратора", 2500.0, 
                            "Мотосервіс", 25000.0, "VIN102"),
            new ServiceRecord(LocalDate.of(2023, 7, 14), "Заміна свічок запалювання", 1500.0, 
                            "СТО Мото", 18000.0, "VIN103"),
            new ServiceRecord(LocalDate.of(2023, 12, 3), "Заміна масла та фільтрів", 3200.0, 
                            "Мотосервіс", 8000.0, "VIN104"),
            new ServiceRecord(LocalDate.of(2023, 3, 25), "Технічне обслуговування", 15000.0, 
                            "Сервіс вантажівок", 50000.0, "VIN201"),
            new ServiceRecord(LocalDate.of(2023, 9, 10), "Ремонт гідравліки", 25000.0, 
                            "СТО Тягачів", 120000.0, "VIN201"),
            new ServiceRecord(LocalDate.of(2023, 1, 8), "Заміна масла", 8000.0, 
                            "Сервіс вантажівок", 35000.0, "VIN202"),
            new ServiceRecord(LocalDate.of(2023, 6, 15), "Заміна гальмівних дисків", 18000.0, 
                            "СТО Тягачів", 80000.0, "VIN203")
        );

        for (ServiceRecord record : records) {
            Document doc = new Document("serviceDate", record.getServiceDate().toString())
                    .append("description", record.getDescription())
                    .append("cost", record.getCost())
                    .append("performedBy", record.getPerformedBy())
                    .append("mileage", record.getMileage())
                    .append("vehicleVin", record.getVehicleVin()); // Посилання на Vehicle
            serviceRecordsCollection.insertOne(doc);
        }

        System.out.println("Додано " + records.size() + " сервісних записів");
    }
}

