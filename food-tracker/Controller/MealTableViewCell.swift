//
//  MealTableViewCell.swift
//  food-tracker
//
//  Created by PPAS RATU ONE on 16/03/2019.
//  Copyright © 2019 Lightgearlab. All rights reserved.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    //MARK: Properties
    @IBOutlet weak var mealLabel: UILabel!
    
    @IBOutlet weak var mealImage: UIImageView!
    
    @IBOutlet weak var mealRating: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
