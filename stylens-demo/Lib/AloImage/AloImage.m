//
//  AloImage.m
//  TestApp
//
//  Created by 기대 여 on 2016. 4. 21..
//  Copyright © 2016년 기대 여. All rights reserved.
//

#import "AloImage.h"

#import "Global.h"

#define kAloImageFileName @"kAloImageFileName"

@implementation AloImage

-(id)init {
    
    self = [super init];
    
    if( self ) {
        
        self.numberOfFilesToKeep = 1000;
        self.ratioOfRemove = 0.2;

        /* for testing
        self.numberOfFilesToKeep = 15;
        self.ratioOfRemove = 0.2;
         */
        self.dirName = @"alo_image";
    }
    
    return self;
}

-(void)dealloc {
    
    self.dirName = nil;
    
#if  ! __has_feature(objc_arc)
    [super dealloc];
#endif
}

+(AloImage*)sharedAloImage {
    
    static AloImage* aloImage = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        aloImage = [[self alloc] init];
    });
    
    return aloImage;
}


#define kFileFullPath @"kFileFullPath"
#define kFileCreationTimeDate @"kFileCreationTimeDate"

+(NSString*)dirName {
 
    return [AloImage sharedAloImage].dirName;
}

-(void)_removeCacheFiles {
    
    if( self.ratioOfRemove >= 1 || self.ratioOfRemove < 0 ) {
        return;
    }
    
    NSString* dirPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    if( self.dirName ) {
        dirPath = [dirPath stringByAppendingPathComponent:self.dirName];
    }
    
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dirPath error:NULL];
    
    NSError* error = nil;
    NSString* targetPath;
    NSDictionary* fileAttribute;
    
    NSMutableArray* fileDics = [[NSMutableArray alloc] init];
    
    for(NSString* aFilePath in dirContents) {
        
        targetPath = [dirPath stringByAppendingPathComponent:aFilePath];
        
        fileAttribute = [[NSFileManager defaultManager] attributesOfItemAtPath:targetPath error:&error];
        NSDate *date = (NSDate*)[fileAttribute objectForKey: NSFileCreationDate];
        
        
        [fileDics addObject:@{
                              kFileFullPath : targetPath,
                              kFileCreationTimeDate : date
                              }];
        /*
        if( [[NSFileManager defaultManager] removeItemAtPath:targetPath error:&error] == YES ) {
            NSLog(@"Removed: %@", targetPath);
        }
         */
    }
    
    if( [fileDics count] < self.numberOfFilesToKeep ) {
        return;
    }
    
    
    
    //NSLog(@"file dics: %@", fileDics);
    // createion time date의 time interval이 작은 것의 역순으로 정렬
    fileDics = (NSMutableArray*)[fileDics sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        NSDictionary* dic1 = (NSDictionary*)obj1;
        NSDictionary* dic2 = (NSDictionary*)obj2;
        
        NSDate* date1 = [dic1 objectForKey:kFileCreationTimeDate];
        NSDate* date2 = [dic2 objectForKey:kFileCreationTimeDate];
        
        NSTimeInterval timeInterval1 = [date1 timeIntervalSince1970];
        NSTimeInterval timeInterval2 = [date2 timeIntervalSince1970];
        
        if( timeInterval1 == timeInterval2 ) {
            return NSOrderedSame;
        } else if( timeInterval1 > timeInterval2 ) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSLog(@"file dics: %@", fileDics);
    
    
    NSInteger numberOfFilesToKeepAfterRemoving = self.numberOfFilesToKeep * (1.0 - self.ratioOfRemove);
    
    NSDictionary* fileDic = nil;
    NSString* filePath = nil;
    
    for( NSInteger i = [fileDics count] -1; i >= numberOfFilesToKeepAfterRemoving; i-- ) {
    
        fileDic = [fileDics objectAtIndex:i];
        filePath = [fileDic objectForKey:kFileFullPath];
        
        if( [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error] == YES ) {
            NSLog(@"Removed: %@", filePath);
        }
        
    }
}

+(void)removeCacheFiles {
    
    [[AloImage sharedAloImage] _removeCacheFiles];
}

