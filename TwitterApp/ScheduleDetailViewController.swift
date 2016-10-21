//
//  DetailTableViewController.swift
//  TwitterApp
//
//  Created by Jake SWEDENBURG on 10/7/16.
//  Copyright © 2016 Jake Swedenbug. All rights reserved.
//

import UIKit

class ScheduleDetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,  searchDelegate, UITextFieldDelegate {
    
   
    @IBOutlet weak var accountCollectionView: UICollectionView!
    
    @IBOutlet weak var toolBar: UIToolbar!
   
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var titleTextField: UITextField!
    
   
    var schedule: Schedule?
    
    var accountArray: [TwitterAccount] = []
    
    override func viewDidLoad() {
       
        TwitterSearchTableViewController.delegate = self
        titleTextField.delegate = self
        self.navigationController?.setToolbarHidden(true, animated: true)
        setUpAccountArray()
        setupView()
        setUpFlow()
        self.accountCollectionView.allowsSelection = false
        self.toolBar.isHidden = true
        
        
        
        
        
    }
    
    func setUpFlow() {
        let flow = UICollectionViewFlowLayout()
        //flow.estimatedItemSize = CGSize(width: 110, height: 127)
        let width = self.view.frame.width / 3
        let height = self.view.frame.height / 5
        flow.itemSize = CGSize(width: width - 3, height: height + 4)
        flow.minimumLineSpacing = 1
        flow.minimumInteritemSpacing = 1
        flow.sectionInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        
        
        self.accountCollectionView.collectionViewLayout = flow
    }
    
    
    
    //MARK: Text Field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: AnyObject) {
        guard let text = titleTextField.text, text.characters.count > 0 else { return }
        if accountArray.count > 0 {
            if let schedule = schedule  {
                
                editSchedule(schedule: schedule)
                
            } else {
                addSchedule()
            }
            self.performSegue(withIdentifier: "unwindToScheduleTable", sender: self)
        }
        
    }
    
    @IBAction func cancelScheduleButtonPressed(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToScheduleTable", sender: self)
    }
    
    func addSchedule() {
        guard let scheduleTitle = titleTextField.text else { return }
        
        
        
        let newSchedule = Schedule(title: scheduleTitle)
        
        
        
        for account in accountArray {
            guard let name = account.name,
                let screenName = account.screenName,
                let imageData = account.profileImage else { return }
            let verified = account.verified
            let newAccount = TwitterAccount(name: name, screenName: screenName, verified: verified, schedule: newSchedule, profileImageData: imageData)
            TwitterAccountController.sharedController.add(newAccount)
        }
        
        
        ScheduleController.sharedController.saveToPersistentStorage()
        
    }
    
    func editSchedule(schedule: Schedule){
        
        guard let scheduleTitle = titleTextField.text else { print("title?")
            return }
        schedule.title = scheduleTitle
        
        schedule.twitterAccounts = []
        
        for account in accountArray {
            guard let name = account.name,
                let screenName = account.screenName,
                let imageData = account.profileImage else { return }
            let verified = account.verified
            let newAccount = TwitterAccount(name: name, screenName: screenName, verified: verified, schedule: schedule, profileImageData: imageData)
            TwitterAccountController.sharedController.add(newAccount)
        }
        
        
        ScheduleController.sharedController.saveToPersistentStorage()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
        self.accountCollectionView.reloadData()
        
        
    }
    
    //MARK: - Collection View Data Source
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accountArray.count
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.accountCollectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath) as? AccountCollectionViewCell else { return UICollectionViewCell()}
        let account = accountArray[indexPath.row]
        cell.updateWithAccount(account: account)
        
        return cell
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.red.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderWidth = 0
        
    }
    
    @IBAction func editButttonPressed(_ sender: AnyObject) {
        
        self.toolBar.isHidden = false
        self.toolBar.isTranslucent = true
        
        
        
        
        accountCollectionView.allowsMultipleSelection = true
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        self.toolBar.isHidden = true
        guard let indexPaths = accountCollectionView.indexPathsForSelectedItems else { return }
        for indexPath in indexPaths {
            let cell = accountCollectionView.cellForItem(at: indexPath)
            cell?.isSelected = false
            cell?.layer.borderWidth = 0
            
            
        }
        accountCollectionView.allowsSelection = false
        
        
    }
    
        
    
    @IBAction func deleteCells(_ sender: AnyObject) {
        guard let indexPaths = accountCollectionView.indexPathsForSelectedItems else { return }
        
        for indexPath in indexPaths {
            let index = indexPath.row
            accountArray.remove(at: index)
            let cell = accountCollectionView.cellForItem(at: indexPath)
            cell?.isSelected = false
            cell?.layer.borderWidth = 0
            
        }
        
        accountCollectionView.deleteItems(at: indexPaths)
        accountCollectionView.allowsSelection = false
        
        self.toolBar.isHidden = true
        
    }
    
    
    
    // MARK: - Table view data source
    
   
    
    //MARK: Helper Functions
    
    
    
    func setupView(){
        
        if let schedule = schedule{
            titleTextField.text = schedule.title
        } else {
            
            titleTextField.placeholder = "Title"
        }
    }
    
    
    
    func setUpAccountArray(){
        if let schedule = schedule, let accounts = schedule.twitterAccounts?.allObjects as? [TwitterAccount] {
            self.accountArray = accounts
        }
    }
    
    
    
    
    
      
    
    
}

