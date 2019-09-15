//
//  MealTableViewController.swift
//  food-tracker
//
//  Created by PPAS RATU ONE on 16/03/2019.
//  Copyright © 2019 Lightgearlab. All rights reserved.
//

import UIKit
import FirebaseDatabase
import os.log

class MealTableViewController: UITableViewController {
    
    //MARK: Properties
    var meals = [Meal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        loadSampleMeals()
    }
    //MARK: Actions
    
    @IBAction func unwind(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MealViewController, let meal = sourceViewController.meal {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                //Update an existing meal
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    //MARK: Private Methods. load from server
    private func loadSampleMeals(){
        //access firebase database
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let mealsRef = ref.child("books")
        //read data
        mealsRef.observe(DataEventType.value, with: { (snapshot) in
            //clear local data
            self.meals = []
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            print("Amount of data from server \(postDict.count)")
            var mealName = ""
            var mealImage = ""
            var mealRating = 0
            for (key, value) in postDict {
                //print("\(key) -> \(value)")
                print(value["name"])
                mealName = value["name"] as! String
                mealImage = value["photo"] as! String
                mealRating = value["rating"] as! Int
                guard let meal = Meal(id: key,name: mealName, photo: UIImage(named: "meal1"), rating: mealRating) else {
                    fatalError("Unable to create meal 1")
                }
                self.meals += [meal]
                print("Amount of data from local \(self.meals.count)")
            }
            //reload local data when get data from server
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        //set identifier
        let cellIdentifier = "MealTableViewCell"
        //create 1 cell with identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("The dequeued cell is not an isntance of MealTableViewCell")
        }
        //create 1 meal from meals array
        let meal = meals[indexPath.row]
        //set cell properties based on meal
        cell.mealLabel.text = meal.name
        cell.mealImage.image = meal.photo
        //cell.mealRating.rating = meal.rating
        
        //return cell to UI
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //reomve data in firebase
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let mealsRef = ref.child("books")
            mealsRef.child(meals[indexPath.row].id).removeValue()
            // Delete the row from the data source
            meals.remove(at: indexPath.row)
            
        
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddItem":
            os_log("Adding a new meal", log: OSLog.default, type: .debug)
        case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("unexpected destination: \(segue.destination)")
            }
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
 

}
