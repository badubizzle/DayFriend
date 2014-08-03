//
//  DFUserData.m
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFUserData.h"

@implementation DFUserData
@synthesize user;
@synthesize interactions;
@synthesize userDetails;
@synthesize client;

+ (id)sharedManager {
    static DFUserData *userData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userData = [[self alloc] init];
        
    });
    return userData;
}
- (id)init {
    if (self = [super init]) {
        user = [[DFUser alloc] init];
    }
    return self;
}
@end