//
//  ScaryBugsTableViewController.swift
//  Scary Bugs
//
//  Created by Aleksandr Pronin on 2/27/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class ScaryBugsTableViewController: UITableViewController {

    // MARK: - Vars
    var bugSections = [BugSection]()
    
    // MARK: - UITableViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem()
        setupBugs()
        tableView.allowsSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let bugSection = bugSections[section]
        return ScaryBug.scaryFactorToString(bugSection.howScary)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return bugSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let adjustment = editing ? 1 : 0
        let bugSection = bugSections[section]
        return bugSection.bugs.count + adjustment
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BugCell", forIndexPath: indexPath)
        let bugSection = bugSections[indexPath.section]
        
        if indexPath.row >= bugSection.bugs.count && editing {
            cell.textLabel?.text = "Add Bug"
            cell.detailTextLabel?.text = nil
            cell.imageView?.image = nil
        } else {
            let bug = bugSection.bugs[indexPath.row]
            cell.textLabel?.text = bug.name
            cell.detailTextLabel?.text = ScaryBug.scaryFactorToString(bug.howScary)
            guard let imageView = cell.imageView else {
                return cell
            }
            if let bugImage = bug.image {
                imageView.image = bugImage
            } else {
                imageView.image = nil
            }
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            let bugSection = bugSections[indexPath.section]
            bugSection.bugs.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        } else if editingStyle == .Insert {
            let bugSection = bugSections[indexPath.section]
            let newBug = ScaryBug(withName: "New Bug", imageName: nil, howScary: bugSection.howScary)
            bugSection.bugs.append(newBug)
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            tableView.beginUpdates()
            for (index, bugSection) in bugSections.enumerate() {
                let indexPath = NSIndexPath(forRow: bugSection.bugs.count, inSection: index)
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
        } else {
            tableView.beginUpdates()
            for (index, bugSection) in bugSections.enumerate() {
                let indexPath = NSIndexPath(forRow: bugSection.bugs.count, inSection: index)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            tableView.endUpdates()
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let bugSection = bugSections[indexPath.section]
        if indexPath.row >= bugSection.bugs.count {
            return .Insert
        } else {
            return .Delete
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        let bugSection = bugSections[indexPath.section]
        if self.editing && indexPath.row < bugSection.bugs.count {
            return nil
        }
        return indexPath
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let bugSection = bugSections[indexPath.section]
        if self.editing && indexPath.row >= bugSection.bugs.count {
            self.tableView(tableView, commitEditingStyle: .Insert, forRowAtIndexPath: indexPath)
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let bugSection = bugSections[indexPath.section]
        if indexPath.row >= bugSection.bugs.count && self.editing {
            return false
        }
        return true
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceSection = bugSections[sourceIndexPath.section]
        let bugToMove = sourceSection.bugs[sourceIndexPath.row]
        let destinationSection = bugSections[destinationIndexPath.section]
        if sourceSection == destinationSection {
            swap(&destinationSection.bugs[destinationIndexPath.row], &sourceSection.bugs[sourceIndexPath.row])
        } else {
            bugToMove.howScary = destinationSection.howScary
            destinationSection.bugs.insert(bugToMove, atIndex: destinationIndexPath.row)
            sourceSection.bugs.removeAtIndex(sourceIndexPath.row)
            
            let delayInSeconds:Double = 0.2
            let dispatchTime = Int64(delayInSeconds * Double(NSEC_PER_SEC))
            let popTime = dispatch_time(DISPATCH_TIME_NOW, dispatchTime)
            dispatch_after(popTime, dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadRowsAtIndexPaths([destinationIndexPath], withRowAnimation: .None)
            })
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        let bugSection = bugSections[proposedDestinationIndexPath.section]
        if proposedDestinationIndexPath.row >= bugSection.bugs.count {
            return NSIndexPath(forRow: bugSection.bugs.count-1, inSection: proposedDestinationIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
    
    // MARK: - Private
    
    private func setupBugs() {
        bugSections.append(BugSection(howScary: .NotScary))
        bugSections.append(BugSection(howScary: .ALittleScary))
        bugSections.append(BugSection(howScary: .AverageScary))
        bugSections.append(BugSection(howScary: .QuiteScary))
        bugSections.append(BugSection(howScary: .Aiiiiieeeee))
        
        let bugs = ScaryBug.bugs()
        for bug: ScaryBug in bugs {
            let bugSection = bugSections[bug.howScary.rawValue]
            bugSection.bugs.append(bug)
        }
    }
    
}
