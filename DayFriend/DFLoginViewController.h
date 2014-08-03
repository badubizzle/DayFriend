//
//  DFLoginViewController.h
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAPIManager.h"

@interface DFLoginViewController : UIViewController

- (IBAction)loginFacebook:(id)sender;

@property (nonatomic, strong) LSAPIManager *APIManager;

@end
