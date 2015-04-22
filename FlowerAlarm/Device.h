//
//  Device.h
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CBPeripheral;

@interface Device : NSObject
@property(nonatomic, strong)CBPeripheral* peripheral;
@property(nonatomic, copy)NSString* name;
@end
