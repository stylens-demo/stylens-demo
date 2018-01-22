//
//  Global.m
//  InstaReader
//
//  Created by 기대 여 on 11. 7. 15..
//  Copyright 2011 삼성전자. All rights reserved.
//

#import "Global.h"

#include <sys/types.h>
#include <sys/sysctl.h>

#import "AppDelegate.h"
#import "ViewController.h"

#import <AudioToolbox/AudioToolbox.h>

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>


@implementation Global

+(CGRect)frameFor:(CGRect)destRect BySize:(CGSize)aSize {
	
	
	// step1. w/h 중 어디로 맞출 것인가? 주어진 rect의 것 보다 작은 것 기준
	CGFloat realHeight;
	//CGFloat realWidth;
	
	realHeight = aSize.width * destRect.size.height / aSize.height;
	//realWidth = aSize.height * destRect.size.width / aSize.width;
	
	BOOL bUseHeight = NO;
	
	if( realHeight < destRect.size.height ) {
		bUseHeight = YES;
	} else {
		bUseHeight = NO;
	}
	
	// step2. cal resize frame
	CGRect resizedRect;
	
	CGFloat resizedWidth;
	CGFloat resizedHeight;
	CGFloat resizedX;
	CGFloat resizedY;
	
	if( bUseHeight ) {
		
		resizedHeight = destRect.size.height;
		resizedWidth = aSize.width * resizedHeight / aSize.height;
		
		if( resizedWidth > destRect.size.width ) {
			resizedWidth = destRect.size.width;
			
			resizedHeight = resizedWidth*aSize.height / aSize.width;
		}
		
		
		
	} else {
		
		resizedWidth = destRect.size.width;
		resizedHeight = aSize.height * resizedWidth / aSize.width;
		
		if( resizedHeight > destRect.size.height ) {
			resizedHeight = destRect.size.height;
			
			resizedWidth = resizedHeight*aSize.width / aSize.height;
		}
		
	}
	
	resizedX =  destRect.size.width/2 -  resizedWidth/2;     //(resizedWidth - destRect.size.width) / 2.0;
	resizedY = destRect.size.height/2 - resizedHeight/2;
	
	resizedRect = CGRectMake(destRect.origin.x + resizedX, destRect.origin.y + resizedY, resizedWidth, resizedHeight);
	
	return resizedRect;
}

+(UIColor*)uiColorWithHexR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b {
	CGFloat fR = (CGFloat)r / 255.0;
	CGFloat fG = (CGFloat)g / 255.0;
	CGFloat fB = (CGFloat)b / 255.0;
	
	return [UIColor colorWithRed:fR green:fG blue:fB alpha:1.0];	
}


+(void)getR:(CGFloat*)r G:(CGFloat*)g B:(CGFloat*)b FromColor:(UIColor*)aColor {
    
    CGColorRef color = aColor.CGColor;
    
    int numComponents = (int)(CGColorGetNumberOfComponents(color));
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(color);
        *r = components[0];
        *g = components[1];
        *b = components[2];
        //components[3];
    }
    
}


+(long)hexWithUIColor:(UIColor*)aColor {
    
    CGFloat r, g, b;
    
    [Global getR:&r G:&g B:&b FromColor:aColor];
    
    //%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
    //let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
    
    //return (long)(r*255)<<16 | (long)(g*255)<<8 | (long)(b*255)<<0;
    return (((NSInteger)(r*255.0)<<16) & 0xff0000) | (((NSInteger)(g*255.0) << 8)&0x00ff00) | (((NSInteger)(b*255.0))&0x0000ff);
}

+(UIColor*)uiColorWithHex:(NSInteger)aHex {
    
    return [UIColor colorWithRed:((float)((aHex & 0xFF0000) >> 16))/255.0 \
                    green:((float)((aHex & 0x00FF00) >>  8))/255.0 \
                     blue:((float)((aHex & 0x0000FF) >>  0))/255.0 \
                    alpha:1.0];
    
}

+(UIImage*)resizeImage:(UIImage*)anImage BySize:(CGSize)aSize{
	
	UIGraphicsBeginImageContext(aSize);
	[anImage drawInRect:CGRectMake(0, 0, aSize.width, aSize.height)];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
	
}


+(UIImage*)resizeImage:(UIImage*)anImage ByRect:(CGRect)aRect{
	
	CGRect rect = CGRectMake(0.0, 0.0, aRect.size.width, aRect.size.height);
	UIGraphicsBeginImageContext(rect.size);
	[anImage drawInRect:rect];  // scales image to rect
	UIImage *resImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return resImage;
	
}

