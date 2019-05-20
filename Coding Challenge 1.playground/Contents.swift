import UIKit

var divisibleByThree = false
var divisibleByFive = false
var divisibleNumbers: [Int] = []

for index in 1...100 {
    
    divisibleByThree = index % 3 == 0
    divisibleByFive = index % 5 == 0
    
    if !divisibleByThree && !divisibleByFive {
        print("\(index): Cannot divide")
    } else if !divisibleByFive {
        print("\(index): Mountainland")
    } else if !divisibleByThree {
        print("\(index): Technical")
    } else {
        divisibleNumbers.append(index)
        print("\(index): Mountainland Technical College")
    }
}

print("\nNumbers divisible by 3 and 5")
print(divisibleNumbers)

//the if statement is ordered by frequency to minimize code run per loop



var things = [3, 5, 7, 2, 5 ,3 ,6 ,7 ,4 ,9 ,6 ,1 ,4]

let yearOffSets = things.enumerated().sorted { $0 > $1 }.map { $0.offset }
yearOffSets.map { things[$0] }

print("")
print(yearOffSets)
print(things)
