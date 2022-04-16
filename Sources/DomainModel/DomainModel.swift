import CoreFoundation
struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    func convert(_ currency : String) -> Money{
        var temp : Money = self
        if self.currency != "USD" {
            temp = toUS(from: self.currency)
        }
        if currency != "USD" {
            temp = fromUS(to: currency)
        }
        return temp
    }
    
    func toUS(from : String) -> Money {
        if from == "GBP" {
            return Money(amount: self.amount * 2, currency : "USD")
        }
        if from == "EUR" {
            return Money(amount: Int(Double(self.amount) * (2/3)), currency : "USD")
        }
        else { //"CAN"
            return Money(amount: Int(Double(self.amount) * (4/5)), currency : "USD")
        }
    }
    
    func fromUS(to : String) -> Money {
        if to == "GBP" {
            return Money(amount: self.amount / 2, currency : "GBP")
        }
        if to == "EUR" {
            return Money(amount: Int(Double(self.amount) * (3/2)), currency : "EUR")
        }
        else { //"CAN"
            return Money(amount: Int(Double(self.amount) * (5/4)), currency : "CAN")
        }
    }
    
    func add(_ money : Money) -> Money{
        if self.currency == money.currency {
            return Money(amount : self.amount + money.amount, currency : self.currency)
        }
        let temp : Money = self.convert(money.currency)
        return Money(amount : money.amount + temp.amount, currency : money.currency)
    }
    
    func subtract(_ money : Money) -> Money{
        if self.currency == money.currency {
            return Money(amount : self.amount - money.amount, currency : self.currency)
        }
        let temp : Money = money.convert(self.currency)
        return Money(amount : self.amount - temp.amount, currency : self.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title : String
    var type : JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    func calculateIncome(_ time : Int) -> Int {
        switch type {
        case .Hourly(let income):
            return Int(income * Double(time))
        case .Salary(let income):
            return Int(income)
        }
    }
    
    func raise(byAmount : Double) {
        switch type {
        case .Hourly(let income):
            type = JobType.Hourly(income + byAmount)
        case .Salary(let income):
            type = JobType.Salary(income + UInt(byAmount))
        }
    }
    
    func raise(byPercent : Double) {
        switch type {
        case .Hourly(let income):
            type = JobType.Hourly(income + (income * byPercent))
        case .Salary(let income):
            type = JobType.Salary(income + UInt(Double(income) * byPercent))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName : String
    let lastName : String
    let age : Int
    private var myJob : Job?
    var job : Job? {
        get {
            return myJob
        }
        set (newJob) {
            if (age >= 16) {
                myJob = newJob
            }
        }
    }
    private var mySpouse : Person?
    var spouse : Person? {
        get {
            return mySpouse
        }
        set (newSpouse) {
            if (age >= 18) {
                mySpouse = newSpouse
            }
        }
    }
    
    init(firstName : String, lastName : String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse = nil
    }
    
    func toString() -> String {
        var temp : String = "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:"
        if job == nil {
            temp = temp + "nil spouse:"
        } else {
            temp = temp + "\(job!.title) spouse:"
        }
        if job == nil {
            temp = temp + "nil]"
        } else {
            temp = temp + "\(spouse!.firstName) + \(spouse!.lastName)]"
        }
        return temp
    }
}

////////////////////////////////////
// Family
//
public class Family {
    
    let spouse1 : Person?
    let spouse2 : Person?
    var children : [Person]
    
    init(spouse1 : Person, spouse2 : Person) {
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.spouse1 = spouse1
            self.spouse2 = spouse2
        } else {
            self.spouse1 = nil
            self.spouse2 = nil
        }
        children = []
    }
    
    func haveChild(_ child : Person) -> Bool {
        if (spouse1!.age > 21 || spouse2!.age > 21) {
            children.append(child)
            return true
        }
        return false
    }
    
    func householdIncome() -> Int {
        var total : Int = 0
        if spouse1!.job != nil {
            total = total + spouse1!.job!.calculateIncome(2000)
        }
        if spouse2!.job != nil {
            total = total + spouse2!.job!.calculateIncome(2000)
        }
        for child in children {
            if child.job != nil {
                total = total + child.job!.calculateIncome(2000)
            }
        }
        return total
    }
     
}