+(UIImage*)resizeImage:(UIImage*)anImage MaxSize:(CGFloat)maxSize {
    
    CGFloat resizeWidth;
    CGFloat resizeHeight;
    
    if(anImage.size.width > anImage.size.height ) {
        
        resizeWidth = maxSize;
        resizeHeight = anImage.size.height * resizeWidth / anImage.size.width;
        
    } else if( anImage.size.width < anImage.size.height) {
        
        resizeHeight = maxSize;
        resizeWidth = anImage.size.width * resizeHeight / anImage.size.height;
        
    } else {
        
        resizeWidth = maxSize;
        resizeHeight = maxSize;
        
    }
    
    resizeHeight = (NSInteger)resizeHeight;
    resizeWidth = (NSInteger)resizeWidth;
    
    //return [Global resizeAndAdjustCropImage:anImage ToRect:CGRectMake(0, 0, resizeWidth, resizeHeight)];
    return [Global resizeImage:anImage BySize:CGSizeMake(resizeWidth, resizeHeight)];
}

+(UIImage*)cropImage:(UIImage*)anImage ToRect:(CGRect)aRect {
	
	// Begin the drawing (again)
	UIGraphicsBeginImageContext(aRect.size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
	CGContextTranslateCTM(ctx, 0.0, aRect.size.height);
	CGContextScaleCTM(ctx, 1.0, -1.0);
	
	// Draw view into context
	CGRect drawRect = CGRectMake(-aRect.origin.x, aRect.origin.y - (anImage.size.height - aRect.size.height) , anImage.size.width, anImage.size.height);
	CGContextDrawImage(ctx, drawRect, anImage.CGImage);
	
	// Create the new UIImage from the context
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	
	// End the drawing
	UIGraphicsEndImageContext();
	
	return newImage;
}

+(UIImage*)resizeAndAdjustImage:(UIImage*)anImage ToRect:(CGRect)aRect {
	if( anImage == nil || aRect.size.width == 0 || aRect.size.height == 0 ) {
		return nil;
	}
	
	
	// step1. w/h 중 어디로 맞출 것인가? 주어진 rect의 것 보다 작은 것 기준
	CGFloat realHeight;
	//CGFloat realWidth;
	
	realHeight = anImage.size.width * aRect.size.height / anImage.size.height;
	//realWidth = anImage.size.height * aRect.size.width / anImage.size.width;
	
	BOOL bUseHeight = NO;
	
	if( realHeight < aRect.size.height ) {
		bUseHeight = YES;
	} else {
		bUseHeight = NO;
	}
	
	// step2. cal resize frame
	//CGRect resizedRect;
	
	CGFloat resizedWidth;
	CGFloat resizedHeight;
	CGFloat resizedX;
	CGFloat resizedY;
	
	if( bUseHeight ) {
		
		resizedHeight = aRect.size.height;
		resizedWidth = anImage.size.width * resizedHeight / anImage.size.height;
		
		resizedX = (resizedWidth - aRect.size.width) / 2.0;
		resizedY = 0.0;
		
	} else {
		
		resizedWidth = aRect.size.width;
		resizedHeight = anImage.size.height * resizedWidth / anImage.size.width;
		
		resizedX = 0.0;
		resizedY = (resizedHeight - aRect.size.height ) / 2.0;
	}
	
	//resizedRect = CGRectMake(resizedX, resizedY, resizedWidth, resizedHeight);
	
	anImage = [Global resizeImage:anImage ByRect:CGRectMake(0, 0, resizedWidth, resizedHeight)];
	anImage = [Global cropImage:anImage ToRect:CGRectMake(resizedX, resizedY, aRect.size.width, aRect.size.height)];
	
	return anImage;
	// step 3. crop and resize
	
}

+(UIImage*)resizeAndAdjustCropImage:(UIImage*)anImage ToRect:(CGRect)aRect {
	if( anImage == nil || aRect.size.width == 0 || aRect.size.height == 0 ) {
		return nil;
	}
	
	//NSLog(@"image size: %@", NSStringFromCGSize(anImage.size));
	//NSLog(@"rect: %@", NSStringFromCGRect(aRect));
	// step1. w/h 중 어디로 맞출 것인가? 주어진 rect의 것 보다 작은 것 기준
	CGFloat realHeight;
	CGFloat realWidth;
	
	realHeight = anImage.size.height*aRect.size.width / anImage.size.width;//   anImage.size.width * aRect.size.height / anImage.size.height;
	realWidth = anImage.size.width*aRect.size.height / anImage.size.height;//anImage.size.height * aRect.size.width / anImage.size.width;
	
	//NSLog(@"real height: %f", realHeight);
	//NSLog(@"real width: %f", realWidth);
	
	BOOL bHeightStandard = NO;
	
	if( realHeight > aRect.size.height ) {
		bHeightStandard = NO;
	} else {
		bHeightStandard = YES;
	}
	
	
	
	// step2. cal resize frame
    //	CGRect resizedRect;
	
	CGFloat resizedWidth;
	CGFloat resizedHeight;
    //	CGFloat resizedX;
    //	CGFloat resizedY;
	
	if( bHeightStandard ) {
		
		resizedHeight = aRect.size.height;
		resizedWidth = anImage.size.width * resizedHeight / anImage.size.height;
		
		
		
	} else {
		
		resizedWidth = aRect.size.width;
		resizedHeight = anImage.size.height * resizedWidth / anImage.size.width;
		
		
	}
	
    //resizedWidth = (NSInteger)resizedWidth;
    //resizedHeight = (NSInteger)resizedHeight;
	
	anImage = [Global resizeImage:anImage ByRect:CGRectMake(0, 0, resizedWidth, resizedHeight)];
	
	
	UIImage *newImage = nil;
	
	if( bHeightStandard ) {
		
		CGFloat diff = resizedWidth - aRect.size.width;
		
		// Begin the drawing (again)
		UIGraphicsBeginImageContext(aRect.size);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
		CGContextTranslateCTM(ctx, 0.0, aRect.size.height);
		CGContextScaleCTM(ctx, 1.0, -1.0);
		
		// Draw view into context
		CGRect drawRect = CGRectMake(-(diff/2.0),0, resizedWidth, resizedHeight);
		CGContextDrawImage(ctx, drawRect, anImage.CGImage);
		
		// Create the new UIImage from the context
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		
		// End the drawing
		UIGraphicsEndImageContext();
		
		
	} else {
		
		CGFloat diff = resizedHeight - aRect.size.height;
		
		// Begin the drawing (again)
		UIGraphicsBeginImageContext(aRect.size);
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		
		// Tanslate and scale upside-down to compensate for Quartz's inverted coordinate system
		CGContextTranslateCTM(ctx, 0.0, aRect.size.height);
		CGContextScaleCTM(ctx, 1.0, -1.0);
		
		// Draw view into context
		CGRect drawRect = CGRectMake(0,-(diff/2.0), resizedWidth, resizedHeight);
		CGContextDrawImage(ctx, drawRect, anImage.CGImage);
		
		// Create the new UIImage from the context
		newImage = UIGraphicsGetImageFromCurrentImageContext();
		
		// End the drawing
		UIGraphicsEndImageContext();
		
		
	}
	
	return newImage;
	
	
}

+(CGSize)maxSize:(CGSize)aSize MaxSide:(CGFloat)aMaxSide {
    
    if( aSize.width > aSize.height ) {

        if( aSize.width > aMaxSide ) {
            
            return CGSizeMake(aMaxSide, aSize.height * aMaxSide/aSize.width);
            
        } else {
            return aSize;
        }
        
    } else {
        
        if( aSize.height > aMaxSide ) {
            
            return CGSizeMake(aSize.width * aMaxSide/aSize.height, aMaxSide);
            
        } else {
            return aSize;
        }
    }
    
}

+(CGFloat)calcImageHeight:(UIImage*)anImage {
    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    return app.screenRect.size.width * anImage.size.height / anImage.size.width;
}

// ref: http://theiphonewiki.com/wiki/Models
+(CGSize)maxSize:(CGSize)aSize {
    
    NSString* deviceType = [Global platform];
    
    long maxRes;
    
    //////////////////////////////////////////////////////////
    // iPhone인 경우
    
    // iPhone 6S, 6S+ 이상인 경우 12MB
    if( [Global string:deviceType startWith:@"iPhone"] && [@"iPhone8" compare:deviceType] == NSOrderedAscending) {
        NSLog(@"iPhone 6S <= ");
        
        maxRes = 3024*4032;
    
    
    // iPhone 5S 이상인 경우 8MB
    } else if( [Global string:deviceType startWith:@"iPhone"] && [@"iPhone6" compare:deviceType] == NSOrderedAscending) {
        NSLog(@"iPhone 5S <= ");
        
        maxRes = 2448*3264;
        
        // iPhone 5 이상인 경우 (5C 포함) 8MB
    } else if( [Global string:deviceType startWith:@"iPhone"] && [@"iPhone5" compare:deviceType] == NSOrderedAscending) {
        
        NSLog(@"iPhone 5 < ");
        
        maxRes = 2448*3264;
    
        // iPhone 4S 8MB
    } else if( [Global string:deviceType startWith:@"iPhone"] && [@"iPhone4" compare:deviceType] == NSOrderedAscending) {
        
        NSLog(@"iPhone 4S < ");
        
        maxRes = 2448*3264;
        
        // iPhone 4 5MB
    } else if( [Global string:deviceType startWith:@"iPhone"] && [@"iPhone3" compare:deviceType] == NSOrderedAscending) {
        
        NSLog(@"iPhone 4 < ");
        
        maxRes = 1936*2592;
        
        // iPhone 3GS 3MB
    } else if( [Global string:deviceType startWith:@"iPhone"] && [@"iPhone2" compare:deviceType] == NSOrderedAscending) {
        
        NSLog(@"iPhone 3GS < ");
        
        maxRes = 1536*2048;
    
        
        
        
        //////////////////////////////////////////////////////////
        // iPod Touch 인 경우 5MB
    } else if( [Global string:deviceType startWith:@"iPod"] && [@"iPod5" compare:deviceType] == NSOrderedAscending) {
        
        NSLog(@"iPod Touch 5th <");
        maxRes = 1936*2592;

        
        
        // iPad Air2 부터 8MB (2448x3264)
        // iPad 5MB
    } else if( [Global string:deviceType startWith:@"iPad"]
              && ( [@"iPad5,3" compare:deviceType] == NSOrderedSame || [@"iPad5,3" compare:deviceType] == NSOrderedAscending )) {
        // ipad3
        NSLog(@"iPad Air2 < ");
        maxRes = 2448*3264;
        
        // iPad 5MB
    } else if( [Global string:deviceType startWith:@"iPad"]
              && ( [@"iPad2,5" compare:deviceType] == NSOrderedSame || [@"iPad2,5" compare:deviceType] == NSOrderedAscending )) {
        // ipad3
        NSLog(@"iPad3 / iPad Mini < ");
        maxRes = 1936*2592;

        
    } else {
        
        NSLog(@"Default Device");
        maxRes = 1224*1224;
    }
    
    
    
    if( aSize.width * aSize.height > maxRes) {
        
        long double ratio = sqrtl((maxRes*0.99)/(aSize.width*aSize.height));
        
        aSize = CGSizeMake((long)(aSize.width * ratio), (long)(aSize.height*ratio));
    }
    
    /*
    while( aSize.width*aSize.height > maxRes ) {
        
        aSize = CGSizeMake(aSize.width * 0.95, aSize.height*0.95);
    }
     */
    
    return aSize;
}


+(void)savePNGImage:(UIImage*)anImage Path:(NSString*)aPath {
	if( anImage == nil || aPath == nil ) {
		return;
	}
	
	NSString *fileName = [NSString stringWithString:aPath];
	fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	
	NSData* anImageData = [NSData dataWithData:UIImagePNGRepresentation(anImage)];
	[anImageData writeToFile:finalPath atomically:YES];
}

+(void)saveJPEGImage:(UIImage*)anImage Path:(NSString*)aPath {
	if( anImage == nil || aPath == nil ) {
		return;
	}
	
	NSString *fileName = [NSString stringWithString:aPath];
	fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	
	NSData* anImageData = [NSData dataWithData:UIImageJPEGRepresentation(anImage, 1.0)]; // UIImagePNGRepresentation(anImage);
	[anImageData writeToFile:finalPath atomically:YES];
	
}

+(void)saveJPEGImage:(UIImage*)anImage Path:(NSString*)aPath InDir:(NSString*)aDir {
    
    if( anImage == nil || aPath == nil ) {
        return;
    }
    
    NSString *fileName = [NSString stringWithString:aPath];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( aDir || [aDir length] > 0 ) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:aDir];
    }
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSData* anImageData = [NSData dataWithData:UIImageJPEGRepresentation(anImage, 1.0)]; // UIImagePNGRepresentation(anImage);
    [anImageData writeToFile:finalPath atomically:YES];

}

