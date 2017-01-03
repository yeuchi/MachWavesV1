//
//  iPhoneCameraViewController.m
//  MachWaves
//
//  Created by yeuchi on 4/6/14.
//
// Copyright (c) 2014 C.T. Yeung. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file. See the AUTHORS file for names of contributors.
//

#import "iPhoneCameraViewController.h"
#import <AssetsLibrary/ALAsset.h>   // wow !  poorly documented.
#import <AssetsLibrary/ALAssetsGroup.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>

@interface iPhoneCameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
//@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation iPhoneCameraViewController

#pragma mark - Event handlers
- (IBAction)onClickCamera:(UIButton *)sender {
    // Camera selection
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    _assetURL = nil;
    _imageView.image=nil;
    
    // camera source
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    [self presentViewController:imagePickerController animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onClickBack:(UIButton *)sender {
    [_imageView setUserInteractionEnabled:NO];
}

#pragma mark - Gesture functions
//http://stackoverflow.com/questions/15496753/how-to-detect-touch-on-uiimageview-and-draw-line
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    //To get tag of touch view
   // int viewTag=[touch view].tag;
    
    if ([[touch view] isKindOfClass:[UIImageView class]])
    {
        //Write your code...
    }
}
/*
// Respond to a swipe gesture
- (IBAction)showGestureForSwipeRecognizer:(UISwipeGestureRecognizer *)recognizer {
    // Get the location of the gesture
    CGPoint location = [recognizer locationInView:self.view];
    
    // Display an image view at that location
    [self drawLineForGestureRecognizer:recognizer atPoint:location];

    // If gesture is a left swipe, specify an end location
    // to the left of the current location
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 220.0;
    } else {
        location.x += 220.0;
    }
    
    // Animate the image view in the direction of the swipe as it fades out
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.alpha = 0.0;
        self.imageView.center = location;
    }];
}

- (void)drawLineForGestureRecognizer:(UIGestureRecognizer *)recognizer
                             atPoint:(CGPoint)centerPoint {
    

    
}
*/
#pragma mark - Helper functions
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [_imageView setUserInteractionEnabled:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _imageView.image = pickedImage;
    
    UIImagePickerControllerSourceType pickerType = picker.sourceType;
    if(pickerType == UIImagePickerControllerSourceTypeCamera)
    {
        //http://stackoverflow.com/questions/10480170/how-to-select-any-video-or-movie-file-from-uiimagepickercontroller
        NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        _assetURL =  [info objectForKey:UIImagePickerControllerMediaURL];
        
        [self writeFileFrom: mediaType];
    }
}

-(void)writeFileFrom: (NSString*)mediaType  {
    //http://stackoverflow.com/questions/2172978/delete-a-photo-from-the-users-photo-library
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSArray *keys = [NSArray arrayWithObjects:@"mediaName", @"key2", nil];
    NSArray *objects = [NSArray arrayWithObjects:_assetURL, @"value2", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:objects
                                                    forKeys:keys];
    
    
    [library writeImageToSavedPhotosAlbum:_imageView.image.CGImage metadata:dic completionBlock:^(NSURL *assetURL, NSError *error) {
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Save"
                                                         message: [error localizedDescription]
                                                        delegate:self cancelButtonTitle:@"continue"
                                               otherButtonTitles:nil];
        [alert show];
    }];
}

#pragma mark - XCode Default code
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
