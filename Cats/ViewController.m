//
//  ViewController.m
//  Cats
//
//  Created by Dayson Dong on 2019-05-16.
//  Copyright © 2019 Dayson Dong. All rights reserved.
//

#import "ViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Webservice.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) NSMutableArray <Photo*> *photos;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) IBOutlet UIView *popOver;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) Webservice *webservice;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.webservice = [Webservice new];
    self.photos = [NSMutableArray new];
    [self setupLayout];
    [self fetchPhoto];
    
    self.popOver.layer.cornerRadius = 15;
    
}


#pragma mark - Get data

-(void)fetchPhoto {
    
    [self.webservice fetchDataWithMethod:@"flickr.photos.search" query:[[NSURLQueryItem alloc] initWithName:@"tags" value:@"dog"] completionHandler:^(NSDictionary * _Nonnull dataDict) {
        
        NSArray* photoData = dataDict[@"photos"][@"photo"];
        
        for (NSDictionary* photoDataDict in photoData) {
            Photo* photo = [[Photo alloc]initWithFarm:photoDataDict[@"farm"] server:photoDataDict[@"server"]  photoID:photoDataDict[@"id"]  secret:photoDataDict[@"secret"] photoTitle: photoDataDict[@"title"]];
            [self.photos addObject:photo];
        }
        [self.photoCollectionView reloadData];
    }];
}

-(void)fetchPhotoInfoWithID: (NSString*) photoID {
    
    NSURLQueryItem *photoIDQuery = [[NSURLQueryItem alloc] initWithName:@"photo_id" value:photoID];
    
    [self.webservice fetchDataWithMethod:@"flickr.photos.getInfo" query:photoIDQuery completionHandler:^(NSDictionary * _Nonnull dataDict) {
        
        NSDictionary* dateData = dataDict[@"photo"][@"dates"];
        NSDictionary* ownerInfo = dataDict[@"photo"][@"owner"];
        
        self.dateLabel.text = [NSString stringWithFormat:@"Date taken: %@", dateData[@"taken"]];
        self.usernameLabel.text = [NSString stringWithFormat:@"Username: %@",ownerInfo[@"username"]];
        self.realnameLabel.text = [NSString stringWithFormat:@"Real name: %@", ownerInfo[@"realname"]];
        self.locationLabel.text= [NSString stringWithFormat:@"Location: %@",ownerInfo[@"location"]];

    }];
    
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

- (IBAction)longPressRecog:(UILongPressGestureRecognizer *)sender {

    NSIndexPath *indexPath = [self.photoCollectionView indexPathForItemAtPoint:[sender locationInView:self.view]];
    Photo *photo = self.photos[indexPath.item];
    [self fetchPhotoInfoWithID:photo.photoID];
    [self setupPopOver];
}


#pragma mark - helpers

-(void)setupPopOver {
    
    self.popOver.alpha = 0.8;
    [self.view addSubview:self.popOver];
    CGFloat width = CGRectGetWidth(self.view.frame) - 20.0;
    CGFloat height = width * (3.0/4.0);
    [self.popOver setFrame:CGRectMake(0, 0,width,height)];
    self.popOver.center = self.view.center;
    
}
- (IBAction)dissmissButtonTapped:(UIButton *)sender {
    
    [self.popOver removeFromSuperview];
}
- (IBAction)tapRecog:(UITapGestureRecognizer *)sender {
    [self performSegueWithIdentifier:@"toWeb" sender:sender];
    NSIndexPath *indexPath = [self.photoCollectionView indexPathForItemAtPoint:[sender locationInView:self.view]];
    Photo* photo = self.photos[indexPath.row];
    //TODO: consturct URL;
    
}

@end
