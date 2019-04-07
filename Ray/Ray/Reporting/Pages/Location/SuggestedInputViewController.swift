//
//  SuggestedInputViewController.swift
//  Ray
//
//  Creat/Users/ksb36/ukc-client-project/Ray/Ray/Profile/ProfileViewController.swifted by Kirsty Samantha Butler on 26/02/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import Firebase

class SuggestedInputViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {
    
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
    var roomResult = ""
    var autoCompleteResult = ""
    var ref: DatabaseReference!
    var possibleMatches: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        floorTextField.inputView = pickerView
        
        getBuildingNames()
    }
    
    func cleanTextfields() {
        buildingTextField.text = ""
        floorTextField.text = ""
        roomTextField.text = ""
    }
    
    //Get building names from firebase for autocomplete
    func getBuildingNames(){
        buildingAutoCompletionPossibilities = [""]
        floorAutoCompletionPossibilities = [""]
        roomsAutoCompletionPossibilities = [""]
        floorResult = ""
        roomResult = ""
        buildingResult = ""
        buildingTextField.text = ""
        roomTextField.text = ""
        floorTextField.text = ""
        possibleMatches = []
        
        DataHandler.shared.buildings() { success, buildings in
            if success {
                self.buildingAutoCompletionPossibilities = buildings
                self.buildingAutoCompletionPossibilities.sort()
            }
        }
    }
    
    //Get building floors from firebase for autocomplete
    func getBuildingFloors(completion: @escaping Success){
        floorAutoCompletionPossibilities = [""]
        roomsAutoCompletionPossibilities = [""]
        floorResult = ""
        roomResult = ""
        roomTextField.text = ""
        floorTextField.text = ""
        possibleMatches = []
        
        DataHandler.shared.floorsFor(building: buildingTextField.text ?? ""){ success, floors in
            if success {
                self.floorAutoCompletionPossibilities = floors
                self.floorAutoCompletionPossibilities.sort()
            }
            completion(success)
        }
    }
    
    //Get building rooms from firebase for autocomplete
    func getFloorRooms(){
        roomsAutoCompletionPossibilities = [""]
        roomResult = ""
        roomTextField.text = ""
        possibleMatches = []
        
        DataHandler.shared.roomsFor(building: buildingTextField.text ?? "", floor: floorTextField.text?.uppercased() ?? "") { success, rooms in
            if success {
                self.roomsAutoCompletionPossibilities = rooms
                self.roomsAutoCompletionPossibilities.sort()
            }
        }
    }
    
    //searches for autocompletes with substring entered
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var subString = (textField.text!.capitalized as NSString).replacingCharacters(in: range, with: string)
        subString = formatSubstring(subString: subString)
        
        if subString.count == 0 { //when a user clears the textField
            resetValues(textField: textField)
        } else {
            searchAutocompleteEntriesWIthSubstring(substring: subString, textField: textField)
        }
        return true
    }
    
    
    //Formats entered text
    func formatSubstring(subString: String) -> String {
        let formatted = String(subString.dropLast(autoCompleteCharacterCount)).lowercased().capitalized
        return formatted
    }
    
    //Clears text field
    func resetValues(textField: UITextField) {
        autoCompleteCharacterCount = 0
        if textField == roomTextField {
            getFloorRooms()
        }
        else if textField == buildingTextField{
            getBuildingNames()
        }
    }
    
    //gets suggestions and displays to user, updating every 0.01
    func searchAutocompleteEntriesWIthSubstring(substring: String, textField: UITextField) {
        let userQuery = substring
        let suggestions = getAutocompleteSuggestions(textField: textField, userText: substring)
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                let autocompleteResult = self.formatAutocompleteResult(textField: textField, substring: substring, possibleMatches: suggestions)
                self.putColourFormattedTextInTextField(textField: textField, autocompleteResult: autocompleteResult, userQuery : userQuery)
                self.moveCaretToEndOfUserQueryPosition(textField: textField, userQuery: userQuery)
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                if textField == self.roomTextField {
                    self.roomTextField.text = substring
                }
                else if textField == self.buildingTextField {
                    self.buildingTextField.text = substring
                }
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    //itterates though possibilities and appends to possible matches
    func getAutocompleteSuggestions(textField: UITextField, userText: String) -> [String]{
        if textField == self.roomTextField {
            possibleMatches = []
            for item in roomsAutoCompletionPossibilities {
                let myString:NSString! = item as NSString
                let substringRange :NSRange! = myString.range(of: userText)
                if (substringRange.location == 0)
                {
                    possibleMatches.append(item)
                    roomResult = possibleMatches[0]
                }
            }
            
        }
        else if textField == self.buildingTextField{
            possibleMatches = []
            for item in buildingAutoCompletionPossibilities {
                let myString:NSString! = item as NSString
                let substringRange :NSRange! = myString.range(of: userText)
                
                if (substringRange.location == 0)
                {
                    possibleMatches.append(item)
                    buildingResult = possibleMatches[0]
                }
            }
            
        }
        
        return possibleMatches
    }
    
    //displays suggetion and formats
    func putColourFormattedTextInTextField(textField: UITextField, autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        if textField == self.roomTextField {
            self.roomTextField.attributedText = colouredString
        }
        else if textField == self.buildingTextField {
            self.buildingTextField.attributedText = colouredString
        }
    }
    
    //moves typing indicator to end of inputted information
    func moveCaretToEndOfUserQueryPosition(textField: UITextField, userQuery : String) {
        if textField == self.roomTextField {
            if let newPosition = self.roomTextField.position(from: self.roomTextField.beginningOfDocument, offset: userQuery.count) {
                self.roomTextField.selectedTextRange = self.roomTextField.textRange(from: newPosition, to: newPosition)
            }
            let selectedRange: UITextRange? = roomTextField.selectedTextRange
            roomTextField.offset(from: roomTextField.beginningOfDocument, to: (selectedRange?.start)!)
        }
        else if textField == self.buildingTextField {
            if let newPosition = self.buildingTextField.position(from: self.buildingTextField.beginningOfDocument, offset: userQuery.count) {
                self.buildingTextField.selectedTextRange = self.buildingTextField.textRange(from: newPosition, to: newPosition)
            }
            let selectedRange: UITextRange? = buildingTextField.selectedTextRange
            buildingTextField.offset(from: buildingTextField.beginningOfDocument, to: (selectedRange?.start)!)
        }
    }
    
    //combines substring with suggestion
    func formatAutocompleteResult(textField: UITextField, substring: String, possibleMatches: [String]) -> String {
        //var autoCompleteResult = possibleMatches[0]
        if textField == self.roomTextField {
            autoCompleteResult = roomResult
        }
        else if textField == self.buildingTextField {
            autoCompleteResult = buildingResult
        }
        
        if substring.count < autoCompleteResult.count{
            autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        }
        
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    //if user presses enter key, suggestion is selected
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.textColor = UIColor.black
        if textField == roomTextField {
            moveCaretToEndOfUserQueryPosition(textField: textField, userQuery: roomResult)
        }
        else if textField == buildingTextField {
            moveCaretToEndOfUserQueryPosition(textField: textField, userQuery: buildingResult)
            if buildingTextField.text == possibleMatches[0]{
                getBuildingFloors() { success in
                    if success {
                        self.floorTextField.reloadInputViews()
                    }
                }
            }
            else {
                
                let alert = UIAlertController(title: "Alert", message: "Location does not exist, please check spelling and re-enter", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                        
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            
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
    
    func savedLocation() -> Location? {
        guard let building = buildingTextField.text, building != "",
            let floor = floorTextField.text, floor != "",
            let room = roomTextField.text, room != "" else {
                return nil
        }
        
        return Location(building: building, floor: floor, room: room)
    }
}
