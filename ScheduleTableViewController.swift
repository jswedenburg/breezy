 //
//  ScheduleTableViewController.swift
//  TwitterApp
//
//  Created by Jake SWEDENBURG on 10/6/16.
//  Copyright © 2016 Jake Swedenbug. All rights reserved.
//

import UIKit
 import TwitterKit


class ScheduleTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TableViewCellDelegate {
    
    
   
    
    
    var scheduleArray: [Schedule] {
        return ScheduleController.sharedController.schedules
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var accountArray: [TwitterAccount] = [] {
        didSet{
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
   
    
    
    
    
    @IBAction func logoutButtonPressed(_ sender: AnyObject) {
        let sessionStore = Twitter.sharedInstance().sessionStore
        if let userID = sessionStore.session()?.userID {
            sessionStore.logOutUserID(userID)
        }
        UserDefaults.standard.removeObject(forKey: "userID")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyBoard.instantiateViewController(withIdentifier: "loginVC") as? LoginViewController else { return }
        
        present(loginVC, animated: true, completion: nil)
    }
    
    
    func cellButtonPressed(sender: UITableViewCell) {
        guard let cell = sender as? ScheduleTableViewCell else { return }
        guard let sender = sender as? ScheduleTableViewCell else { return }
        guard let index = self.tableView.indexPath(for: sender)?.row else { return }
        let schedule = scheduleArray[index]
        let accounts = schedule.twitterAccounts?.allObjects as? [TwitterAccount] ?? []
        
        if schedule.enabled {
            FriendshipController.sharedController.unfollowAccounts(accounts: accounts)
            schedule.enabled = false
            cell.followButton.setImage(#imageLiteral(resourceName: "twtr-icn-logo-white.png"), for: .normal)
        } else {
            
            FriendshipController.sharedController.followAccounts(accounts: accounts)
            cell.followButton.setImage(#imageLiteral(resourceName: "bluetwitterlogo"), for: .normal)
            schedule.enabled = true
        }
        
        ScheduleController.sharedController.saveToPersistentStorage()
        
    }
    
    
    
    
    @IBAction func unwindToScheduleTable(segue: UIStoryboardSegue){
        if segue.source.isKind(of: ScheduleDetailViewController.self){
            guard let detailVC = segue.source as? ScheduleDetailViewController else { return }
            
            accountArray = detailVC.accountArray
            
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return scheduleArray.count

        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let titleCell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as? TitleTableViewCell else { return UITableViewCell()}
            titleCell.titleLabel.text = "Groups"
            
            titleCell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 300)
            self.tableView.separatorStyle = .singleLine
            
            return titleCell
        } else {
            guard let scheduleCell = tableView.dequeueReusableCell(withIdentifier: "scheduleCell", for: indexPath) as? ScheduleTableViewCell else { return UITableViewCell() }
            let schedule = scheduleArray[indexPath.row]
            let accountArray2 = schedule.twitterAccounts?.allObjects as! [TwitterAccount]
            scheduleCell.updateWithSchedule(schedule: schedule, accounts: accountArray2)
            if schedule.enabled {
                scheduleCell.followButton.setImage(#imageLiteral(resourceName: "bluetwitterlogo"), for: .normal)
            } else {
                scheduleCell.followButton.setImage(#imageLiteral(resourceName: "whittertwitterbird"), for: .normal)
            }
            scheduleCell.delegate = self
            
            scheduleCell.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            
            
            
            return scheduleCell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0  {
            return 100
        } else if indexPath.row == 1{
            return 90
        }else {
            return 90
        }
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let schedule = scheduleArray[indexPath.row]
            ScheduleController.sharedController.delete(schedule)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    //MARK: Helper Functions
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navVC = segue.destination as? UINavigationController, let detailVC = navVC.topViewController as? ScheduleDetailViewController, let index = tableView.indexPathForSelectedRow?.row else {return}
        
        if segue.identifier == "editSchedule"{
                detailVC.schedule = scheduleArray[index]
            }
    
    }
}
