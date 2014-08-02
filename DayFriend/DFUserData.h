//
//  DFUserData.h
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFUser.h"

@interface DFUserData : NSObject

@property (nonatomic,retain) DFUser *user;
@property (nonatomic) NSInteger interactions;
+ (id)sharedManager;

@end
