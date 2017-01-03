//
//  iPadCameraViewController.m
//  MachWaves
//
//  Created by yeuchi on 3/9/14.
//  Copyright (c) 2014 yeuchi. All rights reserved.
//

#import "iPadCameraViewController.h"
#import <AssetsLibrary/ALAsset.h>   // wow !  poorly documented.
#import <AssetsLibrary/ALAssetsGroup.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "CustomUIView.h"
#import "MediaCommon.h"

@interface iPadCameraViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *machNum;
@property (strong, nonatomic) IBOutlet UILabel *angle;
@property(nonatomic, strong)MediaCommon *common;
@property (strong, nonatomic) IBOutlet CustomUIView *overlay;

@end

@implementation iPadCameraViewController

#pragma mark - Event handlers
- (IBAction)onClickButtonCamera:(UIButton *)sender {
    MediaCommon *common = [self getMediaCommon];
    [common initCameraViewIn:self];
}

- (IBAction)onClickButtonBack:(UIButton *)sender {
    [_overlay clearRect];
}

-(MediaCommon*) getMediaCommon {
    if(nil==_common)
        _common = [[MediaCommon alloc]initWith:_imageView
                                           And:nil];
    
    return _common;
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
    
    [_imageView.layer setBorderColor: [[UIColor blueColor] CGColor]];
    [_imageView.layer setBorderWidth: 2.0];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.overlay setOpaque:NO];
    [self.overlay setUserInteractionEnabled:true];
    [self.overlay initCalculatorWith:_angle And:_machNum];
    self.overlay.backgroundColor = [UIColor colorWithWhite:1.0  alpha:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
