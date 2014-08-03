//
//  DFChatViewController.m
//  DayFriend
//
//  Created by Spencer Yen on 8/2/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFChatViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import <Parse/Parse.h>

@interface DFChatViewController ()

@end

@implementation DFChatViewController {
    LYRConversation *conversation;
    NSOrderedSet *lyrMessages;
}

@synthesize client;
@synthesize opponent;
- (void)viewDidLoad
{
    [super viewDidLoad];
 
    if([client conversationForParticipants:@[opponent.layerID]]){
        conversation = [client conversationForParticipants:@[opponent.layerID]];

    }else{
        conversation = [LYRConversation conversationWithParticipants:@[opponent.layerID]];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLayerObjectsDidChangeNotification:)
                                                 name:LYRClientObjectsDidChangeNotification object:client];
    
    userData = [DFUserData sharedManager];
    lyrMessages = [client messagesForConversation:conversation];
    
    
    //UI stuff
    [self.navigationItem setTitle:@"DayFriend"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    NSURL *imageURL = [NSURL URLWithString:opponent.imageURL]  ;
    
    CGFloat incomingDiameter = self.collectionView.collectionViewLayout.incomingAvatarViewSize.width;
    _friendImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]]
                                                    diameter:incomingDiameter];
    _userImage = [JSQMessagesAvatarFactory avatarWithImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userData.user.imageURL]]]
                                                    diameter:incomingDiameter];
    
    self.avatars = @{userData.user.layerID : _userImage,
                     opponent.layerID: _friendImage};
    
    self.outgoingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    outgoingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageView = [JSQMessagesBubbleImageFactory
                                    incomingMessageBubbleImageViewWithColor:[UIColor jsq_messageBubbleBlueColor]];
    self.inputToolbar.contentView.leftBarButtonItem = nil;

    
    NSLog(@"messages: %@", lyrMessages);
    
    
}
-(void)didReceiveLayerObjectsDidChangeNotification:(NSNotification *)notification
{
    NSArray *changes = [notification.userInfo objectForKey:LYRClientObjectChangesUserInfoKey];
    for (NSDictionary *change in changes) {
        if ([[change objectForKey:LYRObjectChangeObjectKey] isKindOfClass:[LYRConversation class]]) {
            // Object is a conversation
        }
        
        if ([[change objectForKey:LYRObjectChangeObjectKey]isKindOfClass:[LYRMessage class]]) {
            LYRMessage *changeObject = [change objectForKey:LYRObjectChangeObjectKey];
            if(![changeObject.sentByUserID isEqualToString:userData.user.layerID]){
                lyrMessages = [client messagesForConversation:conversation];
                 [JSQSystemSoundPlayer jsq_playMessageReceivedSound];
                [self scrollToBottomAnimated:YES];
                NSLog(@"received message: %@", changeObject);
                [self finishReceivingMessage];
                [self.collectionView reloadData];
            }
        }
    }

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.collectionView.collectionViewLayout.springinessEnabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - JSQMessagesViewController method overrides

-(JSQMessage *)convertToJSQMessage:(LYRMessage *)message{
    LYRMessagePart *part = [message.parts firstObject];
    NSString *messageText = [[NSString alloc] initWithData:part.data encoding:NSUTF8StringEncoding];
    return [[JSQMessage alloc]initWithText:messageText sender:message.sentByUserID date:[NSDate date]];
}


- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                    sender:(NSString *)sender
                      date:(NSDate *)date
{
    static NSString *const MIMETypeTextPlain = @"text/plain";
    

    NSData *message = [text dataUsingEncoding:NSUTF8StringEncoding];
    LYRMessagePart *messagePart = [LYRMessagePart messagePartWithMIMEType:MIMETypeTextPlain data:message];
    
    // Creates and returns a new message object with the given conversation and array of message parts
    LYRMessage *lyrmessage = [LYRMessage messageWithConversation:conversation parts:@[messagePart]];
    
    // Sends the specified message
    
    NSError *error;
    BOOL success = [client sendMessage:lyrmessage error:&error];
    if (success) {
        NSLog(@"Message send succesfull");
        [JSQSystemSoundPlayer jsq_playMessageSentSound];
        lyrMessages = [client messagesForConversation:conversation];
        [self finishSendingMessage];


    } else {
        NSLog(@"Message send failed with error %@", error);
    }
}



#pragma mark - JSQlyrMessages CollectionView DataSource


- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self convertToJSQMessage:[lyrMessages objectAtIndex:indexPath.item]];
}

- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView bubbleImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self convertToJSQMessage:[lyrMessages objectAtIndex:indexPath.item]];
    
    if ([message.sender isEqualToString:userData.user.layerID]) {
        return [[UIImageView alloc] initWithImage:self.outgoingBubbleImageView.image
                                 highlightedImage:self.outgoingBubbleImageView.highlightedImage];
    }
    else{
        return [[UIImageView alloc] initWithImage:self.incomingBubbleImageView.image
                                 highlightedImage:self.incomingBubbleImageView.highlightedImage];
    }
}


- (UIImageView *)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageViewForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //Disable profile image for outgoing messages
//    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
    
    JSQMessage *message = [self convertToJSQMessage:[lyrMessages objectAtIndex:indexPath.item]];
    UIImage *avatarImage = [self.avatars objectForKey:message.sender];
    return [[UIImageView alloc] initWithImage:avatarImage];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for message based on time
     */
    
    NSIndexPath *prevPath = [NSIndexPath indexPathForRow:(int)indexPath.item -1 inSection:indexPath.section];
    if(prevPath.row < 0){
        return nil;
    }else{
        
        JSQMessage *previousMessage = [self convertToJSQMessage:[lyrMessages objectAtIndex:prevPath.row]];
        JSQMessage *message = [self convertToJSQMessage:[lyrMessages objectAtIndex:indexPath.item]];
        if([previousMessage.date timeIntervalSinceDate:message.date] > 300){
            return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
        }
    }
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self convertToJSQMessage:[lyrMessages objectAtIndex:indexPath.item]];
    NSIndexPath *prevPath = [NSIndexPath indexPathForRow:(int)indexPath.item -1 inSection:indexPath.section];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.sender isEqualToString:userData.user.layerID]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self convertToJSQMessage:[lyrMessages objectAtIndex:prevPath.row]];
        if ([[previousMessage sender] isEqualToString:message.sender]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    NSString *null = (@"");
    return [[NSAttributedString alloc] initWithString:null];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [lyrMessages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self convertToJSQMessage:[lyrMessages objectAtIndex:indexPath.item]];
    
    if ([msg.sender isEqualToString:userData.user.layerID]) {
        cell.textView.textColor = [UIColor blackColor];
    }
    else {
        cell.textView.textColor = [UIColor whiteColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    
    return cell;
}



#pragma mark - JSQlyrMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    
    NSIndexPath *prevPath = [NSIndexPath indexPathForRow:(int)indexPath.item -1 inSection:indexPath.section];
    if(prevPath.row < 0){
        return 0.0f;
    }else{
        
        JSQMessage *previousMessage = [self convertToJSQMessage:[lyrMessages objectAtIndex:prevPath.item]];
        JSQMessage *message = [self convertToJSQMessage:[lyrMessages objectAtIndex:indexPath.item]];
        if([previousMessage.date timeIntervalSinceDate:message.date] > 300){
            return kJSQMessagesCollectionViewCellLabelHeightDefault;
        }
    }
    
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    LYRMessage *currentMessage = [lyrMessages objectAtIndex:indexPath.item];
    NSIndexPath *prevPath = [NSIndexPath indexPathForRow:(int)indexPath.item -1 inSection:indexPath.section];
    
    if ([currentMessage.sentByUserID isEqualToString:userData.user.layerID]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self convertToJSQMessage:[lyrMessages objectAtIndex:prevPath.item]];
        if ([[previousMessage sender] isEqualToString:currentMessage.sentByUserID]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    NSLog(@"Load earlier messages!");
}


-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        //        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main"
        //                                                      bundle:nil];
        //
        //        OutgoingViewController *outgoingVC = [sb instantiateViewControllerWithIdentifier:@"outgoingVC"];
        //        [self.navigationController popToViewController:outgoingVC animated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end


