import UIKit

class Car {
    var brand: String
    var model: String
    var year: Int
    var horsePower: Int
    let driver: Driver

    init(_ brand: String,_ model: String,_ year: Int,_ horsePower: Int,_ driver: Driver) {
        self.brand = brand
        self.model = model
        self.year = year
        self.horsePower = horsePower
        self.driver = driver
    }
    
    func getInfo() -> String {
        driver.getInfo() + " This is \(brand) \(model) which was produced in \(year) with \(horsePower) HP"
    }
    
    deinit {
        print("\(brand) \(model) \(year) year was deinitialized")
    }
}

class Driver {
    let name: String
    var rating: Int
    
    init(_ name: String, _ rating: Int) {
        self.name = name
        self.rating = rating
    }
    
    func increaceRating(_ extraPow: Int) -> Bool {
        if rating < 10 {
            rating += extraPow
            if rating > 10 {
                rating = 10
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    func getInfo() -> String {
        "The driver is \(name)."
    }
}


class Mercedes : Car {
    var wasTunned: Bool
    
    init(_ model: String, _ year: Int, _ horsePower: Int, _ driver: Driver) {
        self.wasTunned = false
        super.init("Mercedes", model, year, horsePower, driver)
    }
    
    override func getInfo() -> String {
        let tuningStatus = wasTunned ? " which was tuned" : " which wasn't tuned"
        return super.getInfo() + tuningStatus
    }
    
    func tuning(_ extraPower: Int) {
        self.horsePower += extraPower
        self.wasTunned = true
    }
}

class BMW : Car {
    var wasTunned: Bool
    var stage: Int?
    
    init(_ model: String,_ year: Int,_ horsePower: Int,_ driver: Driver) {
        self.wasTunned = false
        self.stage = nil
        super.init("BMW", model, year, horsePower, driver)
    }
    
    override func getInfo() -> String {
        let tuningStatus = wasTunned ? " which was tuned" : " which wasn't tuned"
        let stageCondition = " and has \(stage ?? 0) stage."
        return super.getInfo() + tuningStatus + stageCondition
    }
    
    func tuning(_ extraPower: Int,_ stage: Int) {
        self.horsePower += extraPower
        self.wasTunned = true
        self.stage = stage
    }
}


class Audi : Car {
    var drive: Int
    
    init(_ model: String,_ year: Int,_ horsePower: Int,_ driver: Driver) {
        if model.hasSuffix("Quadro") {
            self.drive = 4
        } else {
            self.drive = 2
        }
        super.init("Audi", model, year, horsePower, driver)
    }
    
    override func getInfo() -> String {
        let driveCondition = self.drive == 4 ? "four-wheel" : "two-wheel"
        return super.getInfo() + " with \(driveCondition) drive."
    }
}

class Tesla : Car {
    var timeToRecharge: Int

    init(_ model: String,_ year: Int,_ horsePower: Int,_ driver: Driver) {
        switch model {
        case "X": self.timeToRecharge = 4
        case "Y", "S": self.timeToRecharge = 6
        case "CyberTruck": self.timeToRecharge = 7
        default: self.timeToRecharge = Int.random(in: 0...7)
        }
        super.init("Tesla", model, year, horsePower, driver)
    }
    
    func charging() {
        print("Model \(model) is going to recharge")
        for time in 0...self.timeToRecharge {
            print("\(time) / \(self.timeToRecharge) part is charget successfully")
        }
        print("Tesla model \(self.model) is ready!")
    }
    
    override func getInfo() -> String {
        super.getInfo() + " with \(self.timeToRecharge) hours to recharge it"
    }
}


extension Car { // смысл не до конца понял в задаче тк есть конструкторы
    static func createCar(_ brand: String,_ model : String,_ year: Int,_ horsePower: Int,_ driver: Driver) -> Car {
        switch brand{
        case "Mercedes": return Mercedes(model, year, horsePower, driver)
        case "BMW": return BMW(model, year, horsePower, driver)
        case "Audi": return Audi(model, year, horsePower, driver)
        case "Tesla": return Tesla(model, year, horsePower, driver)
        default: return Car(brand, model, year, horsePower, driver)
        }
    }
}


func makeRace<T>(_ auto1: T, _ auto2: T) -> T where T : Car {
    var auto1val = auto1.horsePower * auto1.driver.rating
    var auto2val = auto2.horsePower * auto2.driver.rating
    if auto1val == auto2val {
        var randonNum = Int.random(in: 0...1)
        switch randonNum {
        case 0: auto1.driver.increaceRating(1)
        default: auto2.driver.increaceRating(1)
        }
        return makeRace(auto1, auto2)
    }
    let auto1FullName = "\(auto1.brand)\(auto1.model)"
    let auto2FullName = "\(auto2.brand)\(auto2.model)"
    let message = auto1val > auto2val ? "\(auto1FullName) won race between \(auto2FullName)" : "\(auto2FullName) won race between \(auto1FullName)"
    print(message)
    return message.hasPrefix("\(auto1FullName)") ? auto1 : auto2
}

enum RaceExceptions : Error {
    case NotEnoughRidersException(message: String)
}

func globalRace<T>(_ racers: [T]) throws -> String where T: Car {
    guard racers.count % 2 == 0 else {
        throw RaceExceptions.NotEnoughRidersException(message: "There should be even number of riders")
    }
    var tempRacers = racers
    while tempRacers.count != 1 {
        var index1: Int = Int.random(in: 0..<racers.count)
        var index2: Int = Int.random(in: 0..<racers.count)
        if index1 == index2 {
            continue
        }
        var competitor1 = tempRacers[index1]
        var competitor2 = tempRacers[index2]
        
        tempRacers.remove(at: index1)
        tempRacers.remove(at: index2)
        
        var winner = makeRace(competitor1, competitor2)
        print("\(winner) won the race between \(competitor1) \(competitor2)")
        
        tempRacers.append(winner)
    }
    return "The winner of global race is \(tempRacers)"
}

// Ex 1
var JohnDelmor = Driver("John D", 7)
var carExample = Car("Ferrari", "SF90", 2019, 220, JohnDelmor)

print(carExample.getInfo())
// Ex 2
var DennyRoad = Driver("Denny", 8)
var mercedesMaybach = Mercedes("Maybach", 2023, 503, DennyRoad)
mercedesMaybach.tuning(100)
print(mercedesMaybach.getInfo())

var MickyLee = Driver("Micky", 4)
var bmwStage2 = BMW("320i", 2019, 200, MickyLee)
bmwStage2.tuning(36, 2)
print(bmwStage2.getInfo())

var ReddisonF = Driver("Reddison", 6)
var audi5s = Audi("5S Quadro", 2018, 189, ReddisonF)
print(audi5s.getInfo())


var JullyCameron = Driver("Jully", 8)
var teslaS = Tesla("S", 2022, 300, JullyCameron)
print(teslaS.getInfo())

//Ex 3
var driver = Driver("No-named", 2)
let randomCar = Car.createCar("Mercedes", "E", 2019, 475, driver)
print(type(of: randomCar))

//Ex 4
var winner = makeRace(mercedesMaybach, audi5s)
print(winner)

// Ex 5
var racers = [mercedesMaybach, audi5s, bmwStage2, teslaS]
var globalWinner = try? globalRace(racers)
