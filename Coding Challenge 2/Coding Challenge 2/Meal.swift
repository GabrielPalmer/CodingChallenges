//
//  Meal.swift
//  Coding Challenge 2
//
//  Created by Gabriel Blaine Palmer on 5/16/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import Foundation

class Meal: Codable {
    
    static var savedMeals: [Meal]  {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mealsArchiveURL = documentsDirectory.appendingPathComponent("meals").appendingPathExtension("plist")
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedMealsData = try? Data(contentsOf: mealsArchiveURL), let decodedMeals = try? propertyListDecoder.decode(Array<Meal>.self, from: retrievedMealsData) {
            return decodedMeals
        } else {
            return []
        }
    }
    
    static func saveMeals(_ meals: [Meal]) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let mealsArchiveURL = documentsDirectory.appendingPathComponent("meals").appendingPathExtension("plist")
        let propertyListEncoder = PropertyListEncoder()
        
        let encodedMeals = try? propertyListEncoder.encode(meals)
        try? encodedMeals?.write(to: mealsArchiveURL, options: .noFileProtection)
    }
    
    var name: String
    var calories: Int
    var date: Date
    var rating: Int
    
    init(name: String, calories: Int, date: Date, rating: Int) {
        self.name = name
        self.calories = calories
        self.date = date
        self.rating = rating
    }
    
}
