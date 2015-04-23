//
//  BoardViewController.m
//  FlowerAlarm
//
//  Created by François Benaiteau on 22/04/15.
//  Copyright (c) 2015 CockieMonster. All rights reserved.
//

#import "BoardViewController.h"

NSString *const kImageFilename = @"myFlower.png";

@interface BoardViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, DeviceInfosDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *flowerImageView;
@property (nonatomic, strong)UIImage* storedImage;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation BoardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.setupImage = YES;
    __weak __typeof(&*self)weakSelf = self;
    self.devicesController.delegate = self;
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
    [self prepareImageIfNeeded];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PreferredDeviceFoundNotification object:nil];
    
}
#pragma mark -

- (void)prepareImageIfNeeded
{
    if (self.setupImage) {
        [self restoreImage];
        
        if (self.storedImage) {
            self.flowerImageView.image = self.storedImage;
        }else {
            [self performSegueWithIdentifier:@"selectFlower" sender:self];
        }
        self.setupImage = NO;
    }
}

-(void)didRetreivePreferredDevice:(NSNotification*)notification
{
    
}

- (void)restoreImage
{
    self.storedImage = [NSKeyedUnarchiver unarchiveObjectWithFile:[self imagePath]];
}

- (void)saveImage:(UIImage*)image
{
    if ([NSKeyedArchiver archiveRootObject:image toFile:[self imagePath]]) {
        self.storedImage = image;
    }
}

- (NSString*)imagePath
{
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    return [documentsPath stringByAppendingPathComponent:kImageFilename];
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
        [picker dismissViewControllerAnimated:YES completion:^{
            [self saveImage:selectedImage];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - DeviceInfosDelegate

- (void)statusDidChange:(NSString*)message
{
    self.statusLabel.text = message;
}
@end
