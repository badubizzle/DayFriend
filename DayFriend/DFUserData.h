//
//  DFUserData.h
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFUser.h"
#import <LayerKit/LayerKit.h>

@interface DFUserData : NSObject

@property (nonatomic,retain) DFUser *user;
@property (nonatomic) NSInteger interactions;
@property (nonatomic, retain) NSDictionary *userDetails;
@property (nonatomic, retain) LYRClient *client;
+ (id)sharedManager;

@end
