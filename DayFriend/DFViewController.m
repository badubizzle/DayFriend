//
//  DFViewController.m
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFViewController.h"
#import "DFLoginViewController.h"
#import <Parse/Parse.h>

@interface DFViewController (){
}

@end

@implementation DFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

if(![self isSignedUp]){
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DFLoginViewController *loginVC = (DFLoginViewController*)[storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    [self presentViewController:loginVC animated:NO completion:nil];
}
//if(![client isUserAuthenticated] && [defaults objectForKey:@"userID"]){
//    [client logoutWithCompletion:^(NSError *error){
//        [self loginLayerUser:[defaults objectForKey:@"userID"]];
//    }];
//    

}

-(void)viewDidAppear:(BOOL)animated{
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(BOOL)isSignedUp{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userID"]){
        return YES;
    }
    else{
        return NO;
    }
}


@end
