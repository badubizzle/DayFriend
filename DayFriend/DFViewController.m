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
#import "DFUser.h"
#import "UIImageView+WebCache.h"
#import "DFUserData.h"
#import "DFChatViewController.h"
#import "ALDBlurImageProcessor.h"

@interface DFViewController (){
    ALDBlurImageProcessor *blurImageProcessor;
    DFUser *dayFriend;
    DFUserData *userData;
}

@end

@implementation DFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    userData = [DFUserData sharedManager];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:@"user"];
    userData.user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];

    userData.userDetails =[NSKeyedUnarchiver unarchiveObjectWithData:[defaults objectForKey:@"userDetails"]];

   [_selfProfileImage sd_setImageWithURL:[NSURL URLWithString:userData.user.imageURL]];
    [_selfCoverImage setImage:[UIImage imageNamed:@"friendArt.png"]];
    blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage: _selfCoverImage.image];
    
    [blurImageProcessor asyncBlurWithRadius: 8
                                 iterations: 7
                               successBlock: ^(UIImage *blurredImage) {
                                   _selfCoverImage.image = blurredImage;
                               }
                                 errorBlock: ^( NSNumber *errorCode ) {
                                     NSLog( @"Error code: %d", [errorCode intValue] );
                                 }];



}


-(void)viewDidAppear:(BOOL)animated{
    [self getFBFriends];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

-(void)getFBFriends{
    [FBRequestConnection startWithGraphPath:@"/me/friends"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                              NSMutableArray *friends = [result objectForKey:@"data"];
                              NSDictionary<FBGraphUser>* friend = [friends firstObject];
                              NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=200&height=200", [friend objectID]];
                              NSString *coverImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@?fields=cover", [friend username]];

                              dayFriend = [[DFUser alloc]initWithID:friend.objectID withAddress:nil andName:friend.name withImageURL:userImageURL andCoverURL:coverImageURL andAbout:nil];
                      
                              PFQuery *friendQuery = [PFUser query];
                              [friendQuery whereKey:@"User_ID" equalTo:friend.objectID];
                              
                              [friendQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                  if (!error) {
                                      PFObject *object = [objects firstObject];
                                      dayFriend.layerID = object[@"Layer_ID"];
                                      [_dayFriendProfileImage sd_setImageWithURL:[NSURL URLWithString:userImageURL]];
                                      [_dayFriendCoverImage setImage:[UIImage imageNamed:@"coverPhoto2.jpg"]];
                                      blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage: _dayFriendCoverImage.image];

                                      [blurImageProcessor asyncBlurWithRadius: 8
                                                                   iterations: 7
                                                                 successBlock: ^(UIImage *blurredImage) {
                                                                     _dayFriendCoverImage.image = blurredImage;
                                                                 }
                                                                   errorBlock: ^( NSNumber *errorCode ) {
                                                                       NSLog( @"Error code: %d", [errorCode intValue] );
                                                                   }];
                                  } else {
                                      NSLog(@"Error: %@ %@", error, [error userInfo]);
                                  }
                              }];

                          }];
    
    
    
}


- (IBAction)pushChat:(id)sender {
    [self performSegueWithIdentifier:@"ModalChat" sender:self];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DFChatViewController *chatVC = [[[segue destinationViewController] viewControllers] objectAtIndex:0];
    chatVC.client = userData.client;
    chatVC.opponent = dayFriend;
    
}
@end
