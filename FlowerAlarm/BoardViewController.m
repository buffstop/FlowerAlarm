//
//  BoardViewController.m
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import "BoardViewController.h"



@interface BoardViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *flowerImageView;

@end

@implementation BoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    __weak __typeof(&*self)weakSelf = self;
    [self.devicesController setBluetoothStateChanged:^(BOOL enabled) {
        [weakSelf restoreDevice];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRetreivePreferredDevice:) name:PreferredDeviceFoundNotification object:nil];
    [self restoreDevice];
}

- (void)restoreDevice
{
    if ([DevicesController preferredDeviceId]) {
        [self.devicesController restorePreferredDevice];
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.flowerImageView.image == nil) {
        [self performSegueWithIdentifier:@"selectFlower" sender:self];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PreferredDeviceFoundNotification object:nil];

}
#pragma mark -

-(void)didRetreivePreferredDevice:(NSNotification*)notification
{

}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIImagePickerController *pickerController = segue.destinationViewController;
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    pickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* selectedImage = info[UIImagePickerControllerOriginalImage];
    if (selectedImage) {
        self.flowerImageView.image = selectedImage;
        // store image;
        [picker dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
