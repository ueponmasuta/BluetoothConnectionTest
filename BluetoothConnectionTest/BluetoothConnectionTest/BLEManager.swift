//
//  BLEManager.swift
//  BluetoothConnectionTest
//
//  Created by 植原　駿 on 2017/06/20.
//  Copyright © 2017年 Shun Uehara. All rights reserved.
//

import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    // サービスのUUIDはデバック時は利用しない
    var serviceUUID : CBUUID!
    var characteristicUUID : CBUUID!
    var centralManager: CBCentralManager!
    var peripheralArray: [CBPeripheral] = []
    var names:[String] = []
    
    /*
     CentralManagerを起動する.
     */
    func initCentralManager() {
        // サービスのUUIDはデバック時は利用しない
        //self.serviceUUID = UUID().uuidString
        self.characteristicUUID = CBUUID(string: "45088E4B-B847-4E20-ACD7-0BEA181075C1")
        // リセット
        peripheralArray = []
        names = []
        
        // CentralManagerの起動
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /*
     CentralManagerの状態を受信する.
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff: // BLE電源オフ
            print("BLE powerOff")
        case .poweredOn: // BLE電源オン
            print("BLE powerOn")
            // Peripheralの探索
            // サービスのUUIDはデバック時は利用しない
            //central.scanForPeripherals(withServices: [self.serviceUUID]?, options: <#T##[String : Any]?#>)
            central.scanForPeripherals(withServices: nil, options: nil)
        case .resetting:
            print("BLE Resetting")
        case .unauthorized:
            print("BLE UnAuthorized")
        case .unknown:
            print("BLE Unknown")
        case .unsupported:
            print("BLE UnSupported")
        }
    }
    
    /*
     Peripheralの探索結果を設定する.
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        print("peripheral: \(peripheral)")
        print("name: \(peripheral.name)")
        print("UUID: \(peripheral.identifier)")
        print("advertisementData: \(advertisementData)")
        //print("RSSI:" + rssi)
        // 配列に追加
        if !peripheralArray.contains(peripheral) {
            if peripheral.name != nil && peripheral.name != "" {
                self.peripheralArray.append(peripheral)
                self.names.append(peripheral.name!)
            }
        }
        for (_, element) in names.enumerated() {
            print("names: \(element)")
        }
    }
    
    /*
     スキャンを終了する.
     */
    func stopPeripheralScan() {
        centralManager.stopScan()
    }
    
    /*
     Peripheralへ接続する.
     */
    func connectPeripheral(selectRow: Int) {
        self.centralManager.connect(self.peripheralArray[selectRow], options: nil)
    }
    
    /*
     Peripheralへの接続が成功.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connect success!")
    }
    
    /*
     Peripheralへの接続が失敗.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connect failed...")
    }
}
