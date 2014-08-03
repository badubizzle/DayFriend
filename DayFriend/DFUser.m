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
@synthesize userID;
@synthesize name;
@synthesize imageURL;
@synthesize coverURL;
@synthesize aboutString;
@synthesize layerID;

-(id)initWithID:(NSString *)ID withAddress:(NSString *)addr andName:(NSString *)nam withImageURL:(NSString *)image andCoverURL:(NSString *)caoverURL andAbout:(NSString *)about {
self = [super init];
    if(self)
    {
        self.userID = ID;
        self.layerID = addr;
        self.coverURL = caoverURL;
        self.name = nam;
        self.imageURL = image;
        self.aboutString = about;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.userID forKey:@"userID"];
    [encoder encodeObject:self.aboutString forKey:@"about"];
    [encoder encodeObject:self.coverURL forKey:@"coverURL"];
    [encoder encodeObject:self.layerID forKey:@"layerID"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.imageURL forKey:@"imageURL"];
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if(!self ){
        return nil;
    }
    
    self.userID = [decoder decodeObjectForKey:@"userID"];
    self.aboutString = [decoder decodeObjectForKey:@"about"];
    self.layerID = [decoder decodeObjectForKey:@"layerID"];
    self.coverURL = [decoder decodeObjectForKey:@"coverURL"];
    self.name = [decoder decodeObjectForKey:@"name"];
    self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
    
    return self;
}
@end
