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
