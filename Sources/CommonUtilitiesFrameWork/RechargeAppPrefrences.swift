//
//  RechargeappPrefrences.swift
//  INSRecharger
//
//  Created by Ramesh Siddanavar on 29/06/21.
//

import Foundation

// MARK: - RechargeAppPrefrences
public struct RechargeAppPrefrences: Codable {
    let commManager_version_major, commManager_version_minor, commManager_version_build: Int
    let recharger_configs: [RechargerConfig]
}

// MARK: - RechargerConfig
public struct RechargerConfig: Codable {
    let model: String
    let version_major, version_minor, version_build, ble_version: Int
    let db_version_major, db_version_minor, open_loop_coupling_threshold, open_loop_coupling_threshold_good: Int
    let open_loop_coupling_threshold_excellent: Int
    let open_loop_message, supportsDeviceNotFound, error_instructions_message: String
    let ble_files, fw_files: [String]
    let fwSignatureFile, bleSignatureFile, fwBleSignatureFile, updateCertFile: String
    let required_secret_types: [RequiredSecretType]
    let required_ins_families: [RequiredInsFamily]
    let qInsLimitOpenLoop: [Double]
}

// MARK: - RequiredInsFamily
public struct RequiredInsFamily: Codable {
    let secret, familyid, serialNumberPrefix, therapyVersion: String
    let powerVersion, coreVersion, therapyAppID, powerAppID: String
    let coreAppID, highPowerEnable, batteryCapacity, useReportedCapacity: String
    let therapyControlAllowed, qInsLimit: String
}

// MARK: - RequiredSecretType
public struct RequiredSecretType: Codable {
    let type, version: String
}
