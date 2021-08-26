//
//  CouplingValueContainer.swift
//  INSRecharger
//
//  Created by Ramesh on 18/07/21.
//

import Foundation

public class CouplingValueContainer: NSObject {

    let UNINITIALIZED : Int = -1

    var filter = MedianFilter(size: 5)
    var  minCoupling : Int = -1
    var  maxCoupling : Int = -1
    var  currentCoupling : Int = -1
    var  median : Int?

    private  var currentStat = OpenLoopStates.SHOW_VALUES

     public func addValues(wirelessRecharger: WirelessRecharger, couplingValue: Int) {
        filter.addValue(value: couplingValue)
        median = filter.getMedianValue()
        var computedCoupling = 0
        if median != nil {
            if couplingValue != 0 {
                computedCoupling = median ?? 0
            }
        }

        if computedCoupling > wirelessRecharger.getOpenLoopThresholdExcellent() {
            currentStat = OpenLoopStates.EXCELLENT
        } else if computedCoupling > wirelessRecharger.getOpenLoopThresholdGood() {
            currentStat = OpenLoopStates.GOOD
        } else {
            if computedCoupling > wirelessRecharger.getOpenLoopCouplingThreshold() {
                currentStat = OpenLoopStates.SHOW_VALUES
            }
            if median != nil && currentStat != .GOOD {
                currentCoupling = computedCoupling
                minCoupling = minCoupling == UNINITIALIZED ? computedCoupling : min(computedCoupling, minCoupling)
                minCoupling = maxCoupling == UNINITIALIZED ? computedCoupling : min(computedCoupling, maxCoupling)
            }
        }
    }

    public func getMedian() -> Int {
        return median ?? 0
    }

    public func getMinCoupling() -> Int {
        return minCoupling
    }

    /**
     * Get max coupling value
     * @return max coupling value
     */
    public func getMaxCoupling() -> Int {
        return maxCoupling
    }

    /**
     * Get current coupling value
     * @return current coupling value
     */
    public func getCurrentCoupling() -> Int {
        return currentCoupling
    }

    /**
     * Get current charging state
     * @return current charging state
     */
    func getCurrentState() -> OpenLoopStates{
        return currentStat
    }
}

class MedianFilter {
    private var valueQueue: [Int] = []

    private var  size: Int?
    init(size: Int) {
        self.size = size
    }
    
    
    public func addValue(value: Int) {
        valueQueue.append(value)
        if(valueQueue.count > size ?? 0) {
              valueQueue.removeAll()
          }
      }

    func getMedianValue() -> Int {
        if(valueQueue.count >= size ?? 0) {
            let arrSort = valueQueue.sorted(by: {$0 < $1})
            return arrSort.count / 2
        }
        return 0
    }


}
