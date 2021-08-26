//
//  ConnectionUtils.swift
//  INSRecharger
//
//  Created by Ramesh Siddanavar on 23/06/21.
//

import Foundation

/*
 * Utilities for dealing with serial numbers and Bluetooth Addresses
 */
// swiftlint:disable all
public class ConnectionUtils {

    let LENGTH_OF_SERIALNUMBER: Int = 9
    let SERIAL_VALUE_START_INDEX: Int = 3
    let MAX_SERIAL: Int = 999999
    let MEDTRONIC_SN_POST_FIX: String = "N"
    
    let stepper = 2
    let colonChar:Character = ":"
    
    let colonStr = ":"
    let emptyStr = ""
    let radix = 16
    
    let defaultIntValue = 0

    var validDevices: [TelemetryDeviceType] = [TelemetryDeviceType]()
    
   public init() {
        //NPW - WR9200, NPR - WR9210, NPP - WR9220
        validDevices.append(TelemetryDeviceType(prefix: "NPW", bluetoothBase: "0x205B2A658480L",modelNumber: "WR9200", capabilities: TelemetryDeviceType.RECHARGE)) //thor
        validDevices.append(TelemetryDeviceType(prefix: "NPR", bluetoothBase: "0x205B2A74C6C0L",modelNumber: "WR9210", capabilities: TelemetryDeviceType.RECHARGE)) //thor
        validDevices.append(TelemetryDeviceType(prefix: "NPP", bluetoothBase: "0x205B2A840900L",modelNumber: "WR9220", capabilities: TelemetryDeviceType.RECHARGE)) //thor
        validDevices.append(TelemetryDeviceType(prefix: "NRA", bluetoothBase: "0x205B2A934B40L",modelNumber: "WR9230", capabilities: TelemetryDeviceType.RECHARGE)) //thor
        validDevices.append(TelemetryDeviceType(prefix: "NPE", bluetoothBase: "0x205B2A564240L",modelNumber: "TM91", capabilities: TelemetryDeviceType.DISTANCE_TELEMETRY)) //indra
    }
    
    /*
     * Gets the list of serial number prefixes for rechargers.
     * @return The list of serial number prefixes
     */
    public func getRechargerPrefixes() -> [String] { //[NPW,NPR,NPP]
        var rechargers: [String] = [String]()
        for type in validDevices {
            if (type.getCapabilities() & TelemetryDeviceType.RECHARGE) != 0 {
                rechargers.append(type.getSerialNumberPrefix()!)
            }
        }
        return rechargers
    }
    
    /*
     * Gets the list of serial number prefixes for rechargers.
     * @return The list of serial number prefixes
     */
    public func getRechargerPrefixes(telemetryDeviceType:String) -> [String] {
        var rechargers: [String] = [String]()
        for type in validDevices {
            if((type.getCapabilities()) != 0) {
                if telemetryDeviceType == "Thor" {
                    rechargers.append(type.getSerialNumberPrefix()!)
                } else {
                    rechargers.append(type.getSerialNumberPrefix()!)
                }
            }
        }
        return rechargers
    }

    /*
     * Gets the serial number prefix for a particular model number.
     * @param model The model number of the desired device
     * @return The prefix for the associated serial numbers for that model.
     */
    public func getSerialNumberPrefixForModel(model: String) -> String? {
        for type in validDevices {
            if let validModel = type.getModelNumber() {
                if validModel.contains(model) {
                    return type.getSerialNumberPrefix()
                }
                return nil
            }
            return nil
        }
        return nil
    }

    /*
     * Determines if a given serial number belongs to a telemetry device
     * @param data The serial number to check
     * @param deviceType the type of telemetry device to check for.
     * @return True if it is a valid serial number
     */
    public func isValidSerialNumber( data: String, deviceType: Int) -> Bool {
        var isSerialNumber = false
        if let typee: TelemetryDeviceType = getTypeForSerialNumber(serialNumber: data), typee.getCapabilities() == deviceType {
            isSerialNumber = ConnectionUtils.isDigitsOnly(data.substring(startIndex: ConnectionUtils().SERIAL_VALUE_START_INDEX, endIndex: ConnectionUtils().LENGTH_OF_SERIALNUMBER))
        }
        return isSerialNumber
    }
    
    //A function that checks if a string has any numbers
    public static func isDigitsOnly(_ string:String) -> Bool {
        for character in string {
            if character.isNumber {
                return true
            }
        }
        return false
    }

    
    /*
     * Converts a serial number into the corresponding Bluetooth address
     * @param serialNumber The serial number to convert
     * @return The bluetooth address or empty if the serial number is not valid.
     */
    public func convertSerialNumberToBluetoothAddress( serialNumber: String) -> String {
        var address: String = ""
        
        if let type: TelemetryDeviceType = getTypeForSerialNumber(serialNumber: serialNumber) {
        
            let serialValue: String = serialNumber.substring(startIndex: ConnectionUtils().SERIAL_VALUE_START_INDEX, endIndex: ConnectionUtils().LENGTH_OF_SERIALNUMBER)
            
            let serialIntValue = Int(serialValue) ?? defaultIntValue
            
            if let btAddress = type.getBluetoothBase() {
                var add = btAddress
                var _: () = add.removeFirst(stepper)
                _ = add.removeLast()
                
                let finalAdd = Int.init(add, radix: radix) ?? defaultIntValue
                
                let finalAddress = finalAdd + serialIntValue
                address = convertToBluetoothAddressString(address: finalAddress)
            }

        }
        return address
    }

