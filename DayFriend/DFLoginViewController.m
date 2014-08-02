//
//  DFLoginViewController.m
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFLoginViewController.h"
#import <Parse/Parse.h>
#import "DFUserData.h"
@interface DFLoginViewController () {
    DFUserData *userData;
    NSDictionary<FBGraphUser> *user;
}

@end

@implementation DFLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    userData = [DFUserData sharedManager];
}

- (IBAction)loginFacebook:(id)sender {
    // The permissions requested from the user
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *puser, NSError *error) {
        if (error) {
            NSLog(@"Uh oh. An error occured: %@.", error);
        }
        if (puser.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    
                    user = (NSDictionary<FBGraphUser> *)result;
                    NSLog(@"user %@", user.objectID);
                    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [user objectID]];
                    NSString *coverImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=cover", [user username]];
                    userData.user.coverURL = coverImageURL;
                    userData.user.imageURL = userImageURL;
                    userData.user.userID = user.objectID;
                    userData.user.name = user.name;
                    // Store the Facebook Id
                    //  [self signUpLayerUserWithID:user.objectID completion:^(NSString *layerAddress) {
                    //    if(layerAddress){
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    currentInstallation[@"username"] = user.objectID;
                    [currentInstallation saveInBackground];
                    
                    [[PFUser currentUser] setObject:user.objectID forKey:@"User_ID"];
                    [[PFUser currentUser] setObject:user.name forKey:@"User_Name"];
                    // [[PFUser currentUser] setObject:layerAddress forKey:@"Layer_Address"];
                    [[PFUser currentUser] setObject:[user objectForKey:@"email"] forKey:@"email"];
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:@"YES" forKey:@"loggedIn"];
                        //[defaults setObject:FBID forKey:@"userID"];
                        //   [defaults setObject:[userAddress stringRepresentation] forKey:@"userAddress"];
                        [defaults synchronize];
                        // }];
                        
                        //                        }
                    }];
                }
            }];
        }
        else {
            NSLog(@"User with facebook logged in!");
        }
    }];

}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [segue destinationViewController];
    
}

@end
