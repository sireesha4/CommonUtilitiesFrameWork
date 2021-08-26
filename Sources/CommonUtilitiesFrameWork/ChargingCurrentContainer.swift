//
//  ChargingCurrentContainer.swift
//  INSRecharger
//
//  Created by Ramesh on 18/07/21.
//

import Foundation

class ChargingCurrentContainer {
    private let  SIG_DIGITS = 2
    
    private var minCharge: Double =  0
    private var maxCharge: Double = 0
    private var currentCharge: Double = 0
    
    public func addValue(chargeValue: Double) {
        currentCharge = chargeValue
        minCharge = minCharge == 0 ? chargeValue : min(chargeValue, minCharge)
        maxCharge = maxCharge == 0 ? chargeValue : max(chargeValue, maxCharge)

    }
    
   public func getMinCharge() -> String {
        if minCharge == 0 {
            return "-1"
        }
        return Swift.String(format: "%.0f", minCharge)
        
    }
    
   public func getMaxCharge() -> String {
        if minCharge == 0 {
            return "-1"
        }
        return Swift.String(format: "%.0f", maxCharge)
        
    }

   public func getCurrentCharge() -> String {
        if minCharge == 0 {
            return "-1"
        }
        return Swift.String(format: "%.0f", currentCharge)
        
    }
}
