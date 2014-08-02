//
//  DFLayerController.m
//  DayFriend
//
//  Created by Spencer Yen on 8/2/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFLayerController.h"

@implementation DFLayerController

// The only required LYRClientDelegate method. Called when LayerKit receives an
// authentication challenge. Method implmentation should attempt to reauthenticate
// LayerKit. See the Layer Authentication Guide for more information on an authentication
// challenge.
-(void)layerClient:(LYRClient *)client didReceiveAuthenticationChallengeWithNonce:(NSString *)nonce{
    NSLog(@"Client Did Receive Authentication Challenge with Nonce %@ in DFLayerController", nonce);
    
}
// Called when your application has succesfully authenticated a user via LayerKit
- (void)layerClient:(LYRClient *)client didAuthenticateAsUserID:(NSString *)userID
{
    NSLog(@"Client Did Authenticate As %@ in DFLayerController", userID);
}

// Called when you succesfully logout a user via LayerKit
- (void)layerClientDidDeauthenticate:(LYRClient *)client
{
    NSLog(@"Client did deauthenticate the user in DFLayerController");
}

@end