+(void)saveData:(NSData*)aData Path:(NSString*)aPath InDir:(NSString*)aDir {
    
    if( aData == nil || aData == nil ) {
        return;
    }
    
    NSString *fileName = [NSString stringWithString:aPath];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( aDir || [aDir length] > 0 ) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:aDir];
    }
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    [aData writeToFile:finalPath atomically:YES];
}

+(NSString*)fullPath:(NSString*)aPath InDir:(NSString*)aDir {
 
    if( aPath == nil || [aPath length] == 0 ) {
        return @"";
    }
    
    NSString *fileName = [NSString stringWithString:aPath];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( aDir || [aDir length] > 0 ) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:aDir];
    }

    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(UIImage*)loadImageWithPath:(NSString*)aPath {
	if( aPath == nil ) {
		return nil;
	}
	
	NSString *fileName = [NSString stringWithString:aPath];
	fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
	
	
	NSData* data = [NSData dataWithContentsOfFile:finalPath];
	
	return [UIImage imageWithData:data];
}

+(UIImage*)loadImageWithPath:(NSString*)aPath InDir:(NSString*)aDir {
    
    if( aPath == nil ) {
        return nil;
    }
    
    NSString *fileName = [NSString stringWithString:aPath];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( aDir || [aDir length] > 0 ) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:aDir];
    }

    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    
    NSData* data = [NSData dataWithContentsOfFile:finalPath];
    
    return [UIImage imageWithData:data];

    
    
}

