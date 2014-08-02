//
//  DFUser.m
//  DayFriend
//
//  Created by Spencer Yen on 8/1/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "DFUser.h"

@implementation DFUser
//@synthesize address;
@synthesize addressString;
@synthesize userID;
@synthesize name;
@synthesize imageURL;
@synthesize coverURL;
@synthesize aboutString;

//-(id)initWithID:(NSString *)ID withAddressString:(NSString *)addString withAddress:(LYRAddress *)addr andName:(NSString *)nam withImageURL:(NSString *)image{
//    self = [super init];
//    if(self)
//    {
//        self.userID = ID;
//        self.addressString = addString;
//        self.address = address;
//        self.name = nam;
//        self.imageURL = image;
//    }
//    return self;
//}

-(void)encodeWithCode:(NSCoder *)encoder{
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.addressString forKey:@"addressString"];
  //  [encoder encodeObject:self.address forKey:@"address"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(!self ){
        return nil;
    }
    
    self.userID = [decoder decodeObjectForKey:@"userID"];
    self.addressString = [decoder decodeObjectForKey:@"addressString"];
   // self.address = [decoder decodeObjectForKey:@"address"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
    
    return self;
}
@end