-(void)setDirName:(NSString *)aDirName {
    
    if( self.dirName ) {
#if  ! __has_feature(objc_arc)
        [_dirName release], _dirName = nil;
#endif
    }
    
    if( aDirName == nil || [aDirName length] == 0 ) {
        return;
    }
    
#if  ! __has_feature(objc_arc)
    _dirName = [aDirName retain];
#else 
    _dirName = aDirName;
#endif
    
    // create directory
    NSString* dirPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:aDirName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:dirPath] == NO ) {
    
        NSError* error;
        if( [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:NO attributes:nil error:&error] == NO ) {
            NSLog(@"failed to create dir: %@, %@", aDirName, [error localizedDescription]);
        }
        
    }
    
}



+(void)imageWithUrl:(NSString*)aUrl WithCompletionBlock:( void(^)(BOOL bSuccess, NSError* error, UIImage* anImage) )completionHandler {
 
    // check url
    if( aUrl == nil || [aUrl length] == 0 ) {
        
        NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"Invalid URL string" forKey:NSLocalizedDescriptionKey];
        NSError* error = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:100 userInfo:aDic];
        completionHandler(NO, error, nil);
        return;
    }
    
    if( [Global fileExistWithName:aUrl InDir:[AloImage dirName]] == YES ) {
        
        UIImage* downloadedImage = [Global loadImageWithPath:aUrl InDir:[AloImage dirName]];
        
        completionHandler(YES, nil, downloadedImage);
        
    } else {
        
        NSURLSession* urlSession = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *getImageTask =
        
        [urlSession downloadTaskWithURL:[NSURL URLWithString:aUrl]
         
                      completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                          
                          if( error ) {
                              
                              NSLog(@"%@", [error localizedDescription]);
                              NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"Failed to download the image" forKey:NSLocalizedDescriptionKey];
                              
                              NSError* error2 = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:400 userInfo:aDic];
                              completionHandler(NO, error2, nil);
                              
                              
                          } else {
                              
                              UIImage* downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                              [Global saveJPEGImage:downloadedImage Path:aUrl InDir:[AloImage dirName]];
                              
                              completionHandler(YES, nil, downloadedImage);
                          }
                          
                      }];
        
        // 4
        [getImageTask resume];
    }
    
}

+(void)s:(NSString*)aUrl WithCompletionBlock:( void(^)(BOOL bSuccess, NSError* error, UIImage* anImage) )completionHandler {
    
    // check url
    if( aUrl == nil || [aUrl length] == 0 ) {
        
        NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"Invalid URL string" forKey:NSLocalizedDescriptionKey];
        NSError* error = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:100 userInfo:aDic];
        completionHandler(NO, error, nil);
        return;
    }
 
    
    NSURLSession* urlSession = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *getImageTask =
    
    [urlSession downloadTaskWithURL:[NSURL URLWithString:aUrl]
     
                  completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                      
                      if( error ) {
                          
                          NSLog(@"%@", [error localizedDescription]);
                          NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"Failed to download the image" forKey:NSLocalizedDescriptionKey];
                          
                          NSError* error2 = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:400 userInfo:aDic];
                          completionHandler(NO, error2, nil);
                          
                          
                      } else {
                          
                          UIImage* downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                          [Global saveJPEGImage:downloadedImage Path:aUrl InDir:[AloImage dirName]];
                          
                          completionHandler(YES, nil, downloadedImage);
                      }
                      
                  }];
    
    // 4
    [getImageTask resume];

    
}


