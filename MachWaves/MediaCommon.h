//
//  MediaCommon.h
//  Uploader
//
//  Created by CT Yeung on 1/15/14.
//  Copyright (c) 2014 acuo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DataModel.h"
#import "PopupCommon.h"

@interface MediaCommon : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>{}
@property (nonatomic, weak) UIImageView* pView;
@property(nonatomic, weak)UITextField* pText;
@property(nonatomic, weak)UIActivityIndicatorView* pSpinner;

@property(nonatomic, strong)PopupCommon *popup;
@property(nonatomic, strong)NSURL *assetURL;
@property(nonatomic, strong)NSString *mediaExt;

-(instancetype)initWith:(UIImageView*)mediaView And:(UITextField*)mediaName;
-(void) initPhotoLibraryViewIn:(UIViewController *) media;
-(void) initCameraViewIn:(UIViewController *) media;
@end
