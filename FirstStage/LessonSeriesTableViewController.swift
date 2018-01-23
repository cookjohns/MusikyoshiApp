//
//  LessonSeriesTableViewController.swift
//  FirstStage
//
//  Created by Monday Ayewa on 11/17/17.
//  Copyright © 2017 Musikyoshi. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON

class LessonSeriesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tView: UITableView!
    var instrumentJson: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tView.register(UITableViewCell.self, forCellReuseIdentifier: "LessonSeriesViewCell")
        self.tView.delegate = self
        self.tView.dataSource = self
        self.tView.reloadData()
        
        if let file = Bundle.main.path(forResource: "instruments", ofType: "json"){
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
            let allInstrumentsJson = try? JSON(data: jsonData!)
            
            for (_, subJson) :(String, JSON) in  allInstrumentsJson! {
                //TODO this is value will be based on user default configuration
                if(subJson["name"] == "trumpet"){
                    instrumentJson =  subJson
                    break
                }
            }
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print(jsonString!)
            print(instrumentJson!)
        } else {
            print("unable to open instrument.json file")
        }
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

//    public func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

   // public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
    
   // }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = instrumentJson?["levels"].count {
            return count
        }
        return 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonSeriesViewCell", for: indexPath)
        // Configure the cell...
        if let levels = instrumentJson?["levels"] {
              cell.textLabel?.text = levels[indexPath.row]["title"].string
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Here we are going to seguae to the lesson that the user selected
        performSegue(withIdentifier: "LessonSegue", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let levels = instrumentJson?["levels"] {
            if let destination = segue.destination as? LessonOverviewViewController {
                if let row = sender as? Int {
                   destination.lessonsJson = levels[row]["lessons"]
                }
            }
        }
    }
    
}
