//
//  DFProfileSetupViewController.m
//  DayFriend
//
//  Created by Spencer Yen on 8/2/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFProfileSetupViewController.h"
#import "UIImageView+WebCache.h"
#import "DFUserData.h"
#import <QuartzCore/QuartzCore.h>

@interface DFProfileSetupViewController ()

@end

@implementation DFProfileSetupViewController{
    DFUserData *userData;
}

@synthesize helloNameLabel;
@synthesize coverImage;
@synthesize profileImage;
@synthesize aboutTextfield;
@synthesize doneButton;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    helloNameLabel.text = [NSString stringWithFormat:@"Hello, %@", _name];
    [coverImage sd_setImageWithURL:[NSURL URLWithString:_coverImageURL]];
    [profileImage sd_setImageWithURL:[NSURL URLWithString:_profileImageURL]];
    
    profileImage.layer.cornerRadius = profileImage.frame.size.width / 2;
    profileImage.layer.borderColor = [UIColor whiteColor].CGColor;
    profileImage.layer.borderWidth = 5.0;
    
    doneButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


-(void)textFieldDidEndEditing:(UITextField *)textField {
    doneButton.hidden = NO;
    userData.user.aboutString = textField.text;
}

- (IBAction)doneButton:(id)sender {
    [self performSegueWithIdentifier:@"PushOnboarding" sender:self];
}
@end
