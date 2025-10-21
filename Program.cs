using System;
using System.Collections.Generic;

namespace TransportVehicles
{
    public class Engine
    {
        public string Type { get; set; }
        public int HorsePower { get; set; }
        private bool _isRunning;

        public Engine(string type, int horsePower)
        {
            Type = type;
            HorsePower = horsePower;
            _isRunning = false;
        }

        public void Start()
        {
            _isRunning = true;
            Console.WriteLine($"  Двигун {Type} ({HorsePower} к.с.) запущено");
        }

        public void Stop()
        {
            _isRunning = false;
            Console.WriteLine($"  Двигун зупинено");
        }

        public bool IsRunning() => _isRunning;

        public override string ToString() => $"{Type}, {HorsePower} к.с.";
    }

    // Абстрактний базовий клас для транспортного засобу
    public abstract class Vehicle
    {
        // Публічні властивості простих типів
        public string Brand { get; set; }
        public string Model { get; set; }
        public int Year { get; set; }
        public string Color { get; set; }

        // Посилання на інший об'єкт
        public Engine VehicleEngine { get; set; }

        // Приватні поля
        private double _mileage;
        private double _currentSpeed;

        // колекція простих типів
        public List<string> TripHistory { get; set; }

        protected Vehicle(string brand, string model, int year, string color, Engine engine)
        {
            Brand = brand;
            Model = model;
            Year = year;
            Color = color;
            VehicleEngine = engine;
            _mileage = 0;
            _currentSpeed = 0;
            TripHistory = new List<string>();
        }

        // Віртуальні методи для перевантаження
        public virtual void Start()
        {
            Console.WriteLine($"\n{Brand} {Model} запускається...");
            VehicleEngine.Start();
        }

        public virtual void Stop()
        {
            _currentSpeed = 0;
            VehicleEngine.Stop();
            Console.WriteLine($"{Brand} {Model} зупинено");
        }

        public virtual void Move(double distance)
        {
            if (VehicleEngine.IsRunning())
            {
                _mileage += distance;
                TripHistory.Add($"{DateTime.Now.ToShortDateString()}: {distance} км");
                Console.WriteLine($"  Подолано {distance} км. Загальний пробіг: {_mileage} км");
            }
            else
            {
                Console.WriteLine("  Двигун не запущено!");
            }
        }

        public void Accelerate(double speed)
        {
            _currentSpeed += speed;
            CheckMaxSpeed();
            Console.WriteLine($"  Швидкість: {_currentSpeed} км/год");
        }

        private void CheckMaxSpeed()
        {
            if (_currentSpeed > GetMaxSpeed())
            {
                _currentSpeed = GetMaxSpeed();
                Console.WriteLine($"  Досягнуто максимальну швидкість!");
            }
        }

        public double GetMileage() => _mileage;

        public void ShowTripHistory()
        {
            Console.WriteLine($"\nІсторія поїздок ({TripHistory.Count}):");
            foreach (var trip in TripHistory)
                Console.WriteLine($"  - {trip}");
        }

        // Абстрактні методи
        public abstract double GetMaxSpeed();
        public abstract void DisplayInfo();
    }

    public class Car : Vehicle
    {
        public string BodyType { get; set; }
        
        // Список пасажирів (колекція об'єктів)
        public List<string> Passengers { get; set; }
        private int _maxPassengers;

        public Car(string brand, string model, int year, string color, Engine engine, 
                   string bodyType, int maxPassengers)
            : base(brand, model, year, color, engine)
        {
            BodyType = bodyType;
            _maxPassengers = maxPassengers;
            Passengers = new List<string>();
        }

        // Перевантаження методів базового класу
        public override void Start()
        {
            Console.WriteLine("  Перевірка систем безпеки...");
            base.Start();
        }

        public override void Stop()
        {
            base.Stop();
        }

        public override void Move(double distance)
        {
            Console.WriteLine("  Рух по дорозі...");
            base.Move(distance);
        }

        public void AddPassenger(string name)
        {
            if (Passengers.Count < _maxPassengers)
            {
                Passengers.Add(name);
                Console.WriteLine($"  Додано пасажира {name}. Всього: {Passengers.Count}/{_maxPassengers}");
            }
            else
            {
                Console.WriteLine($"  Неможливо додати. Максимум пасажирів: {_maxPassengers}");
            }
        }

        public override double GetMaxSpeed() => 220.0;

        public override void DisplayInfo()
        {
            Console.WriteLine($"\n--- АВТОМОБІЛЬ ---");
            Console.WriteLine($"Марка: {Brand} {Model}");
            Console.WriteLine($"Рік: {Year}, Колір: {Color}");
            Console.WriteLine($"Тип кузова: {BodyType}");
            Console.WriteLine($"Двигун: {VehicleEngine}");
            Console.WriteLine($"Пробіг: {GetMileage()} км");
            Console.WriteLine($"Макс. швидкість: {GetMaxSpeed()} км/год");
            Console.WriteLine($"Пасажири: {string.Join(", ", Passengers)}");
        }
    }

    public class Motorcycle : Vehicle
    {
        public string MotorcycleType { get; set; }
        
        private string[] _requiredGear;

        public Motorcycle(string brand, string model, int year, string color, Engine engine, 
                          string motorcycleType)
            : base(brand, model, year, color, engine)
        {
            MotorcycleType = motorcycleType;
            _requiredGear = new string[] { "Шолом", "Рукавички" };
        }

        public override void Start()
        {
            CheckGear();
            base.Start();
        }

        public override void Stop()
        {
            Console.WriteLine("  Опускання підніжки...");
            base.Stop();
        }

        public override void Move(double distance)
        {
            Console.WriteLine("  Маневрування між автомобілями...");
            base.Move(distance);
        }

