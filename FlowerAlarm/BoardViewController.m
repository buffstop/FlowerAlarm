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

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.flowerImageView.image == nil) {
        [self performSegueWithIdentifier:@"selectFlower" sender:self];
    }
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
