//
//  EditorViewController.swift
//  Coding Challenge 2
//
//  Created by Gabriel Blaine Palmer on 5/16/19.
//  Copyright © 2019 Gabriel Blaine Palmer. All rights reserved.
//

import UIKit

protocol MealEditorProtocol {
    func updateMeals(_ meal: Meal?)
}

class EditorViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ratingControl: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var delegate: MealEditorProtocol?
    var meal: Meal?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        caloriesTextField.delegate = self
        
        if let meal = meal {
            saveButton.title = "Save"
            nameTextField.text = meal.name
            caloriesTextField.text = String(meal.calories)
            datePicker.setDate(meal.date, animated: false)
            
            ratingControl.selectedSegmentIndex = meal.rating - 1
        } else {
            saveButton.title = "Add"
        }
    }
    
    func dismissView() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text, !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            let alertController = UIAlertController(title: "A name is required", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        guard let caloriesString = caloriesTextField.text, let calories = Int(caloriesString) else {
            let alertController = UIAlertController(title: "An amount of calories is required", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alertController, animated: true)
            return
        }
        
        if let meal = meal {
            meal.name = name
            meal.calories = calories
            meal.date = datePicker.date
            meal.rating = ratingControl.selectedSegmentIndex + 1
        } else {
            let newMeal = Meal(name: name, calories: calories, date: datePicker.date, rating: ratingControl.selectedSegmentIndex + 1)
            meal = newMeal
        }
        
        delegate?.updateMeals(meal)
        dismissView()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismissView()
    }
    
}
