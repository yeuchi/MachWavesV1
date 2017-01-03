//
//  CustomUIView.m
//  MachWaves
//
//  Created by yeuchi on 5/23/14.
//
// Copyright (c) 2014 C.T. Yeung. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file. See the AUTHORS file for names of contributors.
//

#import "CustomUIView.h"

//http://stackoverflow.com/questions/15496753/how-to-detect-touch-on-uiimageview-and-draw-line
@implementation CustomUIView
{
    CGPoint p0;
    CGPoint p1;
    
    CGPoint q0; // your fist touch detected in touchesBegan: method
    CGPoint q1; // the position you have dragged your finger to
    CGFloat _strokeWidth; // the width of the line you wish to draw
    id _touchStartedObject; // the object(UIView) that the first touch was detected on
}

- (void)initCalculatorWith:(UILabel*)angle
                       And:(UILabel*)machNum
{
    _angle = angle;
    _machNum = machNum;
    
    _strokeWidth = 2.0;
    
    self.listPts = [[NSMutableArray alloc] init];
}

#pragma mark - Touch event handlers
- (void)touchesBegan:(NSSet *)touches
           withEvent:(UIEvent *)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    q0 = touchPoint;
    _touchStartedObject = [[touches anyObject] view];
    
    NSLog(@"Touch x : %f y : %f", touchPoint.x, touchPoint.y);
    
    // insert points
    [self.listPts addObject:[NSValue valueWithCGPoint:touchPoint]];
}

- (void)touchesMoved:(NSSet *)touches
           withEvent:(UIEvent *)event{
    
    CGPoint movedToPoint = [[touches anyObject] locationInView:self];
    NSLog(@"Touch x : %f y : %f", movedToPoint.x, movedToPoint.y);
    
    // if moved to a new point redraw the line
    if ( CGPointEqualToPoint( movedToPoint, q1 ) == NO )
    {
        q1 = movedToPoint;
        
        // calls drawRect: method to show updated line
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches
           withEvent:(UIEvent *)event{
    
    // insert points
    q1 = [[touches anyObject] locationInView:self];
    [self.listPts addObject:[NSValue valueWithCGPoint:q1]];
    
    if(_listPts.count==2){
        p0 = q0;
        p1 = q1;
    }
    else if(_listPts.count>=4){
        [self findAngle];
        [self findMachNumber];
        [_listPts removeAllObjects];
        
        p0 = CGPointZero;
        p1 = CGPointZero;
    }
    
    // reset values
    q0 = CGPointZero;
    q1 = CGPointZero;
    _touchStartedObject = nil;
}

-(void)clearRect
{
    [_listPts removeAllObjects];
    
    p0 = CGPointZero;
    p1 = CGPointZero;
    
    q0 = CGPointZero;
    q1 = CGPointZero;
    [self setNeedsDisplay];
    
    _angle.text = @"0.00 degree";
    _machNum.text = @"0.00";
    
    /*
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGPoint origin = self.frame.origin;
    CGSize size = self.frame.size;
    CGRect rect = CGRectMake(origin.x, origin.y, size.width, size.height);
    CGContextClearRect(context, rect);
     */
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context    = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor( context, [UIColor blueColor].CGColor );
    CGContextSetLineWidth( context, _strokeWidth );
    
    if(_listPts.count>2 && p0.x != p1.x && p0.y != p1.y) {
        CGContextMoveToPoint( context, p0.x, p0.y );
        CGContextAddLineToPoint( context, p1.x, p1.y );
    }
    
    // fisrt point of line
    CGContextMoveToPoint( context, q0.x, q0.y );
    // last point of line
    CGContextAddLineToPoint( context, q1.x, q1.y );
    // draw the line
    CGContextStrokePath( context );
}

/*
- (void)touchesCancelled:(NSSet *)touches
               withEvent:(UIEvent *)event{
    
}*/

-(void)findAngle{
    float ax = p0.x - p1.x;
    float ay = p0.y - p1.y;
    
    float bx = q0.x - q1.x;
    float by = q0.y - q1.y;
    
    radian = (float)acos( (ax*bx + ay*by) / (sqrt(ax*ax+ay*ay)*sqrt(bx*bx+by*by)));
    degrees = (float) (180 * radian / M_PI);
    NSString* str = [NSString stringWithFormat:@"%.3f degree", degrees];
    _angle.text = str;
}

-(void)findMachNumber{
    float MachNum = (float) (1.0 / sin(radian/2));
    NSString*str = [NSString stringWithFormat:@"%.3f", MachNum];
    _machNum.text = str;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
