//
//  HomeViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 21..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "HomeViewController.h"

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "NaviBaseViewController.h"

#import <SwaggerClient/SWGFeedApi.h>
#import <SwaggerClient/SWGImageApi.h>

#import <SwaggerClient/SWGObjectApi.h>

#import "Global.h"
#import "AloImage.h"

#import "HomeCell.h"
#import "HomeCellHeader.h"
#import "HomeCellFooter.h"

#import "ProductDetailViewController.h"

#define HOME_CELL_IDENTIFIER @"HomeCell"
#define HOME_CELL_HEADER_IDENTIFIER @"HomeCellHeader"
#define HOME_CELL_FOOTER_IDENTIFIER @"HomeCellFooter"

@interface HomeViewController ()

@end

@implementation HomeViewController

int feedApiOffset;
int feedApiLimit;

-(id)initWithFrame:(CGRect)aFrame {
    
    self = [super init];
    if(self) {
        self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        self.frame = aFrame;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

-(void)loadView {
    UIView* aView = [[UIView alloc] initWithFrame:self.frame];
    self.view = aView;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = [UIColor grayColor];
    [_refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:lpgr];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [self updateLayoutForOrientation:toInterfaceOrientation];
//}
//
//- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
//    CHTCollectionViewWaterfallLayout *layout =
//    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
//    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
//}

#pragma mark - Network
- (void)processFeedApi {
    feedApiOffset = 0;
    feedApiLimit = 50;
    
#if DEBUG
    
#else
    [self.app.baseViewController startIndicator];
    [self processFeedApiWithOffsetAndLimit:feedApiOffset aLimit:feedApiLimit];
#endif
}

- (void)processFeedApiPagination {
    feedApiOffset += feedApiLimit;
    
#if DEBUG
    
#else
    [self.app.baseViewController startIndicator];
    [self processFeedApiWithOffsetAndLimit:feedApiOffset aLimit:feedApiLimit];
#endif
}

-(void)processFeedApiWithOffsetAndLimit:(int)offset aLimit:(int)limit {
    SWGFeedApi *apiInstance = [[SWGFeedApi alloc] init];
    [apiInstance getFeedsWithOffset:[NSNumber numberWithInt:offset]
                              limit:[NSNumber numberWithInt:limit]
                  completionHandler: ^(SWGGetFeedResponse* output, NSError* error) {
                      [self.app.baseViewController stopIndicator];
                      NSInteger theFirstIndexForInsertingCells = [self.app.baseViewController.dataManager.productInfos count];
                      
                      if (offset == 0) {
                          [self.app.baseViewController.dataManager.productInfos removeAllObjects];
                      }
                      
                      if (output) {
                          NSLog(@"%@", output);
                          
                          ProductInfo *aProductInfo = nil;
                          for(SWGImage *aSWGImage in output.data) {
                    
                              aProductInfo = [[ProductInfo alloc] init];
                              aProductInfo.swgImage = aSWGImage;
                              aProductInfo._id = aSWGImage._id;
                              aProductInfo.mainImageName = aSWGImage.mainImageMobileFull;
                              aProductInfo.mobileThumbImageName = aSWGImage.mainImageMobileThumb;
                              aProductInfo.titleLabel = aSWGImage.productName;
                              aProductInfo.priceLabel = [NSString stringWithFormat:@"%@ %@",
                                                         [Global getStringNumberFormat:aSWGImage.price],
                                                         [Global getCurrencyUnit:aSWGImage.currencyUnit]];
                              
                              UIImage *anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aSWGImage.mainImageMobileThumb]]];
                              aProductInfo.imageSize = [NSValue valueWithCGSize:CGSizeMake(anImage.size.width, anImage.size.height)];
                              
                              [self.app.baseViewController.dataManager.productInfos addObject:aProductInfo];
                          }
                          
                          if (offset == 0) {
//                              [self.collectionView reloadData];
                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                  [self.collectionView setContentOffset:CGPointZero animated:NO];
                                  [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
                              }];
                              
                          } else {
                              [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                  NSMutableArray* indexes = [[NSMutableArray alloc] init];
                                  for( NSInteger aRowIndex = 0; aRowIndex < [self.app.baseViewController.dataManager.productInfos count] - theFirstIndexForInsertingCells; aRowIndex++ ) {
                                      [indexes addObject:[NSIndexPath indexPathForRow:(theFirstIndexForInsertingCells + aRowIndex) inSection:0]];
                                  }
                                  [self.collectionView insertItemsAtIndexPaths:indexes];
                              }];
                          }
                      }
                      if (error) {
                          NSLog(@"Error: %@", error);
                      }
                  }];
}

