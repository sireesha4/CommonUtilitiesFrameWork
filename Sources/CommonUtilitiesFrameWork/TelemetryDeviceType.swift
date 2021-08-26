//
//  TelemetryDeviceType.swift
//  INSRecharger
//
//  Created by Ramesh Siddanavar on 23/06/21.
//

import Foundation

/*
 * Class that contains recharger type information
 */

public class TelemetryDeviceType {

    private var mSerialNumberPrefix: String?
    private var mBluetoothBase: String?
    private var mModelNumber: String?
    private var mCapabilities: Int = 0
    public static var RECHARGE: Int = 1
    public static var DISTANCE_TELEMETRY: Int = 2

    /*
     * Creates a recharger type that defines relevant information about a recharger
     * @param prefix The serial number prefix for the recharger
     * @param bluetoothBase The bluetooth base address for the recharger
     * @param modelNumber The recharger model number.
     * @param capabilities The capabilities of the telemetry device.
     */
    public init( prefix: String, bluetoothBase: String, modelNumber: String, capabilities: Int) {

        mSerialNumberPrefix = prefix
        mBluetoothBase = bluetoothBase
        mModelNumber = modelNumber
        mCapabilities = capabilities
    }

    /*
     * The serial number prefix for the recharger.
     * @return The first 3 letters of the serial number for this type of recharger.
     */
    public func getSerialNumberPrefix() -> String? {
        return mSerialNumberPrefix
    }

    /*
     * The base Bluetooth address for this type of recharger.
     * @return The Bluetooth address base.
     */
    public func getBluetoothBase() -> String? {
        return mBluetoothBase
    }

    /*
     * Gets the model number for this type of recharger.
     * @return The mode number associated with this recharger.
     */
    public func getModelNumber() -> String? {
        return mModelNumber
    }

    /*
     * Designates what the device is capable of doing
     * @return See {@link #RECHARGE} and {@link #DISTANCE_TELEMETRY}
     */
    public func getCapabilities() -> Int {
        return mCapabilities
    }
}
