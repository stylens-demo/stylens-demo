//
//  ProductDetailViewController.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 12. 4..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "ProductDetailViewController.h"

#import "AppDelegate.h"
#import "BaseViewController.h"
#import "NaviBaseViewController.h"

#import <SwaggerClient/SWGImageApi.h>

#import "Global.h"
#import "AloImage.h"

#import "ProductDetailCell.h"
#import "ProductDetailCellHeader.h"
#import "ProductDetailCellFooter.h"

#import "EditorViewController.h"
#import "EditorDemoViewController.h"
#import "ProductWebViewController.h"

#define PRODUCT_DETAIL_CELL_IDENTIFIER @"ProductDetailCell"
#define PRODUCT_DETAIL_CELL_HEADER_IDENTIFIER @"ProductDetailCellHeader"
#define PRODUCT_DETAIL_CELL_FOOTER_IDENTIFIER @"ProductDetailCellFooter"

@interface ProductDetailViewController ()

@end

@implementation ProductDetailViewController

CGFloat mainImageHeight;
NSMutableArray<ProductInfo*>* productInfos;

#pragma mark - Life Cycle
- (void)dealloc {
    _collectionView.delegate = nil;
    _collectionView.dataSource = nil;
}

-(void)loadView {
    [super loadView];
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    productInfos = [[NSMutableArray alloc] init];
    
    // back button
    UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize aButtonSize = CGSizeMake(48*self.app.widthRatio, 48*self.app.heightRatio);
    aButton.frame = CGRectMake(10*self.app.widthRatio, (statusBarHeight+10)*self.app.heightRatio, aButtonSize.width, aButtonSize.height);
    [aButton setImage:[UIImage imageNamed:@"btnBackNor"] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:aButton];
    self.backButton = aButton;
}

#pragma mark - Network
-(void)processGetProductsApi {
    SWGImageApi *apiInstance = [[SWGImageApi alloc] init];
    [apiInstance getImagesWithImageId:self.productInfo._id
                                   offset:[NSNumber numberWithInt:0]
                                    limit:[NSNumber numberWithInt:5]
                        completionHandler: ^(SWGGetImagesResponse* output, NSError* error) {
                            if (output) {
                                NSLog(@"%@", output);
                                [productInfos removeAllObjects];
                                
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
                                    [productInfos addObject:aProductInfo];
                                }

                                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                                    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.collectionView.numberOfSections)]];
                                }];
                                
                            }
                            if (error) {
                                NSLog(@"Error: %@", error);
                            }
                        }];
}

-(void)processGetImagesApiWithImageId:(NSString*)imageId image:(UIImage*)anImage {
    SWGImageApi *apiInstance = [[SWGImageApi alloc] init];
    [apiInstance getImageByIdWithImageId:imageId completionHandler:^(SWGGetImageResponse* output, NSError* error) {
        if (output) {
            NSLog(@"%@", output);
            NSLog(@"");
            
            EditorDemoViewController *aNewViewPush = [[EditorDemoViewController alloc] initWithSize:self.app.screenRect.size];
            aNewViewPush.bShowToolbar = NO;
            aNewViewPush.productImage = anImage;
            aNewViewPush.boxInfos = self.boxInfos;
            aNewViewPush.editorProductResultInfos = [self generateEditorResultInfos:output.data.images];
            
            [self.app.baseViewController stopIndicator];
            [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
        }
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}
-(NSMutableArray*)generateEditorResultInfos:(NSArray<SWGSimImage*>*)anEditorResultInfos {
    NSMutableArray<ProductInfo*>* aProductInfos = [[NSMutableArray alloc] init];
    ProductInfo *aProductInfo = nil;
    for(SWGSimImage *aSWGImage in anEditorResultInfos) {
        aProductInfo = [[ProductInfo alloc] init];
        aProductInfo._id = aSWGImage._id;
        aProductInfo.mainImageName = aSWGImage.mainImageMobileFull;
        aProductInfo.mobileThumbImageName = aSWGImage.mainImageMobileThumb;
        aProductInfo.titleLabel = aSWGImage.productName;
        aProductInfo.priceLabel = [NSString stringWithFormat:@"%@ %@",
                                   [Global getStringNumberFormat:aSWGImage.price],
                                   [Global getCurrencyUnit:aSWGImage.currencyUnit]];
        aProductInfo.productUrl = aSWGImage.productUrl;
        
        UIImage *anImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:aSWGImage.mainImageMobileThumb]]];
        aProductInfo.imageSize = [NSValue valueWithCGSize:CGSizeMake(anImage.size.width, anImage.size.height)];
        
        [aProductInfos addObject:aProductInfo];
    }
    return aProductInfos;
}

