//
//  WirelessRecharger.swift
//  INSRecharger
//
//  Created by Ramesh Siddanavar on 29/06/21.
//

import Foundation

/*
 * Class that contains information on a wireless recharger.
 */
public class WirelessRecharger {

    var MODEL = "model"
    var VERSION_MAJOR = "version_major"
    var VERSION_MINOR = "version_minor"
    var VERSION_BUILD = "version_build"
    var BLE_VERSION = "ble_version"
    var DB_VERSION_MAJOR = "db_version_major"
    var DB_VERSION_MINOR = "db_version_minor"
    var BLE_FILES = "ble_files"
    var OPEN_LOOP_COUPING_THRESHOLD = "open_loop_coupling_threshold"
    var OPEN_LOOP_COUPING_THRESHOLD_GOOD = "open_loop_coupling_threshold_good"
    var OPEN_LOOP_COUPING_THRESHOLD_EXCELLENT = "open_loop_coupling_threshold_excellent"
    var OPEN_LOOP_MESSAGE = "open_loop_message"
    var SUPPORT_NOT_LOCATE = "supportsDeviceNotFound"
    var ERROR_INSTRUCTIONS_MESSAGE = "error_instructions_message"
    var SECRET_FILE = "data.json"
    var FW_SIG_FILE = "fwSignatureFile"
    var BLE_SIG_FILE = "bleSignatureFile"
    var FW_BLE_SIG_FILE = "fwBleSignatureFile"
    var UPDATE_CERT_FILE = "updateCertFile"
    var OPEN_LOOP_LIMIT = "qInsLimitOpenLoop"
    
    var modelNumber = ""
    var majorVersion = 0
    var minorVersion = 0
    var buildVersion = 0
    var bleVersion = 0
    var majorDBVersion = 0
    var minorDBVersion = 0
    var openLoopCouplingThreshold = 0
    var openLoopCouplingThresholdGood = 0
    var openLoopCouplingThresholdExcellent = 0
    var openLoopMessage = ""
    var supportsDeviceNotFound = false
    var errorInstructionsMessage = ""
    var bleFiles: [String] =  [String]()
    var fwFiles: [String] = [String]()
    var fwSig = ""
    var bleSig = ""
    var fwBleSig = ""
    var updateCert = ""
    var openLoopHeatLimits: [String] =  [String]()
    
    /*
     * Static method for creating the WR from a JSON configuration
     * @param context The app context
     * @param configuration The JSON configuration
     * @return A Wireless recharger object
     * @throws JSONException When using invalid JSON
     */
    
    func getFromConfiguration(config: RechargerConfig) -> WirelessRecharger? {
        
        //        let resources = context.getResources()
        let recharger: WirelessRecharger = WirelessRecharger()
        
        recharger.modelNumber = config.model
        recharger.majorVersion = config.version_major
        recharger.minorVersion = config.version_minor
        recharger.buildVersion = config.version_build
        recharger.bleVersion = config.ble_version
        recharger.majorDBVersion = config.db_version_major
        recharger.minorDBVersion = config.db_version_minor
        recharger.openLoopCouplingThreshold = config.open_loop_coupling_threshold
        recharger.openLoopCouplingThresholdGood = config.open_loop_coupling_threshold_good
        recharger.openLoopCouplingThresholdExcellent = config.open_loop_coupling_threshold_excellent
        recharger.openLoopMessage = config.open_loop_message  
        recharger.supportsDeviceNotFound = Bool(config.supportsDeviceNotFound)!
        recharger.errorInstructionsMessage = config.error_instructions_message
        recharger.fwSig = config.fwSignatureFile
        recharger.bleSig = config.bleSignatureFile
        recharger.fwBleSig = config.fwBleSignatureFile
        recharger.updateCert = config.updateCertFile
        
        for (index, ble) in config.ble_files.enumerated() {
            recharger.bleFiles.insert(ble, at: index)
        }// ble
        
        for (index, files) in config.fw_files.enumerated() {
            recharger.fwFiles.insert(files, at: index)
        }// fw
        
        for (index, limits) in config.qInsLimitOpenLoop.enumerated() {
            recharger.openLoopHeatLimits.insert("\(limits)", at: index)
        }
        //
        return recharger
    }
    
