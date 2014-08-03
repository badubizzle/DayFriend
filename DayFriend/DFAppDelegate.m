//
//  DFAppDelegate.m
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFAppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "DFUserData.h"

#import <LayerKit/LayerKit.h>
#import "LSAPIManager.h"
#import "LSUtilities.h"
#import "LSUIConstants.h"
#import "LSPersistenceManager.h"
#import "LSApplicationController.h"
#import "LSAuthenticatedViewController.h"

#import "DFViewController.h"
#import "DFLoginViewController.h"

extern void LYRSetLogLevelFromEnvironment();

@interface DFAppDelegate ()

@property (nonatomic) UINavigationController *navigationController;
@property (nonatomic, strong) LSApplicationController *applicationController;

@end

@implementation DFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"wWQsNA6AIq1n8z1jyuBe1Lfer1P8dWpKohJ7nxbs"
                  clientKey:@"K5VJnOzNzUIfUL1lyR3anH3L45C6QCPNSLfS8Zts"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    NSUUID *appID = [[NSUUID alloc] initWithUUIDString:@"ebe4a60e-19c1-11e4-b957-a19800003b1a"];
    DFUserData *ud = [DFUserData sharedManager];
   ud.client = [LYRClient clientWithAppID:appID];

    // HackLayer sample leverages NSNotification center to alert the app delegate to changes in authentication state
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidAuthenticateNotification:)
                                                 name:LSUserDidAuthenticateNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidDeauthenticateNotification:)
                                                 name:LSUserDidDeauthenticateNotification
                                               object:nil];
    // Adds the notification observer
       
    self.applicationController = ApplicationController(ud.client);
    
    [ud.client connectWithCompletion:^(BOOL success, NSError *error) {
        //
    }];
    LYRSetLogLevelFromEnvironment();
    
    LSAuthenticationViewController *authenticationViewController = [LSAuthenticationViewController new];
    authenticationViewController.layerClient = ud.client;
    authenticationViewController.APIManager = self.applicationController.APIManager;
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:authenticationViewController];
    self.navigationController.navigationBarHidden = TRUE;
    self.navigationController.navigationBar.barTintColor = LSLighGrayColor();
    self.navigationController.navigationBar.tintColor = LSBlueColor();
    self.window.rootViewController = self.navigationController;
    
    LSSession *session = [self.applicationController.persistenceManager persistedSessionWithError:nil];
    // Checks to see if the user is already authenticated
    NSError *error = nil;
    if ([self.applicationController.APIManager resumeSession:session error:&error]) {
        NSLog(@"Session resumed: %@", session);
        [self presentAuthenticatedUI];
    }
    
    [self.window makeKeyAndVisible];
    
    // Declaring that I want to recieve push!
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
    
    return YES;
}

- (void)presentAuthenticatedUI
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DFLoginViewController *viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginView"];
    viewController.APIManager = self.applicationController.APIManager;
    if([self isSignedUp]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        DFViewController *vc = (DFViewController*)[storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        self.window.rootViewController = vc;
    }else{
    
    self.window.rootViewController = viewController;
    }

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



- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Application failed to register for remote notifications with error %@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSError *error;
    BOOL success = [self.applicationController.layerClient updateRemoteNotificationDeviceToken:deviceToken error:&error];
    if (success) {
        NSLog(@"Application did register for remote notifications");
    } else {
        NSLog(@"Error updating Layer device token for push:%@", error);
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSError *error;
    BOOL success = [self.applicationController.layerClient synchronizeWithRemoteNotification:userInfo completion:^(UIBackgroundFetchResult fetchResult, NSError *error) {
        if (fetchResult == UIBackgroundFetchResultFailed) {
            NSLog(@"Failed processing remote notification: %@", error);
        }
        completionHandler(fetchResult);
    }];
    if (success) {
        NSLog(@"Application did remote notification sycn");
    } else {
        NSLog(@"Error handling push notification: %@", error);
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

// Notifies the app delegate that the user has authenticated
- (void)userDidAuthenticateNotification:(NSNotification *)notification
{
    NSError *error = nil;
    LSSession *session = self.applicationController.APIManager.authenticatedSession;
    BOOL success = [self.applicationController.persistenceManager persistSession:session error:&error];
    if (success) {
        NSLog(@"Persisted authenticated user session: %@", session);
    } else {
        NSLog(@"Failed persisting authenticated user: %@. Error: %@", session, error);
        LSAlertWithError(error);
    }
    
    [self presentAuthenticatedUI];
}

// Notifies the app delegate that the user has been deauthenticated
- (void)userDidDeauthenticateNotification:(NSNotification *)notification
{
    NSError *error = nil;
    BOOL success = [self.applicationController.persistenceManager persistSession:nil error:&error];
    if (success) {
        NSLog(@"Cleared persisted user session");
    } else {
        NSLog(@"Failed clearing persistent user session: %@", error);
        LSAlertWithError(error);
    }
    
    [self.applicationController.layerClient deauthenticate];
    [self.navigationController dismissViewControllerAnimated:YES completion:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
