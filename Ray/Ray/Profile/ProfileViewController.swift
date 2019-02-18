//
//  ProfileViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class ProfileViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {
  
    @IBOutlet weak var buildingTextField: UITextField!
    @IBOutlet weak var floorTextField: UITextField!
    @IBOutlet weak var roomTextField: UITextField!
    
    var buildingAutoCompletionPossibilities = [""] // array for database building info
    var autoCompleteCharacterCount = 0
    var floorAutoCompletionPossibilities = [""] // array for database floor info
    var roomsAutoCompletionPossibilities = [""] // array for database room info
    var timer = Timer() //for checking autocomplete possibilities update
    var buildingResult = ""
    var floorResult = ""
    var ref: DatabaseReference!
    var buildingEntered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        getBuildingNames()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        floorTextField.inputView = pickerView
    }
    
    //Get building names from firebase for autocomplete
    func getBuildingNames(){
        ref.child("University Of Kent").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get databse values
            let info = snapshot.value as? NSDictionary
            // Get all building names
            self.buildingAutoCompletionPossibilities = info?.allKeys as! [String]
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Get building floors from firebase for autocomplete
    func getBuildingFloors(){
        ref.child("University Of Kent").child(buildingResult).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get databse values
            let info = snapshot.value as? NSDictionary
            // Get all building names
            self.floorAutoCompletionPossibilities = info?.allKeys as! [String]
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //Get building rooms from firebase for autocomplete
    func getFloorRooms(){
        ref.child("University Of Kent").child(buildingResult).child(floorResult).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get databse values
            let info = snapshot.value as? NSDictionary
            // Get all building names
            self.roomsAutoCompletionPossibilities = info?.allKeys as! [String]
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //searches for autocompletes with substring entered
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 { //when a user clears the textField
            resetValues()
        } else {
            searchAutocompleteEntriesWIthSubstring(substring: subString)
        }
        return true
    }
    
    
    //Formats entered text
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }
    
    //Clears text field
    func resetValues() {
        autoCompleteCharacterCount = 0
        if buildingEntered == true {
            roomTextField.text = ""
        }
        else {
        buildingTextField.text = ""
        }
    }

    //gets suggestions and displays to user, updating every 0.01
    func searchAutocompleteEntriesWIthSubstring(substring: String) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(userText: substring)
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(autocompleteResult: autocompleteResult, userQuery : userQuery)
                self.moveCaretToEndOfUserQueryPosition(userQuery: userQuery)
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                //self.buildingTextField.text = substring
                if self.buildingEntered == true {
                    self.roomTextField.text = substring
                }
                else{
                    self.buildingTextField.text = substring
                }
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    //itterates though possibilities and appends to possible matches
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        if buildingEntered == true{
        for item in buildingAutoCompletionPossibilities {
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        }
        else {
            for item in roomsAutoCompletionPossibilities {
                let myString:NSString! = item as NSString
                let substringRange :NSRange! = myString.range(of: userText)
                
                if (substringRange.location == 0)
                {
                    possibleMatches.append(item)
                }
            }
        }
        return possibleMatches
    }
    
    //displays suggetion and formats
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        if buildingEntered == true{
            self.floorTextField.attributedText = colouredString
        }
        else {
            self.buildingTextField.attributedText = colouredString
        }
    }
    
    //moves typing indicator to end of inputted information
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if buildingEntered == true{
        if let newPosition = self.floorTextField.position(from: self.floorTextField.beginningOfDocument, offset: userQuery.count) {
            self.floorTextField.selectedTextRange = self.floorTextField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = floorTextField.selectedTextRange
        floorTextField.offset(from: floorTextField.beginningOfDocument, to: (selectedRange?.start)!)
        }
        else {
            if let newPosition = self.buildingTextField.position(from: self.buildingTextField.beginningOfDocument, offset: userQuery.count) {
                self.buildingTextField.selectedTextRange = self.buildingTextField.textRange(from: newPosition, to: newPosition)
            }
            let selectedRange: UITextRange? = buildingTextField.selectedTextRange
            buildingTextField.offset(from: buildingTextField.beginningOfDocument, to: (selectedRange?.start)!)
        }
    }
    
    //combines substring with suggestion
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        if buildingEntered == true{
            floorResult = possibleMatches[0]
        }
        else{
        buildingResult = possibleMatches[0]
        }
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    //if user presses enter key, suggestion is selected
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.textColor = UIColor.black
        if buildingEntered == true {
        moveCaretToEndOfUserQueryPosition(userQuery: floorResult)
        print(floorResult)
        }
        else{
            moveCaretToEndOfUserQueryPosition(userQuery: buildingResult)
            print(buildingResult)
            buildingEntered = true
            getBuildingFloors()
        }
        return true
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return floorAutoCompletionPossibilities.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return floorAutoCompletionPossibilities[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        floorTextField.text = floorAutoCompletionPossibilities[row]
        floorResult = floorTextField.text ?? ""
        getFloorRooms()
    }
}