#pragma mark - Accessors
-(void)setProductInfo:(ProductInfo *)aProductInfo {
    _productInfo = aProductInfo;
    
    NSString *imageUrl = _productInfo.mainImageName;
    
#if DEBUG
//    mainImageHeight = [Global calcImageHeight:[UIImage imageNamed:imageUrl]];
    [self.view addSubview:self.collectionView];
    [self.view bringSubviewToFront:self.backButton];
#else
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            // calc mainImageHeight for HeaderCell
//            mainImageHeight = [Global calcImageHeight:anImage];
            // Demo
            self.mainImageHeight = [Global calcImageHeight:anImage];
            
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self.view addSubview:self.collectionView];
                [self.view bringSubviewToFront:self.backButton];
            }];
        }
    }];
#endif
//    [self processGetProductsApi];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
        
        layout.sectionInset = UIEdgeInsetsMake(7*self.app.widthRatio, 7*self.app.heightRatio, 7*self.app.widthRatio, 7*self.app.heightRatio);
//        layout.headerHeight = [ProductDetailCellHeader heightWithMainImageHeight:mainImageHeight];
        // Demo
        layout.headerHeight = [ProductDetailCellHeader heightWithMainImageHeight:self.mainImageHeight];
        layout.footerHeight = 0;
        layout.minimumColumnSpacing = 6*self.app.widthRatio;
        layout.minimumInteritemSpacing = 6*self.app.heightRatio;
        layout.columnCount = 2;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        //        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[ProductDetailCell class]
            forCellWithReuseIdentifier:PRODUCT_DETAIL_CELL_IDENTIFIER];
        [_collectionView registerClass:[ProductDetailCellHeader class]
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                   withReuseIdentifier:PRODUCT_DETAIL_CELL_HEADER_IDENTIFIER];
        [_collectionView registerClass:[ProductDetailCellFooter class] 
            forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                   withReuseIdentifier:PRODUCT_DETAIL_CELL_FOOTER_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return [productInfos count];
    // Demo
    return [self.productInfos count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailCell *cell = (ProductDetailCell *)[collectionView dequeueReusableCellWithReuseIdentifier:PRODUCT_DETAIL_CELL_IDENTIFIER
                                                forIndexPath:indexPath];
    
//    cell.productInfo = [productInfos objectAtIndex:indexPath.row];
    // Demo
    cell.productInfo = [self.productInfos objectAtIndex:indexPath.row];
    
#if DEBUG
//    cell.imageView.image = [UIImage imageNamed:[productInfos objectAtIndex:indexPath.row].mobileThumbImageName];
#else
//    NSString *imageUrl = [productInfos objectAtIndex:indexPath.row].mobileThumbImageName;
    // Demo
    NSString *imageUrl = [self.productInfos objectAtIndex:indexPath.row].mobileThumbImageName;
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                // set image
                cell.imageView.image = anImage;
            }];
        }
    }];
#endif
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableView = nil;
    ProductDetailCellHeader *cellHeader = nil;
    
    if ([kind isEqualToString:CHTCollectionElementKindSectionHeader]) {
        cellHeader = (ProductDetailCellHeader *)[collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                            withReuseIdentifier:PRODUCT_DETAIL_CELL_HEADER_IDENTIFIER
                                                                                   forIndexPath:indexPath];
        cellHeader.productInfo = self.productInfo;
        cellHeader.productDetailViewController = self;
        return cellHeader;
    }
    else if ([kind isEqualToString:CHTCollectionElementKindSectionFooter]) {
        reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                          withReuseIdentifier:PRODUCT_DETAIL_CELL_FOOTER_IDENTIFIER
                                                                 forIndexPath:indexPath];
    }
    return reusableView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailViewController *aNewViewPush = [[ProductDetailViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
//    aNewViewPush.productInfo = [productInfos objectAtIndex:indexPath.row];
    // Demo
    aNewViewPush.productInfo = [self.productInfos objectAtIndex:indexPath.row];
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return [[productInfos objectAtIndex:indexPath.row].imageSize CGSizeValue];
    // Demo
    return [[self.productInfos objectAtIndex:indexPath.row].imageSize CGSizeValue];
}

#pragma mark - Methods
-(void)backButtonClicked:(id)sender {
    [self.app.baseViewController.aloNavi popViewCointroller:YES];
}

-(void)pushToEditorView {
    // Demo
    [self pushToEditorDemoView];
    return;
    
    EditorViewController *aNewViewPush = [[EditorViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
    aNewViewPush.productInfo = self.productInfo;
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}

// Demo
-(void)pushToEditorDemoView {
    NSString *imageUrl = self.productInfo.mainImageName;
    [AloImage imageWithUrl:imageUrl WithCompletionBlock:^(BOOL bSuccess, NSError *error, UIImage *anImage) {
        if (bSuccess) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [self processGetImagesApiWithImageId:self.productInfo._id image:(UIImage*)anImage];
            }];
        }
    }];
}

-(void)pushToProductWebView {
    ProductWebViewController *aNewViewPush = [[ProductWebViewController alloc] initWithSize:self.app.screenRect.size];
    aNewViewPush.bShowToolbar = NO;
    aNewViewPush.urlForLoad = self.productInfo.productUrl; // @"http://www.google.com";
    [self.app.baseViewController.aloNavi pushViewController:aNewViewPush animated:YES];
}

@end
