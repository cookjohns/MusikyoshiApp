//
//  LessonSeriesViewController.swift
//  FirstStage
//
//  Created by Caitlyn Chen on 1/22/18.
//  Modified by Scott Freshour
//
//  Copyright © 2018 Musikyoshi. All rights reserved.
//

// Top Level VC

import UIKit
import Foundation
import SwiftyJSON


let levelHeaderSpacingStr = "       " // leaves room at front for checkbox icon

class LevelSeriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var checkImage: UIImage? = nil
    var nocheckImage: UIImage? = nil
    var checkImageView: UIImageView? = nil

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var instrumentJson: JSON?
    var levelsJson: JSON?
    
    var thresholdsID         = kThershIDsStr_Begin_1
    var singleEventThreshold = kSingleEventThreshDefaultStr
    
    let kNoSectionSelected = -1
    var currLevel:Int = 0
    var currDay = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        if let file = Bundle.main.path(forResource: "TrumpetLessons", ofType: "json"){
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: file))
            if jsonData != nil {
                instrumentJson = try? JSON(data: jsonData!)
            } else {
                print ("unable to acquire jsonData or instrumentJson")
            }
            
            if instrumentJson != nil {
                levelsJson = instrumentJson?["levels"]
            } else {
                print ("unable to acquire levelsJson")
            }
        } else {
            print("Invalid TrumpetLessons filename/path.")
        }
        
        self.view.backgroundColor = kTanBackgroundColor
        self.tableView.backgroundColor = kTanBackgroundColor
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        
        navigationBar.topItem?.title = "Levels"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let count = instrumentJson?["levels"].count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var retStr = ""
        let titleStr = levelsJson?[section]["title"].string
        if titleStr != nil {
            retStr = levelHeaderSpacingStr + titleStr! // leave room at front for checkbox icon
        }
        
        return retStr
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard levelsJson != nil else { return 0 }
        
        var count = 0
        if section != currLevel { return 0 }

        var daysJson:JSON?
        daysJson = levelsJson![section]["days"]
        if ( daysJson != nil ) {
            count = daysJson!.count
        }

        return count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =
            tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
                as? LevelSeriesTableViewHeaderFooterView
                ?? LevelSeriesTableViewHeaderFooterView(reuseIdentifier: "header")
        header.contentView.backgroundColor = kDefault_SectionBkgrndColor
        header.section = section
        if header.gestureRecognizers == nil {
            let tap = UITapGestureRecognizer( target: self, action: #selector(headerTapped))
            tap.numberOfTapsRequired = 1
            header.addGestureRecognizer(tap)
        }
        
        let levelState = LessonScheduler.instance.getLevelState(level: section)
        
        var checkState: LevelSeriesTableViewHeaderFooterView.CheckState = .unchecked
        if levelState == kLDEState_Completed  {  // kLDEState_InProgress
            checkState = .checked
        }
        header.setCheckedState(state: checkState)
        
        return header
    }

    @objc func headerTapped(_ g: UIGestureRecognizer) {
        let vw = g.view as! LevelSeriesTableViewHeaderFooterView
        let section = vw.section
        guard section != self.currLevel else { return }
        
        let oldSection = self.currLevel
        self.currLevel = kNoSectionSelected
        let indexSet = IndexSet(integer:oldSection)
        tableView.reloadSections(indexSet, with: .automatic)
        
        self.currLevel = section
        delay( 0.25) {
            let indexSetNew = IndexSet(integer: section)
            self.tableView.reloadSections(indexSetNew, with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! LevelSeriesTableViewHeaderFooterView // UITableViewHeaderFooterView
        //header.textLabel?.font = UIFont.(name: "Futura", size: 13)!
        header.backgroundView?.backgroundColor = kDefaultViewBackgroundColor //BkgrndColor //UIColor.yellow
    }
    
    func isSelectedCell(indexPath: IndexPath) -> Bool {
//        print ("  in isSelectedCell;  section = \(indexPath.section),  row = \(indexPath.row)")
        if indexPath.section == currLevel && indexPath.row == currDay {
 //           print ("     currLevel = \(currLevel),  currDay = \(currDay); returning->  TRUE")
            return true
        } else {
 //           print ("     currLevel = \(currLevel),  currDay = \(currDay); returning->  FALSE")
           return false
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
         if isSelectedCell(indexPath:indexPath) {
             cell.contentView.backgroundColor = kDefault_SelectCellBkgrndColor
        } else {
            cell.contentView.backgroundColor = kDefault_CellBkgrndColor
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ""
        
        let section = indexPath.section
        let row = indexPath.row
        print ("in cellForRowAt;  section = \(section),  row = \(row)")
        if isSelectedCell(indexPath:indexPath) {
        // if cell.isSelected {
            cell.contentView.backgroundColor = kDefault_SelectCellBkgrndColor
        } else {
            cell.contentView.backgroundColor = kDefault_CellBkgrndColor
        }
        
        guard levelsJson != nil  else { return cell }

        var daysJson:JSON?
        daysJson = levelsJson![indexPath.section]["days"]
        if ( daysJson != nil ) {
            var titleStr = ""
            if let rowTitle = daysJson![indexPath.row]["title"].string {
                titleStr += rowTitle
            }
            cell.textLabel?.text = titleStr
        }
        
        let thisLD: tLD_code = ( indexPath.section, indexPath.row )
        let dayState = LessonScheduler.instance.getDayState(forLD: thisLD)
        
        makeCheckboxIconImage()
        if dayState == kLDEState_Completed {
            cell.imageView?.image = checkImage
        } else {
            cell.imageView?.image = nocheckImage
        }
        cell.imageView?.frame.origin.x += 5
        cell.imageView?.isHidden = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        //Here we are going to seguae to the lesson that the user selected
        //performSegue(withIdentifier: "LessonSegue", sender: indexPath.row)  // PPPproblem!!!!!
        let selectedCell:UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.contentView.backgroundColor = kDefault_SelectCellBkgrndColor
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Here we are going to seguae to the lesson that the user selected
        //performSegue(withIdentifier: "LessonSegue", sender: indexPath.row)  // PPPproblem!!!!!
        let selectedCell:UITableViewCell? = tableView.cellForRow(at: indexPath)!
        selectedCell?.contentView.backgroundColor = kDefault_SelectCellBkgrndColor
        currLevel = indexPath.section
        currDay = indexPath.row
        performSegue(withIdentifier: "LessonSegue", sender: indexPath)  // PPPproblem!!!!!
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard indexPath.section >= 0 && indexPath.section < (levelsJson?.count)! else {
            print ("Unable to get levelsJson in LevelSeriesViewController::didDeselectRowAt")
            return
        }
        
        // var daysJson:JSON?
        let daysJson:JSON? = levelsJson![indexPath.section]["days"]
        guard daysJson != nil  else {
            print ("Unable to get daysJson in LevelSeriesViewController::didDeselectRowAt")
            return
        }
        guard indexPath.row >= 0 && indexPath.row < (daysJson?.count)! else {
            print ("row >= num days in LevelSeriesViewController::didDeselectRowAt")
            return
        }
        
        let myIndexPath = IndexPath(row: currDay, section: currLevel)
        let cellToDeSelectQ:UITableViewCell? = tableView.cellForRow(at: myIndexPath)
        if cellToDeSelectQ != nil {
            cellToDeSelectQ!.contentView.backgroundColor = kDefault_CellBkgrndColor
            print ("-->>>  Completed Deselect option 1 in LevelSeriesViewController::didDeselectRowAt")
        } else {
            print ("unable to get cellToDeSelect option 1 in LevelSeriesViewController::didDeselectRowAt")
        }

        let cellToDeSelectImp:UITableViewCell? = tableView.cellForRow(at: indexPath)
        if cellToDeSelectImp != nil {
            cellToDeSelectImp!.contentView.backgroundColor = kDefault_CellBkgrndColor
            print ("-->>>  Completed Deselect option 2 in LevelSeriesViewController::didDeselectRowAt")
        } else {
            print ("unable to gdt cellToDeSelect  option 2 in LevelSeriesViewController::didDeselectRowAt")
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // PPPproblem!!!!!
        
        if let levels = instrumentJson?["levels"] {
            if let destination = segue.destination as? LevelOverviewViewController {
                if let indexPath = sender as? IndexPath {
                    let level = indexPath.section
                    _ = LessonScheduler.instance.setCurrentLevel(level)
                    destination.thisViewsLevel = level
                    destination.exerLevelIndex = indexPath.row
                    destination.lessonsJson = levels[indexPath.section]["exercises"]
                    let daysJson:JSON? = levels[indexPath.section]["days"]
                    
                    let day = indexPath.row
                    _ = LessonScheduler.instance.setCurrentDay(day)
                    destination.thisViewsLevelDay = day
                    let oneDayExerListStr = daysJson![indexPath.row]["exercises"].string
                    let oneDayExerTitle   = daysJson![indexPath.row]["title"].string
                    destination.dayTitle = (oneDayExerTitle != nil) ? oneDayExerTitle! : ""
                    destination.exercisesListStr = (oneDayExerListStr != nil) ? oneDayExerListStr! : ""

                    destination.thresholdsID         = thresholdsID
                    destination.singleEventThreshold = singleEventThreshold
                    if let threshIDStr = levels[indexPath.section]["thresholdsID"].string {
                       destination.thresholdsID = threshIDStr
                    }
                    if let singEvtThersh = levels[indexPath.section]["singleEventThreshold"].string {
                        destination.singleEventThreshold = singEvtThersh
                    }
                }
            }
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func makeCheckboxIconImage() {
        if  checkImage != nil && nocheckImage != nil
        { return }
        
        let imgSz = CGSize(width: 35.0, height: 16.0) // was 20
        UIGraphicsBeginImageContextWithOptions(imgSz, false, 0.0);

        nocheckImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
      
        UIGraphicsBeginImageContextWithOptions(imgSz, false, 0.0);

        let xAdj = 15.0
        
        let checkPathGray = UIBezierPath()
        checkPathGray.lineWidth = 2
        checkPathGray.move(to: CGPoint(x: 2+xAdj, y: 8))         // 2, 9
        checkPathGray.addLine(to:CGPoint(x: 7+xAdj, y: 13))      // 6, 13
        checkPathGray.addLine(to:CGPoint(x: 19+xAdj, y: 2))      // 18, 2

        checkPathGray.lineWidth = 4
        UIColor.darkGray.setStroke()
        checkPathGray.stroke()
        
        let checkPathGreen = UIBezierPath()
        checkPathGreen.lineWidth = 3
        checkPathGreen.move(to: CGPoint(x: 3+xAdj, y: 9))       // 3, 10
        checkPathGreen.addLine(to:CGPoint(x: 7+xAdj, y: 13))     // 6, 13
        checkPathGreen.addLine(to:CGPoint(x: 18+xAdj, y: 3))     // 17, 3
        
        checkPathGreen.lineWidth = 2
        UIColor.green.setStroke()
        checkPathGreen.stroke()
        
        checkImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if checkImage != nil {
            checkImageView = UIImageView(image:checkImage)
        }
    }
}