+(void)removeFileWithPath:(NSString*)aPath {
    if( aPath == nil || [aPath length] == 0 ) {
        return;
    }
    
    NSString *fileName = [NSString stringWithString:aPath];
	fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
	fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //NSFileManager* aFileManager;
    if( [[NSFileManager defaultManager] fileExistsAtPath:finalPath] == NO ) {
        return;
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:finalPath error:nil];
    }
}

+(void)removeFileWithPath:(NSString *)aPath InDir:(NSString*)aDir {
    
    NSString *fileName = [NSString stringWithString:aPath];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( aDir != nil ) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:aDir];
    }
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if( [[NSFileManager defaultManager] fileExistsAtPath:finalPath] == NO ) {
        return;
    } else {
        [[NSFileManager defaultManager] removeItemAtPath:finalPath error:nil];
    }
}

+(BOOL)fileExistWithName:(NSString*)aFileName {
    
    NSString *fileName = [NSString stringWithString:aFileName];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //NSFileManager* aFileManager;
    return [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
}

+(BOOL)fileExistWithName:(NSString*)aFileName InDir:(NSString*)aDir {
    
    NSString *fileName = [NSString stringWithString:aFileName];
    fileName = [fileName stringByReplacingOccurrencesOfString:@":" withString:@"_"];
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    if( aDir != nil ) {
        documentsDirectory = [documentsDirectory stringByAppendingPathComponent:aDir];
    }
    NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    //NSFileManager* aFileManager;
    return [[NSFileManager defaultManager] fileExistsAtPath:finalPath];
    
}

+(NSString*)copyToDirectoryImage:(UIImage*)anImage DirName:(NSString*)aDirName FileName:(NSString*)aFileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", aDirName]];
    
    NSString* fullPath = [dataPath stringByAppendingPathComponent:aFileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = UIImageJPEGRepresentation(anImage, 1.0);
    if( [fileManager createFileAtPath:fullPath contents:data attributes:nil] == NO ) {
        return nil;
    } else {
        return fullPath;
    }
}

+(UIImage*)thumbImageOfVideoUrl:(NSURL*)aVideoUrl {
    
    // get the thumbnail of movie
    AVAsset *asset = [AVAsset assetWithURL:aVideoUrl];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0, 600);
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
}


