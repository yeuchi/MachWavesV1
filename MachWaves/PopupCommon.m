//
//  PopupCommon.m
//  Uploader
//
//  Created by CT Yeung on 1/17/14.
//
// Copyright (c) 2014 C.T. Yeung. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file. See the AUTHORS file for names of contributors.
//

#import "PopupCommon.h"

@implementation PopupCommon
-(void)displayPopUpWith: (NSString*)title
                    And: (NSString*) message {
    
    // something bad happend, show a dialog
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle: title
                                                     message: message
                                                    delegate:self cancelButtonTitle:NSLocalizedString(@"MEDIA_CONTINUE", nil)
                                           otherButtonTitles:nil];
    [alert show];
}

@end
