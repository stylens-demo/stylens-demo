//
//  DataManager.m
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 22..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

-(id)init {
    self = [super init];
    if(self) {
        self.productInfos = [[NSMutableArray alloc] init];
        
        [self testData];
    }
    return self;
}

-(void)testData {
    
#if DEBUG
    // productInfos
    {
        ProductInfo *aProductInfo = nil;
        for(int i = 0; i <= 20; i++ ) {
            aProductInfo = [[ProductInfo alloc] init];
            aProductInfo._id = [NSString stringWithFormat:@"aaaa_%d", i];
            aProductInfo.titleLabel = [NSString stringWithFormat:@"ITEM_%d", i];
            aProductInfo.mainImageName = [NSString stringWithFormat:@"cat%d.jpg", i%5 == 0 ? 5 : i%5];
            aProductInfo.mobileThumbImageName = [NSString stringWithFormat:@"cat%d.jpg", i%5 == 0 ? 5 : i%5];
            aProductInfo.priceLabel = [NSString stringWithFormat:@"%d", 10000+i];
            
            UIImage *anImage = [UIImage imageNamed:aProductInfo.mainImageName];
            aProductInfo.imageSize = [NSValue valueWithCGSize:CGSizeMake(anImage.size.width, anImage.size.height)];
            
            [self.productInfos addObject:aProductInfo];
        }
    }
#endif
    
}
@end
