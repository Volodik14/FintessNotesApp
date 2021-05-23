//
//  AddTrainingTableViewController.swift
//  FintessNotesApp
//
//  Created by Владимир Моторкин on 22.05.2021.
//

import UIKit

extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

class AddTrainingTableViewController: UITableViewController {

    var trainingTemplates = [TrainingTemplate]()
    var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trainingTemplates = CoreDataManager.shared.getSavedTemplates()
        self.navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
        let customCellNib = UINib.init(nibName: "TrainingTableViewCell", bundle: Bundle.main)
        self.tableView.register(customCellNib, forCellReuseIdentifier: "Cell")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        //return 1
        return trainingTemplates.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return training!.allExercisesTemplates.count
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        //cell.layer.cornerRadius = 2
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(rgb: 0xAE2834).cgColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = trainingTemplates[indexPath.section].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath:
                    IndexPath) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let controller = story.instantiateViewController(identifier: "TrainingTableViewController") as TrainingTableViewController
        //print("Got \(training!.allExercisesTemplates.count) exercises")
        //print(indexPath.row)
        let training = CoreDataManager.shared.initNewTrainingByTemplate(template: trainingTemplates[indexPath.section])
        controller.training = training
        training.date = date
        navigationController?.pushViewController(controller, animated: true)
        //self.present(controller, animated: true, completion: nil)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    

}
