//
//  CouplingUtil.swift
//  INSRecharger
//
//  Created by Ramesh Siddanavar on 14/07/21.
//

import Foundation
enum OpenLoopStates : String {
    case EXCELLENT
    case GOOD
    case SHOW_VALUES
}
class CouplingUtil: NSObject {
    let UNINITIALIZED = -1
    var min: Int = 0
    var max: Int = 0
    var current = 0
    var median = 0
    var currentState: OpenLoopStates = .SHOW_VALUES
    var filter: [Int] = [] {
        didSet {
            // remove Head
            if filter.count > 5 {
                filter.removeFirst()
            }
        }
    }
     
    public func addValues(wirelessRecharger: WirelessRecharger, couplingValue: Int) {
        self.filter.append(couplingValue)
        
        // grt than 5 calc median
        if self.filter.count>=5 {
            if let m = filter.median() {
                self.median = m
                let computedCoupling = m
                
                if computedCoupling > wirelessRecharger.getOpenLoopThresholdExcellent() {
                    self.currentState = OpenLoopStates.EXCELLENT
                } else if computedCoupling > wirelessRecharger.getOpenLoopThresholdGood() {
                    self.currentState = OpenLoopStates.GOOD
                } else {
                    if computedCoupling < wirelessRecharger.getOpenLoopCouplingThreshold() {
                        self.currentState = OpenLoopStates.SHOW_VALUES
                    }
                    
                    if currentState != .GOOD {
                        self.current = computedCoupling
                        
                        self.min = min == 0 ? computedCoupling : [computedCoupling, min].min()!
                        self.max = max == 0 ? computedCoupling : [computedCoupling, max].max()!
                    }
                }
            }
        } else {
            self.currentState = OpenLoopStates.SHOW_VALUES
            
            self.current = 0
            self.min = 0
            self.max = 0
        }
    }
    
    
    // Get Values
    func getCurrentState() -> OpenLoopStates {
        return self.currentState
    }
    
    func getMedian() -> Int {
        self.median
    }
    
    func getMin() -> Int {
        self.min
    }
    
    func getMax() -> Int {
        self.max
    }
    
    func getCurrentCoupling() -> Int {
        self.current
    }
}
