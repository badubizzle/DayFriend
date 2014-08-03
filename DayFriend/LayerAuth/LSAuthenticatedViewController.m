//
//  LSAuthenticatedViewController.m
//  LayerSample
//
//  Created by Kevin Coleman on 8/2/14.
//  Copyright (c) 2014 Layer, Inc. All rights reserved.
//

#import "LSAuthenticatedViewController.h"

@interface LSAuthenticatedViewController ()

@end

@implementation LSAuthenticatedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = logoutButton;
}

- (void)logout
{
    [self.APIManager deauthenticateWithCompletion:^(BOOL success, NSError *error) {
        NSLog(@"Deauthenticated...");
    }];
}

@end
