//
//  SharedIssuesTableViewController.swift
//  Ray
//
//  Created by Phoebe Heath-Brown on 15/03/2019.
//  Copyright © 2019 Laureen Schausberger. All rights reserved.
//

import UIKit

class SharedIssuesTableViewController: UITableViewController,  UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate  {

    @IBOutlet weak var buildingSearchField: UITextField!
    private let reuseIdentifier = "issueCell"
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    @IBOutlet var tableview: UITableView!

    private(set) var user: User?
    var Issue = Shared()
    var allIssues = [""]
    var allBuildingIssues = [""]
    var sharedIssue : [Shared] = []
    func issueForIndex(_ index: Int) -> Shared? {
        return sharedIssue[index]
    }
    var buildingAutoCompletionPossibilities = [""] // array for database building info
    var autoCompleteCharacterCount = 0
    var timer = Timer() //for checking autocomplete possibilities update
    var autoCompleteResult = ""
    var buildingSearch: String = ""{
        didSet{
            print(buildingSearch)
            getData()
        }
    }
    
    var titleText: String?
    var locationText: String?
    var dateText: String?
    var monthText: String?
    var descriptionText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        spinner.color = .princetonOrange
        spinner.startAnimating()
        tableView.backgroundView = spinner
        
        user = DataHandler.shared.user
        getUserInfo()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        buildingSearchField.inputView =  pickerView
        getBuildingNames()
        
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        doneBtn.tintColor = .princetonOrange
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        self.buildingSearchField.inputAccessoryView = toolbar
    }
    
    func getUserInfo(){
        DataHandler.shared.fetchUserInformation() { success, _ in
            if success {
                self.spinner.stopAnimating()
                self.buildingSearch = self.user?.savedLocations?[0].building ?? ""
                self.buildingSearchField.text = self.buildingSearch
            }
        }
    }
    @objc func doneButtonAction() {
        self.buildingSearchField.endEditing(true)
    }
    
    
    func getData(){
        sharedIssue.removeAll()
        self.spinner.startAnimating()
        DataHandler.shared.fetchReportedIssues() { success, issues in
            if success {
                self.allIssues = issues
                for issue in self.allIssues {
                    DataHandler.shared.fetchReportedBuildingIssue(issueId: issue, buildingName: self.buildingSearch) { success, issues in
                        if success {
                            self.allBuildingIssues = issues
                            for issue in self.allBuildingIssues {
                                DataHandler.shared.fetchReportedIssue(issueId: issue){ success, sharedIssues in
                                    if success {
                                        if sharedIssues != nil{
                                            self.Issue = sharedIssues!
                                            self.sharedIssue.append(self.Issue)
                                            self.tableview.reloadData()
                                            self.spinner.stopAnimating()
                                            self.buildingSearchField.endEditing(true)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // set navigationbar layout, because otherwise childVC would override it
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.shouldRemoveShadow(false)
        self.navigationController?.navigationBar.tintColor = .princetonOrange
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sharedIssue.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SharedIssueTableViewCell else {
            print("SharedIssueTableViewController > CellType doesn't match.")
            return tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        }
        
        if let report = issueForIndex(indexPath.row) {
            cell.sharedIssue = report
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get Cell Label
        let indexPath = tableView.indexPathForSelectedRow!
        let currentCell = tableView.cellForRow(at: indexPath)! as! SharedIssueTableViewCell

        titleText = currentCell.titleLabel.text
        locationText = currentCell.locationText
        dateText = currentCell.dayLabel.text
        monthText = currentCell.monthLabel.text
        descriptionText = currentCell.descriptionText
        
        performSegue(withIdentifier: "sharedIssue", sender: self)
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "sharedIssue") {
            
            let vc = segue.destination as? SharedIssueDetailViewController
            vc?.date = dateText
            vc?.month = monthText
            vc?.titleText = titleText
            vc?.descriptionText = descriptionText
            vc?.location = locationText
        }
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
        buildingSearch = buildingSearchField.text!
    }

}
