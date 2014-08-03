//
//  DFViewController.h
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAPIManager.h"
@interface DFViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *dayFriendCoverImage;
@property (weak, nonatomic) IBOutlet UIImageView *dayFriendProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *selfProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *selfCoverImage;

@property (nonatomic, strong) LSAPIManager *APIManager;

- (IBAction)pushChat:(id)sender;

@end
