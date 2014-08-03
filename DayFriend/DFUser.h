//
//  DFUser.h
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFUser : NSObject
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *coverURL;
@property (nonatomic, strong) NSString *aboutString;
@property (nonatomic, strong) NSString *layerID;
-(id)initWithID:(NSString *)ID withAddress:(NSString *)addr andName:(NSString *)nam withImageURL:(NSString *)image andCoverURL:(NSString *)caoverURL andAbout:(NSString *)about;


@end
