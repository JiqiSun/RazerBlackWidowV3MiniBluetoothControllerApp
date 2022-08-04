//
//  BluetoothModel.swift
//  BlackWidowV3MiniEffectsController
//
//  Created by Jiqi Sun on 04/08/2022.
//

import CoreBluetooth

class BluetoothModel: NSObject, CBPeripheralDelegate, CBCentralManagerDelegate {

    
    // Characteristics
    private var ledChar: CBCharacteristic?
    
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    private let deviceId = UUID.init(uuidString: "7C2FD6EE-9CE5-BE29-D355-63A85CF2BA49")
    private let serviceUUID = CBUUID.init(string: "52401523-F97C-7F90-0E7F-6C6F4E36DB1C")
    private let charUUID = CBUUID.init(string: "52401524-f97c-7f90-0e7f-6c6f4e36db1c")
    private let setStateCommand = "130a000010030000"
    private let staticStateCommand = "01000001ffffff000000"
    
    
    override init() {
        print("View loaded")
        super.init()
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Central scanning for", serviceUUID);
            centralManager.scanForPeripherals(withServices: nil,options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }

    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.identifier == deviceId {
            // We've found it so stop scan
            self.centralManager.stopScan()
            
            // Copy the peripheral instance
            self.peripheral = peripheral
            self.peripheral.delegate = self
    
    
            // Connect!
            self.centralManager.connect(self.peripheral, options: nil)
            print("connecting...")
        }
        
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to BlackWidow Mini")
            peripheral.discoverServices([serviceUUID]);
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            print("Disconnected")
            self.peripheral = nil
            
            // Start scanning again
            print("Central scanning for", serviceUUID);
            centralManager.scanForPeripherals(withServices: nil,
                                              options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                if service.uuid == serviceUUID {
                    print("BlackWidow Mini LED state update service has been found")
                    //Now kick off discovery of characteristics
                    peripheral.discoverCharacteristics([charUUID], for: service)
                } else {
                    print("BlackWidow Mini LED state update service did not find")
                }
            }
        }
    }
    
    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                if characteristic.uuid == charUUID {
                    print("LED state characteristic found")
                    // Set the characteristic
                    ledChar = characteristic
                    writeLEDValueToChar(withCharacteristic: ledChar!, withValue: hexStringToBytes(hex: setStateCommand))
                    writeLEDValueToChar(withCharacteristic: ledChar!, withValue: hexStringToBytes(hex: staticStateCommand))
                    print("State has been updated to static")
                }
            }
        }
    }

    private func writeLEDValueToChar( withCharacteristic characteristic: CBCharacteristic, withValue value: Data) {
        
        // Check if it has the write property
        if characteristic.properties.contains(.write) && peripheral != nil {
            
            peripheral.writeValue(value, for: characteristic, type: .withResponse)

        }
        
    }
    
    private func hexStringToBytes(hex:String) -> Data {
        var bytes = [UInt8]()
        let text = hex
        var i = text.startIndex
        while i < text.endIndex {
            let nextIndex = text.index(i, offsetBy: 2)
            let hexByte = text[i ..< nextIndex]
            if let byte:UInt8 = UInt8(hexByte, radix:16) {
                bytes.append(byte)
            }
            i = nextIndex
        }
        print (bytes)
        
        return Data(bytes)
        
    }

    
}
