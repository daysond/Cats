//
//  ViewController.m
//  Cats
//
//  Created by Dayson Dong on 2019-05-16.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) NSMutableArray <Photo*> *photos;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.photos = [NSMutableArray new];
    [self setupLayout];
    [self fetchPhotoData];
    
}


#pragma mark - Get photo raw data

-(void)fetchPhotoData {
    NSURL *url = [NSURL URLWithString:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&format=json&&nojsoncallback=1&api_key=392a5a896c2f782e5a74afb51275ebb2&tags=cat"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
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
        
        NSDictionary *dataDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        
        if (jsonError) {
            NSLog(@"jsonError: %@",jsonError);
            return;
        }
        
        NSArray* photoData = dataDict[@"photos"][@"photo"];
        
        for (NSDictionary* photoDataDict in photoData) {
            Photo* photo = [[Photo alloc]initWithFarm:photoDataDict[@"farm"] server:photoDataDict[@"server"]  photoID:photoDataDict[@"id"]  secret:photoDataDict[@"secret"] photoTitle: photoDataDict[@"title"]];
            [self.photos addObject:photo];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.photoCollectionView reloadData];
        }];
        
    }];
    
    [dataTask resume];
}

#pragma mark - Set up layout

-(void)setupLayout {
    self.photoCollectionView.backgroundColor = [UIColor blackColor];
    self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.flowLayout = (UICollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout;
    [self.flowLayout setMinimumInteritemSpacing:10];
    CGFloat width = (CGRectGetWidth(self.view.frame) - 10.0) / 2.0;
    CGFloat height = width * (3.0/4.0);
    CGSize itemSize = CGSizeMake(width, height);
    [self.flowLayout setItemSize:itemSize];
}

#pragma mark - collection view

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.photo = self.photos[indexPath.item];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.count;
}



@end
