//
//  DFProfileSetupViewController.h
//  DayFriend
//
//  Created by Spencer Yen on 8/2/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFProfileSetupViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *helloNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UITextField *aboutTextfield;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *coverImageURL;
@property (strong, nonatomic) NSString *name;

- (IBAction)doneButton:(id)sender;

@end
