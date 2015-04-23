//
//  PeripheralReader.swift
//  FlowerAlarm
//
//  Created by François Benaiteau on 23/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

import Foundation
import CoreBluetooth
import BlukiiKit

class PeripheralReader: NSObject {
    let peripheral: CBPeripheral
    var blukiiContext: BKBlukiiDeviceContext?
    var blukiiDescription: BKBlukiiDescription?
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()
    }
    
    func temperature(completion: (value :NSNumber) -> Void) {
        blukiiDescription = BKBatteryServiceProfileLoader.evaluatePeripheral(self.peripheral)
        //Load Temperature-Profile
        BKTemperatureProfileLoader().loadProfileForBlukii(blukiiDescription!) { (blukiiDeviceContext, error) -> () in
            self.blukiiContext = blukiiDeviceContext
            
            self.blukiiContext?.temperature?.enableProfile({
                (characteristic, error) -> () in
                if error == nil {
                    self.blukiiContext?.temperature?.updateValue({
                        (characteristic, error) -> () in
                        if error == nil {
                            
                    
                            if let temperatureValue:Double? = self.blukiiContext?.temperature?.value {
                                println(temperatureValue)
                                completion(value: NSNumber(double: temperatureValue!))
                            }
                            
                        } else {
                            println(error)
                        }
                    })
                } else {
                    println(error)
                }
            })
        }
    }

    func humidity(completion: (value :NSNumber) -> Void) {
        blukiiDescription = BKBatteryServiceProfileLoader.evaluatePeripheral(self.peripheral)
        //Load Temperature-Profile
        BKHumidityProfileLoader().loadProfileForBlukii(blukiiDescription!) { (blukiiDeviceContext, error) -> () in
            self.blukiiContext = blukiiDeviceContext
            
            self.blukiiContext?.humidity?.enableProfile({
                (characteristic, error) -> () in
                if error == nil {
                    self.blukiiContext?.humidity?.updateValue({
                        (characteristic, error) -> () in
                        if error == nil {
                            
                            
                            if let temperatureValue:
                            BKHumidityValue? = self.blukiiContext?.humidity?.value {
                                println(temperatureValue)
                                completion(value: NSNumber(unsignedChar:  temperatureValue!))
                            }
                            
                        } else {
                            println(error)
                        }
                    })
                } else {
                    println(error)
                }
            })
        }
    }

}