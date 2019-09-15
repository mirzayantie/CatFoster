//
//  ViewController.swift
//  food-tracker
//
//  Created by PPAS RATU ONE on 02/03/2019.
//  Copyright © 2019 Lightgearlab. All rights reserved.
//

import UIKit
import os.log
import Firebase

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mealName: UITextField!
    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var ratingControl: RatingControl!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var meal: Meal?
    var currentid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mealName.delegate = self
        
        //Set up views if editing an existing Meal
        if let meal = meal {
            navigationItem.title = meal.name
            mealName.text = meal.name
            mealImage.image = meal.photo
            ratingControl.rating = meal.rating
            currentid = meal.id
        }
        
        //Enable the save button only if the text field has a valid meal name
        updateSaveButtonState()
        
    }
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMealMode = presentedViewController is UINavigationController
        if isPresentingInAddMealMode {
            //from Add Meal Page
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            //from Edit Meal Page
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling...", log: OSLog.default, type: .debug)
            return
        }
        
        let name = mealName.text ?? ""
        let photo = mealImage.image
        let rating = ratingControl.rating
        
        meal = Meal(id: currentid,name: name, photo: photo, rating: rating)
        
        //access firebase database
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let mealsRef = ref.child("cat")
        let storageRef = Storage.storage().reference()
        
        //create data
        var dict = [String: Any]()
        dict.updateValue(name, forKey: "name")
        dict.updateValue("photo\(name)", forKey: "photo")
        dict.updateValue(rating, forKey: "rating")
        mealsRef.childByAutoId().setValue(dict)
    }
    //MARK: ACTION
    
    @IBAction func selectImagefromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //hide keyboard
        mealName.resignFirstResponder()
        
        let imgPickerController = UIImagePickerController()
        
        imgPickerController.sourceType = .photoLibrary
        
        imgPickerController.delegate = self
        present(imgPickerController, animated: true, completion: nil)
    }
    //MARK: imagePickerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        mealImage.image = selectedImage
        
        dismiss(animated: true, completion: nil)
        
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        mealName.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Disable the button when editing
        saveButton.isEnabled = false
    }
    //MARK: Private Methods
    private func updateSaveButtonState(){
        //Disable the Save button if the text field is empty
        let text = mealName.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}

