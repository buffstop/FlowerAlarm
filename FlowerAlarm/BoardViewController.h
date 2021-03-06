//
//  BoardViewController.h
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DevicesController.h"


@interface BoardViewController : UIViewController
@property (strong, nonatomic) DevicesController *devicesController;
@property (nonatomic, assign)BOOL setupImage;
@end