    /*
     * Converts a Bluetooth Address to a serial number
     * @param bluetoothAddr The bluetooth address to convert
     * @return The serial number or empty if the address is not valid.
     */
    public func convertBluetoothAddressToSerialNumber( bluetoothAddr: String) -> String {
        var blAddr = ""
        
        
        if(isBluetoothAddress(data: bluetoothAddr)) {
            let address = bluetoothAddr.replacingOccurrences(of: colonStr, with: emptyStr)
            if let bluetoothAddrr  = Int.init(address, radix: radix) {
                for telemetryDeviceType in validDevices {
                    if let blBase = telemetryDeviceType.getBluetoothBase(), let prefix = telemetryDeviceType.getSerialNumberPrefix()  {
                        var basee = blBase
                        basee.removeFirst(stepper)
                        basee.removeLast()
                        if let base = Int.init(basee, radix: radix) {
                            let remainder = bluetoothAddrr - base
                            if remainder > 0 && remainder <= MAX_SERIAL {
                                blAddr = "\(prefix)\(remainder)\(MEDTRONIC_SN_POST_FIX)"
                            } else {
                                return blAddr
                            } // else
                        } // if
                    } // base
                } // for
            } // BL hex
        }// valid BL Addr
        return blAddr
    }
    
   
    /*
     * Determines if the given string is a bluetooth address
     * @param data The address string
     * @return True if the strings is a bluetooth addrss, otherwise false.
     */
    public func isBluetoothAddress(data: String) -> Bool{
        var isBluetoothAddress = false
        let predecate = NSPredicate(format: "SELF MATCHES %@", "^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$")

        if(!data.isEmpty) {
            isBluetoothAddress = predecate.evaluate(with: data)
        }
        return isBluetoothAddress
    }

    /*
     * Gets the model number for the given serial number
     * @param serialNumber The serial number to check
     * @return The model number or empty string if the model cannot be determined.
     */
    public func getModelForSerialNumber(serialNumber: String) -> String {
        if let type: TelemetryDeviceType = getTypeForSerialNumber(serialNumber: serialNumber) {
            return type.getModelNumber() ?? ""
        }
        return ""
    }
    
    public func getTypeForSerialNumber( serialNumber: String) -> TelemetryDeviceType? {
        if(!serialNumber.isEmpty && serialNumber.count >= ConnectionUtils().LENGTH_OF_SERIALNUMBER) {
            for telemetryDeviceType in validDevices {
                if (serialNumber.substring(startIndex: 0, endIndex: ConnectionUtils().SERIAL_VALUE_START_INDEX).uppercased().contains(telemetryDeviceType.getSerialNumberPrefix()!)) {
                    return telemetryDeviceType
                }
            }
        }
        return nil
    }
    
   public func convertToBluetoothAddressString(address: Int) -> String {
        let btAddress = String(format: "%llX", CLongLong(address))
        let finalAddress = btAddress.separate(every: stepper, with: colonChar)
        return finalAddress.uppercased()
    }
    
   public func getDeviceInfo() {
        // Obtain the machine hardware platform from the `uname()` unix command
        //
        // Example of return values
        //  - `"iPhone8,1"` = iPhone 6s
        //  - `"iPad6,7"` = iPad Pro (12.9-inch)
        var unameMachine: String {
            var utsnameInstance = utsname()
            uname(&utsnameInstance)
            let optionalString: String? = withUnsafePointer(to: &utsnameInstance.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                    ptr in String.init(validatingUTF8: ptr)
                }
            }
            return optionalString ?? "N/A"
        }
    }
   public static func getRoundedBattery(insBattery: Int) -> Int {
            var roundedBattery = (Float(insBattery/5)).rounded(.towardZero)
            print(roundedBattery)
            switch roundedBattery {
            case 0..<2:
                roundedBattery = 0
            case 2..<3:
                roundedBattery = 10
            case 3..<5:
                roundedBattery = 20
            case 5..<7:
                roundedBattery = 30
            case 7..<9:
                roundedBattery = 40
            case 9..<11:
                roundedBattery = 50
            case 11..<13:
                roundedBattery = 60
            case 13..<15:
                roundedBattery = 70
            case 15..<17:
                roundedBattery = 80
            case 17..<19:
                roundedBattery = 90
            case 19...20:
                roundedBattery = 100
            default:
                roundedBattery = 100
            }
        return Int(roundedBattery)
        }
}

