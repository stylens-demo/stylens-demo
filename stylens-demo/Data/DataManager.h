//
//  DataManager.h
//  stylense-demo
//
//  Created by 김대섭 on 2017. 11. 22..
//  Copyright © 2017년 김대섭. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ProductInfo.h"

@interface DataManager : NSObject

@property (nonatomic, strong) NSMutableArray<ProductInfo*>* productInfos;

@end
