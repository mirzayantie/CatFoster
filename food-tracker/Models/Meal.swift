//
//  Meal.swift
//  food-tracker
//
//  Created by PPAS RATU ONE on 16/03/2019.
//  Copyright © 2019 Lightgearlab. All rights reserved.
//

import Foundation
import UIKit

class Meal {
    
    //MARK: Properties
    var id: String
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: INITIALIZATION
    init?(id: String, name: String, photo: UIImage?, rating: Int){
        
        //Initialization should fail if there is no name or the rating is negative
        if name.isEmpty || rating < 0 {
            return nil
        }
        
        self.id = id
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
}
