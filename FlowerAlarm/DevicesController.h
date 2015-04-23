//
//  DevicesController.h
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"
@protocol DeviceInfosDelegate

- (void)statusDidChange:(NSString*)message;
@end

extern NSString *const PreferredDeviceFoundNotification;

extern NSString *const PreferredDeviceFoundNotificationDeviceKey;
@interface DevicesController : NSObject
@property(nonatomic, weak)id<DeviceInfosDelegate> delegate;
@property(nonatomic, assign, readonly)BOOL bluetoothEnabled;
@property(nonatomic, copy) void (^bluetoothStateChanged)(BOOL enabled);

- (void)restorePreferredDevice;

- (void)setPreferredDevice:(Device*)device;
- (void)findDevicesWithCompletionBlock:(void (^)(Device* device))completionBlock;
+ (NSString*)preferredDeviceId;
@end
