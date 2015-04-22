//
//  DeviceSelectionViewController.m
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import "DeviceSelectionViewController.h"

#import "DevicesController.h"
#import "BoardViewController.h"

@interface DeviceSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet DevicesController *devicesController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSMutableArray* devices;
@end

static NSString *const kCellIdentifier = @"deviceCell";

@implementation DeviceSelectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.devices = [[NSMutableArray alloc] init];
    __weak __typeof(&*self)weakSelf = self;
    [self.devicesController setBluetoothStateChanged:^(BOOL enabled) {
        [weakSelf updateDevices];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateDevices];
}

- (void)updateDevices
{
    __weak __typeof(&*self)weakSelf = self;
    self.tableView.hidden = !self.devicesController.bluetoothEnabled;
    if (!self.tableView.hidden) {
        [self.devices removeAllObjects];
        [self.devicesController findDevicesWithCompletionBlock:^(Device* device){
            [weakSelf.devices addObject:device];
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text = [self.devices[indexPath.row] name];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Device* device = self.devices[indexPath.row];
    [self.devicesController setPreferredDevice:device];
    [self showBoard];
}

#pragma mark - Navigation

- (void)showBoard
{
    [self performSegueWithIdentifier:@"showBoard" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BoardViewController* boardVC = (BoardViewController*)segue.destinationViewController;
    boardVC.devicesController = self.devicesController;
}
@end
