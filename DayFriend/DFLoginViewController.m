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
#import "DFProfileSetupViewController.h"
#import <LayerKit/LayerKit.h>
#import "DFViewController.h"

@interface DFLoginViewController () {
    DFUserData *userData;
    NSDictionary<FBGraphUser> *user;
    
    NSString *name;
    NSString *profileURL;
    NSString *coverURL;
    
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
    
    NSArray *permissionsArray = @[@"public_profile", @"email", @"user_friends", @"user_about_me",@"basic_info"];
    
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *puser, NSError *error) {
        if (error) {
            NSLog(@"Uh oh. An error occured: %@.", error);
        }
        if (puser.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    
                    user = (NSDictionary<FBGraphUser> *)result;
                    NSLog(@"user %@, %@", user.name, user.username);
                    NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200", [user objectID]];
                    NSString *coverImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=cover", [user username]];
                    userData.user.coverURL = coverImageURL;
                    userData.user.imageURL = userImageURL;
                    userData.user.userID = user.objectID;
                    userData.user.name = user.name;
                    userData.user.layerID = [userData.userDetails objectForKey:@"id"];
                    name = user.name;
                    profileURL = userImageURL;
                    coverURL = coverImageURL;
                    
                    NSLog(@"layer id: %@", [userData.userDetails objectForKey:@"id"] );
                    
                    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
                    currentInstallation[@"username"] = user.objectID;
                    [currentInstallation saveInBackground];
                    
                    [[PFUser currentUser] setObject:user.objectID forKey:@"User_ID"];
                    [[PFUser currentUser] setObject:user.name forKey:@"User_Name"];
                    // [[PFUser currentUser] setObject:layerAddress forKey:@"Layer_Address"];
                    [[PFUser currentUser] setObject:[user objectForKey:@"email"] forKey:@"email"];
                    [[PFUser currentUser] setObject:[userData.userDetails objectForKey:@"id"]  forKey:@"Layer_ID"];
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:user.objectID forKey:@"userID"];
                      //  [defaults setObject:[userAddress stringRepresentation] forKey:@"userAddress"];
                        NSDictionary *dict = [user mutableCopy];
                        
                        NSData *userDataObject = [NSKeyedArchiver archivedDataWithRootObject:userData.user];
                        [defaults setObject:userDataObject forKey:@"user"];
                        
                        NSData *details = [NSKeyedArchiver archivedDataWithRootObject:userData.userDetails];
                        [defaults setObject:details forKey:@"userDetails"];
                        [defaults synchronize];
                        
                        [self nextViewController];
                        }];
                        
                    }
            }];
        }
            else {
            NSLog(@"User with facebook logged in!");
                [self nextViewController];
        }
    }];
        

}



-(void)nextViewController{
    [self performSegueWithIdentifier:@"PushProfile" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   DFProfileSetupViewController *profileVC = [segue destinationViewController];
    profileVC.name = name;
    profileVC.profileImageURL = profileURL;
    profileVC.coverImageURL = coverURL;

}

@end
