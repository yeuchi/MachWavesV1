//
//  DataModel.h
//  MachWaves
//
//  Created by yeuchi on 5/10/14.
//
// Copyright (c) 2014 C.T. Yeung. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file. See the AUTHORS file for names of contributors.
//

#import <Foundation/Foundation.h>

@interface DataModel : NSObject

@property(readwrite,assign) BOOL onSave;                // auto-save ? (true or false)
@property (nonatomic, strong) NSString *namePrefix;

+ (id)sharedData;
-(void)resetStudyVars;

@end