#pragma mark -
#pragma mark UIView

+(CGAffineTransform)makeTransformX:(CGFloat)xScale Y:(CGFloat)yScale Theta:(CGFloat)theta TX:(CGFloat)tX TY:(CGFloat)tY {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform.a = xScale * cos(theta);
    transform.b = yScale * sin(theta);
    transform.c = xScale * -sin(theta);
    transform.d = yScale * cos(theta);
    transform.tx = tX;
    transform.ty = tY;
    
    return transform;
}

+(CGAffineTransform)createTransformWithTransA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c D:(CGFloat)d TX:(CGFloat)tx TY:(CGFloat)ty {
    
    
    CGFloat xScale = sqrt(a * a + c * c);
    
    CGFloat yScale = sqrt(b * b + d * d);
    
    CGFloat rotation = atan2f(b, a);
    
    return [Global makeTransformX:xScale Y:yScale Theta:rotation TX:tx TY:ty];
    
}


#pragma mark -
#pragma mark Data Save & Load
+(void)saveArray:(NSMutableArray*)anArray ForKey:(NSString*)aKey {
    if( anArray == nil || aKey == nil ) {
        return;
    }
    
    NSString* dataPath = [[NSString stringWithFormat:@"~/Documents/%@", aKey] stringByExpandingTildeInPath];
    
    [anArray writeToFile:dataPath atomically:YES];
    
}