+(void)imageWithUrl:(NSString*)aUrl Queue:(NSOperationQueue*)aQueue TargetView:(UIImageView*)anImageView TargetFrame:(CGRect)aTargetFrame ImageMode:(ALO_IMAGE_MODE)anImageMode ScaleFactor:(CGFloat)scaleFactor WithCompletionBlock:( void(^)(BOOL bSuccess, NSError* error) )completionHandler {
 
    // check url
    if( aUrl == nil || [aUrl length] == 0 ) {
        
        NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"Invalid URL string" forKey:NSLocalizedDescriptionKey];
        NSError* error = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:100 userInfo:aDic];
        completionHandler(NO, error);
        return;
    }
    
    // check operation queue
    /*
    if( aQueue == nil ) {
        
        NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"No operation queue" forKey:NSLocalizedDescriptionKey];
        NSError* error = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:200 userInfo:aDic];
        completionHandler(NO, error);
        return;
    }
     */
    
    // check target view
    if( anImageView == nil || [anImageView isKindOfClass:[UIImageView class]] == NO) {
        
        NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"The target view is invalid" forKey:NSLocalizedDescriptionKey];
        NSError* error = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:300 userInfo:aDic];
        completionHandler(NO, error);
        return;
    }
    
    
    if( [Global fileExistWithName:aUrl InDir:[AloImage dirName]] == YES ) {
     
        UIImage* downloadedImage = [Global loadImageWithPath:aUrl InDir:[AloImage dirName]];
        
        [self processDownloadedImage:downloadedImage TargetView:anImageView TargetFrame:aTargetFrame ImageMode:anImageMode ScaleFactor:scaleFactor];
        
        completionHandler(YES, nil);
        
    } else {
        
        NSURLSession* urlSession = [NSURLSession sharedSession];
        NSURLSessionDownloadTask *getImageTask =
        
        [urlSession downloadTaskWithURL:[NSURL URLWithString:aUrl]
         
                      completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                          
                          if( error ) {
                              
                              NSLog(@"%@", [error localizedDescription]);
                              NSDictionary* aDic = [NSDictionary dictionaryWithObject:@"Failed to download the image" forKey:NSLocalizedDescriptionKey];
                              
                              NSError* error2 = [NSError errorWithDomain:@"imageWithUrl:TargetView:ImageMode:ScaleFactor:WithCompletionBlock:" code:400 userInfo:aDic];
                              completionHandler(NO, error2);
                              
                              
                          } else {
                              
                              UIImage* downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                              [Global saveJPEGImage:downloadedImage Path:aUrl InDir:[AloImage dirName]];
                              
                              [self processDownloadedImage:downloadedImage TargetView:anImageView TargetFrame:aTargetFrame ImageMode:anImageMode ScaleFactor:scaleFactor];
                              
                              completionHandler(YES, nil);
                          }
                          
                      }];
        
        // 4
        [getImageTask resume];
    }
    
}

+(void)processDownloadedImage:(UIImage*)downloadedImage TargetView:(UIImageView*)anImageView TargetFrame:(CGRect)aTargetFrame ImageMode:(ALO_IMAGE_MODE)anImageMode ScaleFactor:(CGFloat)scaleFactor {
    
    
    CGRect newViewRect;
    
    if( anImageMode == ALO_IMAGE_MODE_NONE) {
        // nothing
    } else if( anImageMode == ALO_IMAGE_MODE_SCALE_STRETCH) {
        
        CGSize resizedSize = CGSizeMake(anImageView.frame.size.width*scaleFactor, anImageView.frame.size.height*scaleFactor);
        downloadedImage = [Global resizeImage:downloadedImage BySize:resizedSize];
        
    } else if( anImageMode == ALO_IMAGE_MODE_CROP_ADJUST) {
        
        CGRect resizedRect = CGRectMake(0, 0, anImageView.frame.size.width*scaleFactor, anImageView.frame.size.height*scaleFactor);
        downloadedImage = [Global resizeAndAdjustCropImage:downloadedImage ToRect:resizedRect];
        
    } else if( anImageMode == ALO_IMAGE_MODE_RESIZE_VIEW_FRAME ) {
        
        newViewRect = [Global frameFor:aTargetFrame BySize:downloadedImage.size];
        
        CGSize resizedSize = CGSizeMake(newViewRect.size.width*scaleFactor, newViewRect.size.height*scaleFactor);
        downloadedImage = [Global resizeImage:downloadedImage BySize:resizedSize];
        
    }
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        
        if( anImageMode == ALO_IMAGE_MODE_RESIZE_VIEW_FRAME ) {
            anImageView.frame = newViewRect;
        }
        
        anImageView.image = downloadedImage;
    }];

    
}

@end