    /*
     * The recharger model number
     * @return The model number for the recharger object.
     */
    public func getModelNumber() -> String {
        return modelNumber
    }
    
    /*
     * Gets the firmware major version
     * @return The firmware major version
     */
    public func getMajorVersion() -> Int {
        return majorVersion
    }
    /*
     * Gets the firmware minor version
     * @return The firmware minor version
     */
    public func getMinorVersion() -> Int {
        return minorVersion
    }
    /*
     * Gets the firmware build version
     * @return The firmware minor version
     */
    public func getBuildVersion() -> Int {
        return buildVersion
    }
    /*
     * The version of the BLE firmware
     * @return The BLE firmware version
     */
    public func getBleVersion() -> Int {
        return bleVersion
    }
    
    /*
     * The Major version of the Recharger DB
     * @return The major DB version
     */
    public func getMajorDBVersion() -> Int {
        return majorDBVersion
    }
    /*
     * The minor version of the DB
     * @return The minor version of the database
     */
    public func getMinorDBVersion() -> Int {
        return minorDBVersion
    }
    /*
     * The Open Loop threshold for excellent coupling for the given model
     * @return The Open Loop threshold for excellent coupling
     */
    public func getOpenLoopCouplingThreshold() -> Int {
        return openLoopCouplingThreshold
    }
    /*
     * The Open Loop threshold for good coupling for the given model
     * @return The Open Loop threshold for good coupling
     */
    public func getOpenLoopThresholdGood() -> Int {
        return openLoopCouplingThresholdGood
    }
    /*
     * The Open Loop threshold for excellent coupling for the given model
     * @return The Open Loop threshold for excellent coupling
     */
    public func getOpenLoopThresholdExcellent() -> Int {
        return openLoopCouplingThresholdExcellent
    }
    /*
     * Indicates if the "Device Not Found" screen is supported by the given model
     * @return true if the NOTLOCATE alert is supported, false otherwise
     */
    public func getSupportsDeviceNotFound() -> Bool {
        return supportsDeviceNotFound
    }
    /*
     * Provides the list of files that are needed for updating the FW on the Recharger
     * @return The list of FW update files
     */
    public func getFirmwareFiles() -> [String] {
        return fwFiles
    }
    /*
     * Provides the list of files that are needed for updating BLE on the Recharger
     * @return The list of BLE update files
     */
    public func getBleFiles() -> [String] {
        return bleFiles
    }
    /*
     * Provides the ID to get the wait message for when the app is in open loop charging mode.
     * @return The open loop message for this style of recharger.
     */
    //FIXME: Context in UIAppliction
    func getOpenLoopWaitMessage( context: AppContext) -> String {
        return context.openLoopMessage
    }
    /*
     * The recharge update firmware signature file
     * @return The recharge update firmware signature file
     */
    public func getFwSig() -> String {
        return fwSig
    }
    /*
     * The recharge update BLE signature file
     * @return The recharge update firmware signature file
     */
    public func getBleSig() -> String {
        return bleSig
    }
    /*
     * The recharge update firmware and BLE signature file
     * @return The recharge update firmware signature file
     */
    public func getFwBleSig() -> String {
        return fwBleSig
    }
    /*
     * The recharge update firmware certificate file
     * @return The recharge update firmware signature file
     */
    public func getUpdateCert() -> String {
        return updateCert
    }
    /*
     * Provides the ID to get the error message for when the app is in error state system state.
     * @return The error state notification message for this model of recharger.
     */
    //FIXME: Context
    func getErrorInstructionsMessage( context: AppContext) -> String {
        return context.errorInstructionsMessage
    }

    /*
     * Provides the list of heat limits configured for the wireless recharger.
     * @return The open loop heat limits in a string array.
     */
    public func getOpenLoopHeatLimits() -> [String] {
        return openLoopHeatLimits
    }
    /*
     * Content description
     * @return The content description
     */
    public func describeContents() -> Int {
        return 0
    }

}
