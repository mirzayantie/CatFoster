//
//  RatingControl.swift
//  food-tracker
//
//  Created by PPAS RATU ONE on 10/03/2019.
//  Copyright © 2019 Lightgearlab. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet{
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet{
            updateButtonSelectionStates()
        }
    }
    
    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    private func setupButtons(){
        //clear existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        //clear button array
        ratingButtons.removeAll()
        
        //set images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "selected", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "default", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlighted", in: bundle, compatibleWith: self.traitCollection)
        
        
        for _ in 0..<starCount {
            //create button
            let button = UIButton()
            
            //add constaint and size button
            //button.backgroundColor = UIColor.blue
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            //set button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted,.selected])
            
            //link ratingbuttontapped function to touch
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            //add button to stack
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        updateButtonSelectionStates()
    }
    
    //MARK: Action
    @objc func ratingButtonTapped(button: UIButton){
        //handle button selected
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        let selectedRating = index + 1
        if selectedRating == rating {
            //reset rating when 0 rating
            rating = 0
        } else {
            //otherwise set rating to selected rating
            rating = selectedRating
        }
    }
    private func updateButtonSelectionStates(){
        for (index, button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
        }
    }
    
    
    
    
}
