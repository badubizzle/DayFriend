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
@property (nonatomic, strong) NSString *addressString;
//@property (nonatomic, strong) LYRAddress *address;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *imageURL;

//-(id)initWithID:(NSString *)ID withAddressString:(NSString *)addString withAddress:(LYRAddress *)addr andName:(NSString *)nam withImageURL:(NSString *)image;

@end
