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
#import "WebViewController.h"
#import "WebButton.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>

@property (nonatomic) NSMutableArray <Photo*> *photos;
@property (nonatomic) UICollectionViewFlowLayout *flowLayout;
@property (strong, nonatomic) IBOutlet UIView *popOver;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet WebButton *webButton;
@property (nonatomic) Webservice *webservice;
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.webservice = [Webservice new];
    self.photos = [NSMutableArray new];
    [self setupLayout];
    [self fetchPhotoWithTag:@"cat"];
    self.popOver.layer.cornerRadius = 15;
    [self setupSearchBar];
    
}


#pragma mark - Get data

-(void)fetchPhotoWithTag: (NSString*) tag {
    [self.photos removeAllObjects];
    [self.webservice fetchDataWithMethod:@"flickr.photos.search" query:[[NSURLQueryItem alloc] initWithName:@"tags" value:tag] completionHandler:^(NSDictionary * _Nonnull dataDict) {
        NSLog(@"tag:%@",tag);
        NSArray* photoData = dataDict[@"photos"][@"photo"];
        
        for (NSDictionary* photoDataDict in photoData) {
            
            NSLog(@"inside fetch for loop");
            Photo* photo = [[Photo alloc]initWithFarm:photoDataDict[@"farm"] server:photoDataDict[@"server"]  photoID:photoDataDict[@"id"]  secret:photoDataDict[@"secret"] photoTitle: photoDataDict[@"title"]];
            NSLog(@"photo is %@",photo);
            [self.photos addObject:photo];
        }
        [self.photoCollectionView reloadData];
        [self getPhotoInfo];
    }];

}

-(void)getPhotoInfo {
    
    for (Photo* photo in self.photos) {
        
        NSURLQueryItem *photoIDQuery = [[NSURLQueryItem alloc] initWithName:@"photo_id" value:photo.photoID];
        
        [self.webservice fetchDataWithMethod:@"flickr.photos.getInfo" query:photoIDQuery completionHandler:^(NSDictionary * _Nonnull dataDict) {
            
            NSDictionary* dateData = dataDict[@"photo"][@"dates"];
            NSDictionary* ownerInfo = dataDict[@"photo"][@"owner"];
            NSLog(@"date taken:%@",dateData[@"taken"]);
            photo.dateTaken = dateData[@"taken"];
            photo.username = ownerInfo[@"username"];
            photo.realname = ownerInfo[@"realname"];
            photo.location = ownerInfo[@"location"];
            photo.link = dataDict[@"photo"][@"urls"][@"url"][0][@"_content"];
        }];
    }
}



#pragma mark - Set up layout and View

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

-(void)setupSearchBar {

    UISearchController *searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    [searchController.searchBar setDelegate:self];
    self.navigationItem.searchController = searchController;
    
}


#pragma  mark - Search bar delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [self fetchPhotoWithTag:searchBar.text];
    
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
    [self setupPopOverWithPhotoInfo: cell.photo];
}

//- (IBAction)longPressRecog:(UILongPressGestureRecognizer *)sender {
//
//    CGPoint location = [sender locationInView:self.view];
//    CGPoint newLocation = CGPointMake(location.x, location.y + [self.photoCollectionView contentOffset].y);
//    NSIndexPath *indexPath = [self.photoCollectionView indexPathForItemAtPoint:newLocation];
//    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell*)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
//    [self setupPopOverWithPhotoInfo: cell.photo];
//
//}


#pragma mark - helpers and button actions

-(void)setupPopOverWithPhotoInfo: (Photo*) photo {

    self.popOver.alpha = 0.8;
    CGFloat width = CGRectGetWidth(self.view.frame) - 20.0;
    CGFloat height = width * (3.0/4.0);
    [self.popOver setFrame:CGRectMake(0, 0,width,height)];
    self.popOver.center = self.view.center;
    self.dateLabel.text = photo.dateTaken;
    self.usernameLabel.text = photo.username;
    self.realnameLabel.text = photo.realname;
    self.locationLabel.text= photo.location;
    self.webButton.url = photo.link;
    [self.view addSubview:self.popOver];
    
}

- (IBAction)dissmissButtonTapped:(UIButton *)sender {
    [self.popOver removeFromSuperview];
}

- (IBAction)viewPostButtonTapped:(WebButton *)sender {
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WebButton *webButton = (WebButton*) sender;
    if ([segue.identifier isEqualToString:@"toWeb"]) {
        WebViewController *dvc = segue.destinationViewController;
        dvc.urlStr = webButton.url;
        [self.popOver removeFromSuperview];
    }
}



@end
