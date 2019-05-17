//
//  Webservice.m
//  Cats
//
//  Created by Dayson Dong on 2019-05-16.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import "Webservice.h"

@interface Webservice()

@end

@implementation Webservice


-(void) fetchDataWithMethod: (NSString*) componentMethodValue query:(NSURLQueryItem*) lastItem  completionHandler:(void (^)(NSDictionary *dataDict))completionHandler {
    
    NSURLComponents *urlComponents = [[NSURLComponents alloc]init];
    NSURLQueryItem *method = [[NSURLQueryItem alloc]initWithName:@"method" value:componentMethodValue];
    NSURLQueryItem *format = [[NSURLQueryItem alloc]initWithName:@"format" value:@"json"];
    NSURLQueryItem *nojsoncallback = [[NSURLQueryItem alloc]initWithName:@"nojsoncallback" value:@"1"];
    NSURLQueryItem *apikey = [[NSURLQueryItem alloc]initWithName:@"api_key" value:@"392a5a896c2f782e5a74afb51275ebb2"];
    NSArray<NSURLQueryItem*> *queryItem = @[method,format,nojsoncallback,apikey,lastItem];
    [urlComponents setScheme:@"https"];
    [urlComponents setHost:@"api.flickr.com"];
    [urlComponents setPath:@"/services/rest"];
    [urlComponents setQueryItems:queryItem];
    NSURL *url = urlComponents.URL;

    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"handling error %@",error);
            return ;
        }
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
        
        if (httpResponse.statusCode != 200) {
            NSLog(@"Something went wrong with code %ld",httpResponse.statusCode);
            return;
        }
        
        NSError *jsonError;
        
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"jsonError: %@",jsonError);
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(dataDictionary);
        });
    
    }];
    

    [dataTask resume];
    
}





@end
