//
//  DataModel.h
//  MachWaves
//
//  Created by yeuchi on 5/10/14.
//  Copyright (c) 2014 yeuchi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(readwrite,assign) BOOL onSave;                // auto-save ? (true or false)
@property (nonatomic, strong) NSString *namePrefix;

+ (id)sharedData;
-(void)resetStudyVars;

@end
