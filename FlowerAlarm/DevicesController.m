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
@property(nonatomic, strong) CBCentralManager* centralManager;
@property(nonatomic, strong) NSMutableArray* devices;
@property(nonatomic, copy) void (^didRetrieveDevice)(Device* device);
@property(nonatomic, assign, readwrite)BOOL bluetoothEnabled;

@property(nonatomic, strong)BKBlukiiDeviceContext* deviceContext;
@end

NSString *const PreferredDeviceFoundNotification = @"PreferredDeviceFoundNotification";
NSString *const PreferredDeviceFoundNotificationDeviceKey = @"preferredDevice";
static NSString *const kPreferredDeviceId = @"preferredDeviceId";

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

- (void)restorePreferredDevice
{
    [self findDevices];
}

- (void)findDevicesWithCompletionBlock:(void (^)(Device* device))completionBlock
{
    self.didRetrieveDevice = completionBlock;
    [self findDevices];
}

+ (NSString*)preferredDeviceId
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPreferredDeviceId];
}

- (void)setPreferredDevice:(Device*)device
{
    [[NSUserDefaults standardUserDefaults] setObject:device.peripheral.identifier.UUIDString forKey:kPreferredDeviceId];
    [[NSUserDefaults standardUserDefaults] synchronize];
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
        if ([device.peripheral.identifier.UUIDString isEqualToString:self.class.preferredDeviceId]) {
            [self setPreferredDevice:device];
            [[NSNotificationCenter defaultCenter] postNotificationName:PreferredDeviceFoundNotification object:self userInfo:@{PreferredDeviceFoundNotificationDeviceKey: device}];
        }
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
//        [self lightWithPeripheral:peripheral];
        [self humidityWithPeripheral:peripheral];
    }
}

- (void)lightWithPeripheral:(CBPeripheral*)peripheral
{
    BKBlukiiDescription* lightDescription = [BKLightProfileLoader evaluatePeripheral:peripheral];
    BKLightProfileLoader* loader = [[BKLightProfileLoader alloc] init];
    [loader loadProfileForBlukii:lightDescription completeWith:^(BKBlukiiDeviceContext * __nullable context, NSError * __nullable error) {
        if(error == nil) {
            // Profile loaded successfully
            [context.light updateValue:^(CBCharacteristic * __nonnull characteristic, NSError * __nullable error) {
                
            }];
//            [context.light subscribeToEnabler:^(CBCharacteristic * __nonnull characteristic, NSError * __nullable error) {
//                
//            } callOnNotify:^(CBCharacteristic * __nonnull characteristic, NSError * __nullable error) {
//                
//            }];
        } else {
            // Error while loading profile
        }
    }];
}

- (void)humidityWithPeripheral:(CBPeripheral*)peripheral
{
    BKBatteryServiceProfileLoader* description = [BKBatteryServiceProfileLoader evaluatePeripheral:peripheral];
    BKHumidityProfileLoader* loader = [[BKHumidityProfileLoader alloc] init];
    [loader loadProfileForBlukii:description completeWith:^(BKBlukiiDeviceContext * __nullable context, NSError * __nullable error) {
        if(error == nil) {
            // Profile loaded successfully
            self.deviceContext = context;

            [context.humidity updateValue:^(CBCharacteristic * __nonnull characteristic, NSError * __nullable hError) {
                context.temperature.value
            }];
            //            [context.light subscribeToEnabler:^(CBCharacteristic * __nonnull characteristic, NSError * __nullable error) {
            //
            //            } callOnNotify:^(CBCharacteristic * __nonnull characteristic, NSError * __nullable error) {
            //
            //            }];
        } else {
            // Error while loading profile
        }
    }];
}

@end