-(void)processGetImagesApiWithImageId:(NSString*)imageId atIndex:(int)index {
    [self.app.baseViewController startIndicator];
    
    NSLog(@"%@", imageId);
    SWGImageApi *apiInstance = [[SWGImageApi alloc] init];
    [apiInstance getImagesWithImageId:imageId
                                   offset:[NSNumber numberWithInt:0]
                                    limit:[NSNumber numberWithInt:10]
                        completionHandler: ^(SWGGetImagesResponse* output, NSError* error) {
                            [self.app.baseViewController stopIndicator];
                            
                            if (output) {
                                NSLog(@"%@", output);
                                
                                if ([output.data count] <= 0) {
                                    return;
                                }
//                                __block NSInteger theFirstIndexForInsertingCells = [self.app.baseViewController.dataManager.productInfos count];
                                
                                SWGImage *aSWGImage = nil;
                                ProductInfo *aProductInfo = nil;
                                for (NSInteger i=([output.data count] - 1); i>=0; i--) {
                                    aSWGImage = [output.data objectAtIndex:i];
                                    aProductInfo = [[ProductInfo alloc] init];
                                    aProductInfo.swgImage = aSWGImage;
                                    aProductInfo._id = aSWGImage._id;
                                    aProductInfo.mainImageName = aSWGImage.mainImageMobileFull;
                                    aProductInfo.mobileThumbImageName = aSWGImage.mainImageMobileThumb;
                                    aProductInfo.titleLabel = aSWGImage.productName;
                                    aProductInfo.priceLabel = [NSString stringWithFormat:@"%@ %@",
                                                               [Global getStringNumberFormat:aSWGImage.price],
                                                               [Global getCurrencyUnit:aSWGImage.currencyUnit]];
                                    
                                    UIImage *anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aSWGImage.mainImageMobileThumb]]];
                                    aProductInfo.imageSize = [NSValue valueWithCGSize:CGSizeMake(anImage.size.width, anImage.size.height)];
                                    
                                    [self.app.baseViewController.dataManager.productInfos insertObject:aProductInfo atIndex:index+1];
                                }
                                
                                [self.collectionView reloadData];
//                                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
                            }
                            if (error) {
                                NSLog(@"Error: %@", error);
                            }
                        }];

}

#pragma mark - Accessors
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(7*self.app.widthRatio, 7*self.app.heightRatio, 7*self.app.widthRatio, 7*self.app.heightRatio);
        layout.headerHeight = 5*self.app.heightRatio;
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 6*self.app.widthRatio;
        layout.minimumInteritemSpacing = 6*self.app.heightRatio;
        layout.columnCount = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[HomeCell class]
            forCellWithReuseIdentifier:HOME_CELL_IDENTIFIER];
        [_collectionView registerClass:[HomeCellHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:HOME_CELL_HEADER_IDENTIFIER];
        [_collectionView registerClass:[HomeCellFooter class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:HOME_CELL_FOOTER_IDENTIFIER];
    }
    return _collectionView;
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.app.baseViewController.dataManager.productInfos count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCell *cell = (HomeCell *)[collectionView dequeueReusableCellWithReuseIdentifier:HOME_CELL_IDENTIFIER
                                                                                forIndexPath:indexPath];
    
    cell.homeViewController = self;
    cell.productInfo = [self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row];
    
#if DEBUG
    cell.imageView.image = [UIImage imageNamed:[self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row].mainImageName];
#else
    NSString *imageUrl = [self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row].mobileThumbImageName;
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                // set image
                cell.imageView.image = anImage;
            }];
        }
    }];
#endif
//    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row].imageName]]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HOME_CELL_HEADER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:HOME_CELL_FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@", [self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row]._id);
    [self pushToProductDetailWithProductInfo:[self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row]];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    // pagination
    NSInteger lastSectionIndex = [collectionView numberOfSections] -1;
    if ( [collectionView numberOfItemsInSection:lastSectionIndex] > 4 ) {
        NSInteger lastRowIndex = [collectionView numberOfItemsInSection:lastSectionIndex]-4;
        if (( (indexPath.section) == lastSectionIndex) && ((indexPath.row-1) == lastRowIndex)) {
#if DEBUG
            
#else
            [self processFeedApiPagination];
#endif
        }
    }
}

#pragma mark - LongPress
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
 
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        HomeCell* cell = (HomeCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        UIAlertController * view=   [UIAlertController
                                     alertControllerWithTitle:@"해당 항목을 삭제하시겠습니까?"
                                     message:[NSString stringWithFormat:@"TITLE : %@", cell.productInfo.titleLabel]
                                     preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"YES"
                             style:UIAlertActionStyleDestructive
                             handler:^(UIAlertAction * action)
                             {
                                 //Do some thing here
                                 NSMutableArray<ProductInfo*>* productInfosCopied = [self.app.baseViewController.dataManager.productInfos copy];
                                 for (int i=0; i<[productInfosCopied count]; i++) {
                                     if ([cell.productInfo._id isEqualToString:[productInfosCopied objectAtIndex:i]._id]) {
                                         [self.app.baseViewController.dataManager.productInfos removeObjectAtIndex:i];
                                         break;
                                     }
                                 }
                                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                     [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
                                 }];
                                 
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
        UIAlertAction* cancel = [UIAlertAction
                                 actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        [view addAction:ok];
        [view addAction:cancel];
        [self.view.window.rootViewController presentViewController:view animated:YES completion:nil];
        
    }
}

#pragma mark - RefershControlAction
-(void)refershControlAction {
    NSLog(@"refershControlAction");
    [self.refreshControl endRefreshing];
    [self processFeedApi];
}

#pragma mark - Methods
-(void)pushToProductDetailWithProductInfo:(ProductInfo*)aProductInfo {
    ProductDetailViewController *aNewViewPush = [[ProductDetailViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
    aNewViewPush.productInfo = aProductInfo;
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}

-(void)sameProductButtonClicked:(ProductInfo*)aParamProductInfo {
    if (!aParamProductInfo) {
        return;
    }
    NSLog(@"id : %@", aParamProductInfo._id);
#if DEBUG
    
#else
    NSMutableArray<ProductInfo*>* productInfosCopied = [self.app.baseViewController.dataManager.productInfos copy];
    for (int i=0; i<[productInfosCopied count]; i++) {
        if ([aParamProductInfo._id isEqualToString:[productInfosCopied objectAtIndex:i]._id]) {
            [self processGetImagesApiWithImageId:aParamProductInfo._id atIndex:i];
            return;
        }
    }
#endif
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [[self.app.baseViewController.dataManager.productInfos objectAtIndex:indexPath.row].imageSize CGSizeValue];
}

@end
