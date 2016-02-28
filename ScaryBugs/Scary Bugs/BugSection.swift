//
//  BugSection.swift
//  Scary Bugs
//
//  Created by Aleksandr Pronin on 2/27/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

class BugSection {
    let howScary: ScaryFactor
    var bugs = [ScaryBug]()
    init(howScary: ScaryFactor) {
        self.howScary = howScary
    }
    
}

func ==(lhs: BugSection, rhs: BugSection) -> Bool {
    var isEqual = false
    if (lhs.howScary == rhs.howScary && lhs.bugs.count == rhs.bugs.count) {
        isEqual = true
    }
    return isEqual
}
