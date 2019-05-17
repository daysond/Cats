//
//  Photo.h
//  Cats
//
//  Created by Dayson Dong on 2019-05-16.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Photo : NSObject

@property (nonatomic) NSURL *url;
@property (nonatomic) NSString *farm;
@property (nonatomic) NSString *server;
@property (nonatomic) NSString *photoID;
@property (nonatomic) NSString *secret;
@property (nonatomic) NSString* photoTitle;
@property (nonatomic) UIImage* image;
@property (nonatomic) NSString *link;
@property (nonatomic) NSString *dateTaken;
@property (nonatomic) NSString *realname;
@property (nonatomic) NSString *username;
@property (nonatomic) NSString *location;
- (instancetype)initWithFarm: (NSString*)farm server: (NSString*) server photoID: (NSString*) photoID secret:(NSString*)secret photoTitle: (NSString*) photoTitle;

@end

NS_ASSUME_NONNULL_END