+(NSMutableArray*)loadArrayForKey:(NSString*)aKey {
    if( aKey == nil ) {
        return nil;
    }
    
    NSString* dataPath = [[NSString stringWithFormat:@"~/Documents/%@", aKey] stringByExpandingTildeInPath];
    
    return [NSMutableArray arrayWithContentsOfFile:dataPath];
}


+(void)saveDic:(NSMutableDictionary*)aDic ForKey:(NSString*)aKey {
    if( aDic == nil || aKey == nil ) {
        return;
    }
    
    NSString* dataPath = [[NSString stringWithFormat:@"~/Documents/%@", aKey] stringByExpandingTildeInPath];
    
    [aDic writeToFile:dataPath atomically:YES];
    
}

+(NSMutableDictionary*)loadDicForKey:(NSString*)aKey {
    if( aKey == nil ) {
        return nil;
    }
    
    NSString* dataPath = [[NSString stringWithFormat:@"~/Documents/%@", aKey] stringByExpandingTildeInPath];
    
    return [NSMutableDictionary dictionaryWithContentsOfFile:dataPath];
}

// NSPropertyListSerialization 이용
+(NSString*)getFilePathForkey:(NSString*)aKey {
    if( aKey == nil ) {
        return nil;
    }
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *finalPath = [documentsDirectory stringByAppendingPathComponent:aKey];
	
	return finalPath;
}


+(NSMutableDictionary*)restoreDataForKey:(NSString*)aKey {
    
    if( aKey == nil ) {
        return nil;
    }
    
	NSString *finalPath = nil;
	
	NSData *plistData; 
	NSError *error; 
	NSPropertyListFormat format; 
	
	// normal
	finalPath = [Global getFilePathForkey:aKey];
	plistData = [NSData dataWithContentsOfFile:finalPath]; 
    
    NSMutableDictionary* tempDic = nil;
    if( plistData ) {
        /*
         // propertyListFromData will be deprecated soon.
         dataDic = [NSPropertyListSerialization propertyListFromData:plistData 
         mutabilityOption:NSPropertyListMutableContainers 
         format:&format 
         errorDescription:&error]; 
         */
        tempDic = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListMutableContainers format:&format error:&error];
        
    }
    
	if(tempDic == nil) { 
//		tempDic = [[[NSMutableDictionary alloc] init] autorelease];
        tempDic = [[NSMutableDictionary alloc] init];
	}
    
    return tempDic;
}

+(void)storeData:(NSMutableDictionary*)aDic ForKey:(NSString*)aKey {
    
    if( aDic == nil || aKey == nil ) {
        return;
    }
    
	NSString *finalPath = nil;
	NSData *xmlData; 
	NSError *error; 
	
	// normal
	if(aDic != nil ) {
		
		finalPath = [Global getFilePathForkey:aKey];
		
        /*
         dataFromPropertyList will be deprecated soon.
         xmlData = [NSPropertyListSerialization dataFromPropertyList:aDic 
         format:NSPropertyListXMLFormat_v1_0 
         errorDescription:&error]; 
         */
        
        xmlData = [NSPropertyListSerialization dataWithPropertyList:aDic format:NSPropertyListXMLFormat_v1_0 options:0 error:&error];
        
        
		if(xmlData) { 
			//NSLog(@"No error creating XML data."); 
			[xmlData writeToFile:finalPath atomically:YES]; 
		} 
		else { 
			NSLog(@"%@", error); 
//			[error release]; 
		}
	}
}

#pragma mark - 
#pragma makr Date
+(NSString*)dateString:(NSDate*)aDate {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:aDate];
//    [dateFormatter release], dateFormatter = nil;
    dateFormatter = nil;
    
    return dateString;
}

+(NSString*)timeString:(NSDate*)aDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString = [dateFormatter stringFromDate:aDate];
//    [dateFormatter release], dateFormatter = nil;
    dateFormatter = nil;
    
    return dateString;
}

+(NSString*)getDateStringWithTime:(long)aTime {    
    
    /*
     NSString* aString = nil;
     NSDateFormatter *df = [[NSDateFormatter alloc] init];
     df.dateStyle = NSDateFormatterFullStyle;
     aString = [NSString stringWithFormat:@"%@",
     [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:aTime]]];
     [df release];
     
     return aString;
     */
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd EEE HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:aTime]];
//    [dateFormatter release], dateFormatter = nil;
    dateFormatter = nil;
    
    return dateString;
    
}

+(NSString*)getAgoTimeString:(long)timeSpan {
    
    return [Global getTimeString: ( [[NSDate date] timeIntervalSince1970] - timeSpan ) ];
}

