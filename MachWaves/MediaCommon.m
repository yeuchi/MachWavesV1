//
//  MediaCommon.m
//  Uploader
//
//  Created by CT Yeung on 1/15/14.
//  Copyright (c) 2014 acuo. All rights reserved.
//

#import "MediaCommon.h"
#import <AssetsLibrary/ALAsset.h>   // wow !  poorly documented.
#import<AssetsLibrary/ALAssetsGroup.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import<AVFoundation/AVFoundation.h>

@implementation MediaCommon


/////////////////////////////////////////////////////////////
// Public Methods

-(instancetype)initWith:(UIImageView*)mediaView
                    And: (UITextField*)mediaName{
    self = [super init];
    _pView = mediaView;
   // _pText = mediaName;
    return self;
}

-(void) initPhotoLibraryViewIn:(UIViewController *) media {
    //http://stackoverflow.com/questions/7605845/how-to-load-photos-from-photo-gallery-and-store-it-into-application-project
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    _assetURL = nil;
    _pView.image=nil;
    
    // photo library
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    [media presentViewController:imagePickerController animated:YES completion:nil];
    [media dismissViewControllerAnimated:YES completion:nil];
}

-(void) initCameraViewIn:(UIViewController *) media {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    _assetURL = nil;
    _pView.image=nil;
    
    // camera source
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie,(NSString *)kUTTypeImage];
    [media presentViewController:imagePickerController animated:YES completion:nil];
    [media dismissViewControllerAnimated:YES completion:nil];
}


/////////////////////////////////////////////////////////////
// Helpers - move to their own view classes !


-(PopupCommon*)getPopupCommon {
    if(nil==_popup)
        self.popup = [[PopupCommon alloc]init];
    return _popup;
}

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    _pView.image = pickedImage; 
    
    UIImagePickerControllerSourceType pickerType = picker.sourceType;
    if(pickerType == UIImagePickerControllerSourceTypeCamera)
    {
        //http://stackoverflow.com/questions/10480170/how-to-select-any-video-or-movie-file-from-uiimagepickercontroller
        NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        _mediaExt = ( [mediaType isEqualToString:@"public.movie" ])?@"mov":@"png";
        _assetURL =  [info objectForKey:UIImagePickerControllerMediaURL];
        
        if(nil!=_assetURL)  // a video
        {
            [self generateVideoPoster];
        }
        //NSLog(@"mediaType: %@ url: %@", mediaType, [_assetURL absoluteString]);
        
        // camera - save image if configured to do so
       // CommonData *common = [CommonData sharedData];
        //if(true==common.onSave)
            [self writeFileFrom: mediaType];
    }
    else {
               // photo library
/*
        // test code below to find image name
        NSString *str = [info descriptionInStringsFileFormat];
        NSURL *imageFileURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        // Then get the file name.
        NSString *imageName = [imageFileURL lastPathComponent];
        NSLog(@"image name is %@", imageName); */
    }
}

-(void)generateVideoPoster {
    // create image and insert for view
    //http://stackoverflow.com/questions/15359007/avassetimagegenerator-not-generating-image-from-video-url
    AVURLAsset *as = [[AVURLAsset alloc] initWithURL:_assetURL options:nil];
    AVAssetImageGenerator *ima = [[AVAssetImageGenerator alloc] initWithAsset:as];
    NSError *err = NULL;
    CMTime time = CMTimeMake(0, 60);
    CGImageRef imgRef = [ima copyCGImageAtTime:time actualTime:NULL error:&err];
 
    _pView.image = [[UIImage alloc] initWithCGImage:imgRef];
}

/* rotate image
 // rotate image 180 degrees
 CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imgRef);
 CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imgRef);
 
 int targetHeight = CGImageGetWidth(imgRef);
 int targetWidth = CGImageGetWidth(imgRef);
 CGContextRef bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imgRef), CGImageGetBytesPerRow(imgRef), colorSpaceInfo, bitmapInfo);
 
 CGContextRotateCTM (bitmap, radians(180));
 
 CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imgRef);
 CGImageRef ref = CGBitmapContextCreateImage(bitmap);
 _pView.image = [UIImage imageWithCGImage:ref];
 
 CGContextRelease(bitmap);
 CGImageRelease(ref);
 
 */

-(void)displayWrite:(NSError*)error
               With:(NSURL*)url{
    NSString *err = NSLocalizedString(@"MEDIA_ERR_MSG", nil);
    NSLog(err, url, error);
    NSString *errorMsg = [error localizedDescription];
    
    if(nil==errorMsg || errorMsg.length==0) {
        NSString *success = NSLocalizedString(@"MEDIA_SUCCESS_MSG", nil);
        errorMsg = [NSString stringWithFormat:success, _pText.text];
    }
    
    PopupCommon *popup = [self getPopupCommon];
    NSString *saved = NSLocalizedString(@"Media saved.", nil);
    [popup displayPopUpWith:saved And: errorMsg];
}

-(void)writeFileFrom: (NSString*)mediaType  {
    //http://stackoverflow.com/questions/2172978/delete-a-photo-from-the-users-photo-library
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    NSArray *keys = [NSArray arrayWithObjects:@"mediaName", @"key2", nil];
    NSArray *objects = [NSArray arrayWithObjects:@"testimage.png", @"value2", nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:objects
                                                    forKeys:keys];
    
    if([_mediaExt isEqualToString:@"png"]){
        [library writeImageToSavedPhotosAlbum:_pView.image.CGImage metadata:dic completionBlock:^(NSURL *assetURL, NSError *error) {
            [self displayWrite:error With:assetURL];
        }];
    }
    else{
        [library writeVideoAtPathToSavedPhotosAlbum:_assetURL completionBlock:^(NSURL *assetURL, NSError *error) {
            [self displayWrite:error With:assetURL];
        }];
    }
}

-(void)displayNameRequestDialogWith: (NSString*)title {
    // Need a name for image
    //http://stackoverflow.com/questions/6319417/whats-a-simple-way-to-get-a-text-input-popup-dialog-box-on-an-iphone
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: title
                                                     message:NSLocalizedString(@"MEDIA_FILE_NAME", nil)
                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"MEDIA_CONTINUE", nil)
                                           otherButtonTitles:nil];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.placeholder = NSLocalizedString(@"MEDIA_ENTER_NAME", nil);
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //http://mobile.tutsplus.com/tutorials/iphone/ios-5-sdk-uialertview-text-input-and-validation/
    // all new media is saved unless told otherwise
    
    NSLog(@"alertView title: %@",alertView.title);
    NSString *mediaNew = NSLocalizedString(@"MEDIA_ENTER_NAME", nil);
    if([alertView.title isEqualToString:mediaNew]) {
        _pText.text = [[alertView textFieldAtIndex:0] text];
    }
}

@end
