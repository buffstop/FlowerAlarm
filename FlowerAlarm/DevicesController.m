//
//  DevicesController.m
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import "DevicesController.h"

@import CoreBluetooth;
@import BlukiiKit;

@interface DevicesController ()<CBCentralManagerDelegate>
@property(nonatomic, strong) Device* preferredDevice;
@property(nonatomic, strong)CBCentralManager* centralManager;
@property(nonatomic, strong) NSMutableArray* devices;
@property(nonatomic, copy) void (^didRetrieveDevice)(Device* device);
@property(nonatomic, assign, readwrite)BOOL bluetoothEnabled;
@end

@implementation DevicesController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
        self.devices = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)findDevicesWithCompletionBlock:(void (^)(Device* device))completionBlock
{
    self.didRetrieveDevice = completionBlock;
    [self findDevices];
}

- (void)setPreferredDevice:(Device*)device
{
    // save Device
    _preferredDevice = device;
    [self connectDevice:device];
}

- (void)connectDevice:(Device*)device
{
    [self.centralManager connectPeripheral:device.peripheral options:nil];
    [self.centralManager stopScan];
}

- (void)findDevices
{
    if(self.centralManager.state == CBCentralManagerStatePoweredOn) {
        [self.centralManager scanForPeripheralsWithServices:nil options:nil];
    }
}

-(void)setBluetoothEnabled:(BOOL)bluetoothEnabled
{
    _bluetoothEnabled = bluetoothEnabled;
    if (self.bluetoothStateChanged) {
        self.bluetoothStateChanged(bluetoothEnabled);
    }
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    self.bluetoothEnabled = ([central state] == CBCentralManagerStatePoweredOn);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI;
{
    if([BKBlukiiDescription isBlukiiDevice:peripheral]) {
        Device * device  = [[Device alloc] init];
        device.peripheral = peripheral;
        device.name = advertisementData[CBAdvertisementDataLocalNameKey];

        if (self.didRetrieveDevice) {
            self.didRetrieveDevice(device);
        }
    }
}


- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    if ([self.preferredDevice.peripheral isEqual:peripheral]) {
        // device is Connected
        // TODO: register for services....
    }
}


@end