// XXX ago following IG's way
+(NSString*)getTimeString:(long)timeSpan {
    
    NSString* aStr = nil;
    
    if( timeSpan == 0 ) {
        return @"N/A";
    }
    
    // sec
    if( timeSpan < 60 ) {
        aStr = [NSString stringWithFormat:@"%lds", timeSpan];
        
    } else {
        timeSpan = timeSpan / 60;
        // min
        if( timeSpan < 60 ) {
            aStr = [NSString stringWithFormat:@"%ldm", timeSpan];
            
        } else {
            timeSpan = timeSpan / 60;
            // housre
            if( timeSpan < 24 ) {
                aStr = [NSString stringWithFormat:@"%ldh", timeSpan];
            } else {
                timeSpan = timeSpan / 24;
                // day
                if( timeSpan < 7 ) {
                    aStr = [NSString stringWithFormat:@"%ldd", timeSpan];
                } else {
                    timeSpan = timeSpan / 7;
                    // week
                    aStr = [NSString stringWithFormat:@"%ldw", timeSpan];
                    /*
                     if( timeSpan < 4 ) {
                     aStr = [NSString stringWithFormat:@"%ldw", timeSpan];
                     } else {
                     timeSpan = timeSpan / 4;
                     // month
                     if( timeSpan < 12 ) {
                     aStr = [NSString stringWithFormat:@"%ldm", timeSpan];
                     } else {
                     timeSpan = timeSpan / 12;
                     // year
                     aStr = [NSString stringWithFormat:@"%ldy", timeSpan];
                     }
                     }
                     */
                }
            }
        }
        
    }
    
    return aStr;
}

#pragma mark -
#pragma mark - number
+ (NSString *) getStringNumberFormatWithIntValue:(int)number{
    return [NSNumberFormatter localizedStringFromNumber:[NSNumber numberWithInt:number] numberStyle:NSNumberFormatterDecimalStyle];
}

+ (NSString *) getStringNumberFormat:(NSNumber *)number{
    return [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterDecimalStyle];
}

#pragma mark -
#pragma mark - currency
+ (NSString *) getCurrencyUnit:(NSString *)unitString{
    if ([unitString isEqualToString:@"KRW"]) {
        return @"원";
    }
    return @"원";
}

+(NSString*)fileExtention:(NSString*)aStr {
        
    if( aStr == nil || [aStr length] == 0 ) {
        return @"";
    }

    NSRange dotRange = [aStr rangeOfString:@"."];
    
    if( dotRange.location == NSNotFound ) {
        return @"";
    }
    
    if( dotRange.location + 1 >= [aStr length] ) {
        return @"";
    }
    
    return [aStr substringFromIndex:(dotRange.location+1)];
}



+(BOOL)string:(NSString*)aStr startWith:(NSString*)prefix {
    
    if( [aStr length] == 0 || [prefix length] == 0 ) {
        return NO;
    }
    
    NSRange range = [aStr rangeOfString:prefix];
    
    if( range.location == 0 ) {
        return YES;
    } else {
        return NO;
    }
}

+(BOOL)string:(NSString*)aStr ContainString:(NSString*)subStr {
    if( aStr == nil || subStr == nil || [aStr length] == 0 || [subStr length] == 0 ) {
        return NO;
    }
    
    NSRange retRange = [aStr rangeOfString:subStr];
    
    return retRange.location != NSNotFound;
}

+(void)addTapGesture:(UIView*)aView Taget:(id)target action:(SEL)aSel {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:aSel];
    [aView addGestureRecognizer:tapGesture];
//    [tapGesture release], tapGesture = nil;
    tapGesture = nil;
}

//+(void)showMsg:(NSString*)aMsg Title:(NSString*)aTitle {
//    
//    // before 9.0
//    /*
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alert show];
//    [alert release], alert = nil;
//    */
//    
//    
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:aTitle message:aMsg preferredStyle:UIAlertControllerStyleAlert];
//    
//    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [app.baseViewController presentViewController:alert animated:YES completion:nil];
////    [alert release], alert = nil;
//    alert = nil;
//    
//}
//
//+(void)showMsg:(NSString*)aMsg Title:(NSString*)aTitle OnMainThread:(BOOL)bOnMainThread {
//
//    // beofer 9.0
//    /*
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:aTitle message:aMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//    if( bOnMainThread == YES ) {
//        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
//    } else {
//        [alert show];
//    }
//    
//    
//    [alert release], alert = nil;
//     */
//    
//    UIAlertController * alert = [UIAlertController alertControllerWithTitle:aTitle message:aMsg preferredStyle:UIAlertControllerStyleAlert];
//    
//    AppDelegate* app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    
//    if( bOnMainThread == YES ) {
//        
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            
//            [app.baseViewController presentViewController:alert animated:YES completion:nil];
//        }];
//        
//    } else {
//        [app.baseViewController presentViewController:alert animated:YES completion:nil];
//    }
//    
////    [alert release], alert = nil;
//    alert = nil;
//    
//}

