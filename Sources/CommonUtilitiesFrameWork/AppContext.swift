//
//  AppContext.swift
//  INSRecharger
//
//  Created by Ramesh Siddanavar on 01/07/21.
//

import Foundation


public class AppContext {
    
    static var shared = AppContext()
    
    let isDemoKey = "isDemoKey"

    var isDemo: Bool {
        get {
            return UserDefaults.standard.bool(forKey: isDemoKey) 
        }
        set {
            UserDefaults.standard.set(newValue, forKey: isDemoKey)
        }
    }
    
    var errorInstructionsMessage = ""
    
    var openLoopMessage = ""
    
    func getResources() {
        
    }
    
}
