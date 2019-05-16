//
//  Photo.m
//  Cats
//
//  Created by Dayson Dong on 2019-05-16.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import "Photo.h"

@implementation Photo

- (instancetype)initWithFarm: (NSString*)farm server: (NSString*) server photoID: (NSString*) photoID secret:(NSString*)secret photoTitle: (NSString*) photoTitle
{
    self = [super init];
    if (self) {
        _farm = farm;
        _server = server;
        _photoID = photoID;
        _secret = secret;
        _photoTitle = photoTitle;
        _url = [NSURL URLWithString:[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@.jpg",farm,server,photoID,secret]];
    }
    return self;
}



@end
