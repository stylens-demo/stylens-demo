//
//  AloImage.h
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 21..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  
    ALO_IMAGE_MODE_NONE = 0,
    ALO_IMAGE_MODE_SCALE_STRETCH,
    ALO_IMAGE_MODE_CROP_ADJUST,
    
    ALO_IMAGE_MODE_RESIZE_VIEW_FRAME,
    
} ALO_IMAGE_MODE;



@interface AloImage : NSObject

@property (nonatomic, retain, setter=setDirName:) NSString* dirName;

@property (nonatomic, assign) NSInteger numberOfFilesToKeep;
@property (nonatomic, assign) CGFloat ratioOfRemove;

+(NSString*)dirName;
+(void)removeCacheFiles;

+(void)imageWithUrl:(NSString*)aUrl Queue:(NSOperationQueue*)aQueue TargetView:(UIImageView*)anImageView TargetFrame:(CGRect)aTargetFrame ImageMode:(ALO_IMAGE_MODE)anImageMode ScaleFactor:(CGFloat)scaleFactor WithCompletionBlock:( void(^)(BOOL bSuccess, NSError* error) )completionHandler;
+(void)imageWithUrl:(NSString*)aUrl WithCompletionBlock:( void(^)(BOOL bSuccess, NSError* error, UIImage* anImage) )completionHandler;
+(void)imageWithUrlNoCache:(NSString*)aUrl WithCompletionBlock:( void(^)(BOOL bSuccess, NSError* error, UIImage* anImage) )completionHandler;
@end
