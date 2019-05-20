//
//  MealsTableViewController.swift
//  Coding Challenge 2
//
//  Created by Gabriel Blaine Palmer on 5/16/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

class MealsTableViewController: UITableViewController, MealEditorProtocol {
    
    var meals: [Meal] = []
    var sortedMeals: [[Meal]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meals = Meal.savedMeals
        sortMeals()
    }
    
    func updateMeals(_ meal: Meal?) {
        if let meal = meal {
            meals.append(meal)
            sortMeals()
        }
        
        tableView.reloadData()
        Meal.saveMeals(meals)
    }
    
    func sortMeals() {
        sortedMeals.removeAll()
        
        if meals.count == 0 {
            return
        }
        
        if meals.count == 1 {
            sortedMeals.append([meals[0]])
            return
        }
        
        meals.sort { $0.date > $1.date }
        
        let calendar = Calendar(identifier: .gregorian)
        
        var years: [Int] = []
        var months: [Int] = []
        var days: [Int] = []
        
        for meal in meals {
            years.append(calendar.component(.year, from: meal.date))
            months.append(calendar.component(.month, from: meal.date))
            days.append(calendar.component(.day, from: meal.date))
            
        }
        
        sortedMeals.append([meals[0]])
        var k = 0
        
        for i in 1...meals.count - 1 {
            if years[i] == years[i - 1]
                && months[i] == months[i - 1]
                && days[i] == days[i - 1] {
                
                sortedMeals[k].append(meals[i])
            } else {
                k += 1
                sortedMeals.append([])
                sortedMeals[k].append(meals[i])
            }
        }
    }
    
    //===========================================
    // MARK: - Table View Data Source
    //===========================================
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyy"
        return formatter.string(from: sortedMeals[section][0].date)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortedMeals.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedMeals[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mealCell", for: indexPath) as! MealTableViewCell
        let meal = sortedMeals[indexPath.section][indexPath.row]
        
        cell.nameLabel.text = meal.name
        cell.caloriesLabel.text = "\(meal.calories) Calories"
        cell.ratingLabel.text = String(meal.rating)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "editMeal", sender: nil)
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletedMeal = sortedMeals[indexPath.section].remove(at: indexPath.row)
            
            for index in 0...meals.count - 1 {
                let meal = meals[index]
                if meal === deletedMeal {
                    meals.remove(at: index)
                    break
                }
            }
            
            Meal.saveMeals(meals)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //===========================================
    // MARK: - Navigation
    //===========================================
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "addMeal":
            guard let destination = (segue.destination as? UINavigationController)?.viewControllers.first as? EditorViewController else {
                fatalError("editorViewController in unexpected location in view hierchy")
            }
            
            destination.delegate = self
            destination.navigationItem.title = "New Meal"
        case "editMeal":
            guard let destination = segue.destination as? EditorViewController else {
                fatalError("editorViewController in unexpected location in view hierchy")
            }
            
            guard let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("editMeal segue was not called from a cell")
            }
            
            destination.delegate = self
            destination.meal = sortedMeals[indexPath.section][indexPath.row]
            destination.navigationItem.title = "Edit Meal"
            
        default:
            fatalError("unknown segue identifier")
        }
    }
    
    //===========================================
    // MARK: - Actions
    //===========================================
 
    @IBAction func addButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "addMeal", sender: nil)
    }
    
}

