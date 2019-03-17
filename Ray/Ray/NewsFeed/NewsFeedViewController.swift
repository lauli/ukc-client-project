//
//  NewsFeedViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var buildingSearchField: UITextField!

    var buildingAutoCompletionPossibilities = [""] // array for database building info
    var autoCompleteCharacterCount = 0
    var timer = Timer() //for checking autocomplete possibilities update
    var autoCompleteResult = ""
    
    var issueTable: SharedIssuesTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        buildingSearchField.inputView =  pickerView
        getBuildingNames()
    }
    
    //Get building names from firebase for autocomplete
    func getBuildingNames(){
        buildingAutoCompletionPossibilities = [""]
        buildingSearchField.text = ""
        
        DataHandler.shared.buildings() { success, buildings in
            if success {
                self.buildingAutoCompletionPossibilities = buildings
                self.buildingAutoCompletionPossibilities.sort()
            }
        }
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return buildingAutoCompletionPossibilities.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return buildingAutoCompletionPossibilities[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        buildingSearchField.text = buildingAutoCompletionPossibilities[row]
        issueTable!.buildingSearch = buildingAutoCompletionPossibilities[row]
        issueTable!.getData()
    }

}
