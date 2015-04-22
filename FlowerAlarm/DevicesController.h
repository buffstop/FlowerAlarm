//
//  DevicesController.h
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Device.h"

@interface DevicesController : NSObject
@property(nonatomic, assign, readonly)BOOL bluetoothEnabled;
@property(nonatomic, copy) void (^bluetoothStateChanged)(BOOL enabled);
- (void)setPreferredDevice:(Device*)device;
- (void)findDevicesWithCompletionBlock:(void (^)(Device* device))completionBlock;
@end
