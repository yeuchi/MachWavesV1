//
//  CustomUIView.h
//  MachWaves
//
//  Created by yeuchi on 5/23/14.
//  Copyright (c) 2014 yeuchi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomUIView : UIView{
@private
    float radian;
    float degrees;
}
@property(strong, nonatomic)NSMutableArray *listPts;

@property(weak, nonatomic)UILabel *angle;
@property(weak, nonatomic)UILabel *machNum;

-(void)initCalculatorWith:(UILabel*)angle
                      And:(UILabel*)machNum;
-(void)clearRect;

@end
