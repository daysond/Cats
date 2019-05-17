//
//  Webservice.h
//  Cats
//
//  Created by Dayson Dong on 2019-05-16.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Webservice : NSObject
-(void) fetchDataWithMethod: (NSString*) componentMethodValue query:(NSURLQueryItem*) lastItem  completionHandler:(void (^)(NSDictionary *dataDict))completionHandler;
@end

NS_ASSUME_NONNULL_END
