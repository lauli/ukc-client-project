//
//  ProfileViewController.swift
//  Ray
//
//  Created by Laureen Schausberger on 31.01.19.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    
    var autoCompletionPossibilities = [""] // array for database building info
    var autoCompleteCharacterCount = 0
    var timer = Timer() //for checking autocomplete possibilities update
    var result = ""
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBuildingNames()
    }
    
    //Get building names from firebase for autocomplete
    func getBuildingNames(){
        ref = Database.database().reference()
        ref.child("University Of Kent").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get databse values
            let info = snapshot.value as? NSDictionary
            // Get all building names
            self.autoCompletionPossibilities = info?.allKeys as! [String]
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
        textField.text = ""
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
                self.textField.text = substring
            })
            autoCompleteCharacterCount = 0
        }
    }
    
    //itterates though possibilities and appends to possible matches
    func getAutocompleteSuggestions(userText: String) -> [String]{
        var possibleMatches: [String] = []
        for item in autoCompletionPossibilities {
            let myString:NSString! = item as NSString
            let substringRange :NSRange! = myString.range(of: userText)
            
            if (substringRange.location == 0)
            {
                possibleMatches.append(item)
            }
        }
        return possibleMatches
    }
    
    //displays suggetion and formats
    func putColourFormattedTextInTextField(autocompleteResult: String, userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + autocompleteResult)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.lightGray, range: NSRange(location: userQuery.count,length:autocompleteResult.count))
        self.textField.attributedText = colouredString
    }
    
    //moves typing indicator to end of inputted information
    func moveCaretToEndOfUserQueryPosition(userQuery : String) {
        if let newPosition = self.textField.position(from: self.textField.beginningOfDocument, offset: userQuery.count) {
            self.textField.selectedTextRange = self.textField.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = textField.selectedTextRange
        textField.offset(from: textField.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    //combines substring with suggestion
    func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autoCompleteResult = possibleMatches[0]
        result = possibleMatches[0]
        autoCompleteResult.removeSubrange(autoCompleteResult.startIndex..<autoCompleteResult.index(autoCompleteResult.startIndex, offsetBy: substring.count))
        autoCompleteCharacterCount = autoCompleteResult.count
        return autoCompleteResult
    }
    
    //if user presses enter key, suggestion is selected
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.textColor = UIColor.black
        moveCaretToEndOfUserQueryPosition(userQuery: result)
        print(result)
        return true
    }
}
