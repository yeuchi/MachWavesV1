//
//  DataModel.m
//  MachWaves
//
//  Created by yeuchi on 5/10/14.
//  Copyright (c) 2014 yeuchi. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

@synthesize namePrefix;
@synthesize onSave;

+ (id)sharedData {
    static DataModel *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)resetStudyVars {
    namePrefix = @"";
}

- (id)init {
    self = [super init];
    
    // parameters to be added to property list ?
    namePrefix = @"MWphoto";
    onSave = true;
    
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}
@end