        private void CheckGear()
        {
            Console.Write("  Перевірка обладнання: ");
            Console.WriteLine(string.Join(", ", _requiredGear));
        }

        public void PerformTrick()
        {
            if (VehicleEngine.IsRunning())
                Console.WriteLine("  Виконано трюк - wheelie!");
            else
                Console.WriteLine("  Неможливо виконати трюк");
        }

        public override double GetMaxSpeed() => 280.0;

        public override void DisplayInfo()
        {
            Console.WriteLine($"\n--- МОТОЦИКЛ ---");
            Console.WriteLine($"Марка: {Brand} {Model}");
            Console.WriteLine($"Рік: {Year}, Колір: {Color}");
            Console.WriteLine($"Тип: {MotorcycleType}");
            Console.WriteLine($"Двигун: {VehicleEngine}");
            Console.WriteLine($"Пробіг: {GetMileage()} км");
            Console.WriteLine($"Макс. швидкість: {GetMaxSpeed()} км/год");
            Console.WriteLine($"Необхідне обладнання: {string.Join(", ", _requiredGear)}");
        }
    }

    // Клас Вантажівка
    public class Truck : Vehicle
    {
        public double LoadCapacity { get; set; }
        
        public List<string> Cargo { get; set; }
        private double _currentLoad;

        public Truck(string brand, string model, int year, string color, Engine engine, 
                     double loadCapacity)
            : base(brand, model, year, color, engine)
        {
            LoadCapacity = loadCapacity;
            Cargo = new List<string>();
            _currentLoad = 0;
        }

        // Перевантаження методів базового класу
        public override void Start()
        {
            base.Start();
        }

        public override void Stop()
        {
            
            Console.WriteLine("  Двигун трака зупинено");
            base.Stop();
        }

        public override void Move(double distance)
        {
            Console.WriteLine($"  Перевезення {_currentLoad} т вантажу...");
            base.Move(distance);
        }

        public void LoadCargo(string item, double weight)
        {
            if (_currentLoad + weight <= LoadCapacity)
            {
                Cargo.Add($"{item} ({weight}т)");
                _currentLoad += weight;
                Console.WriteLine($"  Завантажено: {item} ({weight}т). Всього: {_currentLoad}т");
            }
            else
            {
                Console.WriteLine($"  Перевищено вантажопідйомність!");
            }
        }

        public double GetCurrentLoad() => _currentLoad;

        public override double GetMaxSpeed() => 120.0;

        public override void DisplayInfo()
        {
            Console.WriteLine($"\n--- ВАНТАЖІВКА ---");
            Console.WriteLine($"Марка: {Brand} {Model}");
            Console.WriteLine($"Рік: {Year}, Колір: {Color}");
            Console.WriteLine($"Вантажопідйомність: {LoadCapacity} т");
            Console.WriteLine($"Двигун: {VehicleEngine}");
            Console.WriteLine($"Пробіг: {GetMileage()} км");
            Console.WriteLine($"Макс. швидкість: {GetMaxSpeed()} км/год");
            Console.WriteLine($"Поточне навантаження: {_currentLoad}т");
            Console.WriteLine($"Вантажі: {string.Join(", ", Cargo)}");
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Console.OutputEncoding = System.Text.Encoding.UTF8;

            Engine carEngine = new Engine("Бензиновий V6", 280);
            Engine motoEngine = new Engine("Бензиновий 4-цил", 150);
            Engine truckEngine = new Engine("Дизельний V8", 450);

            Car car = new Car("Toyota", "Camry", 2022, "Чорний", carEngine, "Седан", 5);
            Motorcycle moto = new Motorcycle("Harley-Davidson", "Street 750", 2021, 
                                              "Червоний", motoEngine, "Круїзер");
            Truck truck = new Truck("Volvo", "FH16", 2023, "Білий", truckEngine, 25.0);

            Console.WriteLine("\n*** АВТОМОБІЛЬ ***\n");
            car.AddPassenger("Іван");
            car.AddPassenger("Марія");
            car.AddPassenger("Олег");
            
            car.Start();
            car.Move(50);
            car.Accelerate(60);
            car.Accelerate(80);
            car.Move(30);
            car.Stop();

            Console.WriteLine("\n\n*** МОТОЦИКЛ ***\n");
            moto.Start();
            moto.Move(25);
            moto.Accelerate(100);
            moto.PerformTrick();
            moto.Move(40);
            moto.Stop();

            Console.WriteLine("\n\n*** ВАНТАЖІВКА ***\n");
            truck.LoadCargo("Будівельні матеріали", 8.5);
            truck.LoadCargo("Обладнання", 6.2);
            truck.LoadCargo("Меблі", 4.3);
            
            truck.Start();
            truck.Move(100);
            truck.Accelerate(80);
            truck.Move(50);
            truck.Stop();

            
            // Поліморфізм
            Vehicle[] vehicles = new Vehicle[] { car, moto, truck };
            
            foreach (Vehicle vehicle in vehicles)
            {
                Console.WriteLine($"{vehicle.Brand} {vehicle.Model}:");
                Console.WriteLine($"  Макс. швидкість: {vehicle.GetMaxSpeed()} км/год");
                Console.WriteLine($"  Пробіг: {vehicle.GetMileage()} км");
                Console.WriteLine($"  Поїздок: {vehicle.TripHistory.Count}");
            }

            Console.WriteLine("\n\n*** Інформація про транспортні засоби ***");
            car.DisplayInfo();
            moto.DisplayInfo();
            truck.DisplayInfo();


            Console.WriteLine("Натисніть будь-яку клавішу для виходу...");
            Console.ReadKey();
        }
    }
}
