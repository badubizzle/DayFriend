//
//  ChatTableViewController.h
//  Anon
//
//  Created by Aakash on 6/20/14.
//  Copyright (c) 2014 Aakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessagesViewController/JSQMessages.h"
#import <LayerKit/LayerKit.h>
#import "DFUserData.h"
#import "DFUser.h"

typedef void(^myCompletion)(NSString *);

@interface DFChatViewController : JSQMessagesViewController <LYRClientDelegate>{
    DFUserData *userData;
}

@property (nonatomic, retain) LYRClient *client;

@property (strong, nonatomic) DFUser *opponent;

@property (strong, nonatomic) NSMutableArray *messages;
@property (copy, nonatomic) NSDictionary *avatars;

@property (strong, nonatomic) UIImageView *outgoingBubbleImageView;
@property (strong, nonatomic) UIImageView *incomingBubbleImageView;
@property (strong, nonatomic) UIImage *friendImage;

@property (strong, nonatomic) UIImage *userImage;

//- (void)fetchBodiesWithProgress:(void ( ^ ) ( float percent ))progress completion:(void ( ^ ) ( NSError *error ))completion;
@end



