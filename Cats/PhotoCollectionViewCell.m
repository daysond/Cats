//
//  PhotoCollectionViewCell.m
//  Cats
//
//  Created by Dayson Dong on 2019-05-16.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (void)setPhoto:(Photo *)photo {
    
    _photo = photo;
    self.photoTitle.text = photo.photoTitle;
    NSLog(@"titile: %@",photo.photoTitle);
    [self downloadPhotoWithURL:photo.url];
    
}

-(void) downloadPhotoWithURL:(NSURL*) url {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Encountered error: %@",error);
            return ;
        }
        
        UIImage *photo = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.photoImageView.image = photo;
        }];
    }];
    
    [downloadTask resume];
}

@end