+(void)setTitle:(NSString*)aTitle Font:(UIFont*)aFont ToButton:(UIButton*)aButton {
    
    NSDictionary *aDic = @{NSFontAttributeName: aFont,
                           NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    NSAttributedString* anAttributedString = [[NSAttributedString alloc] initWithString:aTitle attributes:aDic];
    
    NSMutableAttributedString *aMutableAttributedString = [[NSMutableAttributedString alloc] init];
    [aMutableAttributedString appendAttributedString:anAttributedString];
//    [anAttributedString release], anAttributedString = nil;
    anAttributedString = nil;
    
    [aButton setAttributedTitle:aMutableAttributedString forState:UIControlStateNormal];
//    [aMutableAttributedString release], aMutableAttributedString = nil;
    aMutableAttributedString = nil;
}

+(NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+(SC_TYPE)screenType {
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if( screenBounds.size.width > screenBounds.size.height) {
        screenBounds = CGRectMake(screenBounds.origin.x, screenBounds.origin.y, screenBounds.size.height, screenBounds.size.width);
    }
    
    
    if( screenBounds.size.width == 414) {
        NSLog(@"Screen Type: 5.5inch");
        return SC_TYPE_5_5;
    } else if( screenBounds.size.width == 375) {
        if( screenBounds.size.height == 667) {
            NSLog(@"Screen Type: 4.7inch");
            return SC_TYPE_4_7;
        }
        NSLog(@"Screen Type: 5.8inch");
        return SC_TYPE_5_8;
    } else if( screenBounds.size.height == 568) {
        NSLog(@"Screen Type: 4inch");
        return SC_TYPE_4;
    } else if( screenBounds.size.height == 480) {
        NSLog(@"Screen Type: 3.5inch");
        return SC_TYPE_3_5;
    } else if( screenBounds.size.height == 1024){
        NSLog(@"Screen Type: 9.7inch");
        return SC_TYPE_iPad;
    } else if( screenBounds.size.height == 1366 ) {
        return  SC_TYPE_12_9;
    }
    
    
    return SC_TYPE_NONE;
    
}

+(CGRect)screenRect {
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    
    if( screenBounds.size.width > screenBounds.size.height) {
        return CGRectMake(screenBounds.origin.x, screenBounds.origin.y, screenBounds.size.height, screenBounds.size.width);
    } else {
        return screenBounds;
    }
    
}

+(UIFont*)settingFontWithScreenRatio:(CGFloat)ratio {
    
    return [UIFont fontWithName:@"MyriadPro-Regular" size:13.0*ratio];
//    return [UIFont systemFontOfSize:13.0*ratio];
}




+(BOOL)bUsing3xImage {
    
    NSString* deviceType = [Global platform];
    
    if( [@"iPhone7,1" compare:deviceType] == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark Sound

+(void)playSoundName:(NSString*)aName Ext:(NSString*)anExt {
    
    
    /*
     AVAudioPlayer* timerSound = [[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:aName ofType:anExt]] error:nil] autorelease];
     
     [timerSound play];
     
     
     return;
     */
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:aName ofType:anExt];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    SystemSoundID audioEffect;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    // Using GCD, we can use a block to dispose of the audio effect without using a NSTimer or something else to figure out when it'll be finished playing.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AudioServicesDisposeSystemSoundID(audioEffect);
    });
    
    
}

#pragma mark -
#pragma mark text
+(CGSize)textSize:(NSString*)aText Font:(UIFont*)aFont {
    
    CGSize textSize = CGSizeMake(1024, CGFLOAT_MAX);
    
    CGRect frame = [aText boundingRectWithSize:textSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{ NSFontAttributeName:aFont }
                                       context:nil];
    
    return frame.size;
}

+(CGSize)textSize:(NSString*)aText Font:(UIFont*)aFont Width:(CGFloat)aWidth {
    
    CGSize textSize = CGSizeMake(aWidth, CGFLOAT_MAX);
    
    CGRect frame = [aText boundingRectWithSize:textSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{ NSFontAttributeName:aFont }
                                       context:nil];
    
    return frame.size;
}

+(CGFloat)dateHeight {
    return 20;
}

@end
