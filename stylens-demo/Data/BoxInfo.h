//
//  BoxInfo.h
//  stylens-demo
//
//  Created by 김대섭 on 2018. 1. 18..
//  Copyright © 2018년 Bluehack Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BoxInfo : NSObject

@property (nonatomic, strong) NSString* _id;
@property (nonatomic, strong) NSNumber* x;
@property (nonatomic, strong) NSNumber* y;
@property (nonatomic, strong) NSNumber* width;
@property (nonatomic, strong) NSNumber* height;
@property (nonatomic, strong) NSString* classCode;
@property (nonatomic, strong) NSNumber* score;

@end
