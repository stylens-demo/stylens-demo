//
//  Global.h
//  InstaReader
//
//  Created by 기대 여 on 11. 7. 15..
//  Copyright 2011 삼성전자. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    
    SC_TYPE_NONE,
    
    SC_TYPE_3_5,
    SC_TYPE_4,
    SC_TYPE_4_7,
    SC_TYPE_5_5,
    SC_TYPE_5_8, // iPhone X
    
    SC_TYPE_iPad,
    SC_TYPE_9_7 = SC_TYPE_iPad,
    
    SC_TYPE_12_9
    
} SC_TYPE;

@interface Global : NSObject {
    
}

// color
+(UIColor*)uiColorWithHexR:(NSInteger)r G:(NSInteger)g B:(NSInteger)b;
+(void)getR:(CGFloat*)r G:(CGFloat*)g B:(CGFloat*)b FromColor:(UIColor*)aColor;

+(long)hexWithUIColor:(UIColor*)aColor;
+(UIColor*)uiColorWithHex:(NSInteger)aHex;

// image
+(CGRect)frameFor:(CGRect)destRect BySize:(CGSize)aSize;
+(UIImage*)resizeImage:(UIImage*)anImage BySize:(CGSize)aSize;
+(UIImage*)resizeImage:(UIImage*)anImage ByRect:(CGRect)aRect;
+(UIImage*)resizeAndAdjustImage:(UIImage*)anImage ToRect:(CGRect)aRect;
+(UIImage*)cropImage:(UIImage*)anImage ToRect:(CGRect)aRect;

+(UIImage*)resizeAndAdjustCropImage:(UIImage*)anImage ToRect:(CGRect)aRect;

+(CGSize)maxSize:(CGSize)aSize MaxSide:(CGFloat)aMaxSide;

+(CGSize)maxSize:(CGSize)aSize;

+(CGFloat)calcImageHeight:(UIImage*)anImage;

//[Global cropImage:anImage MaxSide:kNormalResolution];
+(UIImage*)resizeImage:(UIImage*)anImage MaxSize:(CGFloat)maxSize;

// save load image
+(void)savePNGImage:(UIImage*)anImage Path:(NSString*)aPath;
+(void)saveJPEGImage:(UIImage*)anImage Path:(NSString*)aPath;
+(void)saveJPEGImage:(UIImage*)anImage Path:(NSString*)aPath InDir:(NSString*)aDir;
+(UIImage*)loadImageWithPath:(NSString*)aPath;
+(UIImage*)loadImageWithPath:(NSString*)aPath InDir:(NSString*)aDir;

+(UIImage*)thumbImageOfVideoUrl:(NSURL*)aVideoUrl;

// save data
+(void)saveData:(NSData*)aData Path:(NSString*)aPath InDir:(NSString*)aDir;

+(NSString*)fullPath:(NSString*)aPath InDir:(NSString*)aDir;

// file io
+(void)removeFileWithPath:(NSString*)aPath;
+(void)removeFileWithPath:(NSString *)aPath InDir:(NSString*)aDir;
+(BOOL)fileExistWithName:(NSString*)aFileName;
+(BOOL)fileExistWithName:(NSString*)aFileName InDir:(NSString*)aDir;
+(NSString*)copyToDirectoryImage:(UIImage*)anImage DirName:(NSString*)aDirName FileName:(NSString*)aFileName;

// UIViuew
+(CGAffineTransform)makeTransformX:(CGFloat)xScale Y:(CGFloat)yScale Theta:(CGFloat)theta TX:(CGFloat)tX TY:(CGFloat)tY;
+(CGAffineTransform)createTransformWithTransA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c D:(CGFloat)d TX:(CGFloat)tx TY:(CGFloat)ty;

// save & load dics
+(void)saveArray:(NSMutableArray*)anArray ForKey:(NSString*)aKey;
+(NSMutableArray*)loadArrayForKey:(NSString*)aKey;
+(void)saveDic:(NSMutableDictionary*)aDic ForKey:(NSString*)aKey;
+(NSMutableDictionary*)loadDicForKey:(NSString*)aKey;

// NSPropertyListSerialization 이용
+(NSString*)getFilePathForkey:(NSString*)aKey;
+(NSMutableDictionary*)restoreDataForKey:(NSString*)aKey;
+(void)storeData:(NSMutableDictionary*)aDic ForKey:(NSString*)aKey;

//date
+(NSString*)dateString:(NSDate*)aDate;
+(NSString*)timeString:(NSDate*)aDate;
+(NSString*)getDateStringWithTime:(long)aTime;
+(NSString*)getTimeString:(long)timeSpan;
+(NSString*)getAgoTimeString:(long)timeSpan;

// number
+ (NSString *) getStringNumberFormatWithIntValue:(int)number;
+ (NSString *) getStringNumberFormat:(NSNumber *)number;

// currency
+ (NSString *) getCurrencyUnit:(NSString *)unitString;

// String
+(BOOL)string:(NSString*)aStr ContainString:(NSString*)subStr;
+(NSString*)fileExtention:(NSString*)aStr;
+(BOOL)string:(NSString*)aStr startWith:(NSString*)prefix;


+(void)addTapGesture:(UIView*)aView Taget:(id)target action:(SEL)aSel;

// Etc
+(void)showMsg:(NSString*)aMsg Title:(NSString*)aTitle;
+(void)showMsg:(NSString*)aMsg Title:(NSString*)aTitle OnMainThread:(BOOL)bOnMainThread;

+(void)setTitle:(NSString*)aTitle Font:(UIFont*)aFont ToButton:(UIButton*)aButton;

+(NSString*)platform;

+(SC_TYPE)screenType;
+(CGRect)screenRect;

+(UIFont*)settingFontWithScreenRatio:(CGFloat)ratio;





+(BOOL)bUsing3xImage;

// sound
+(void)playSoundName:(NSString*)aName Ext:(NSString*)anExt;

+(CGSize)textSize:(NSString*)aText Font:(UIFont*)aFont;
+(CGSize)textSize:(NSString*)aText Font:(UIFont*)aFont Width:(CGFloat)aWidth;
@end


/*
 *  System Versioning Preprocessor Macros
 */

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)




#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
///


#define cMainFontName @"HelveticaNeue-Light"
#define cToolbarTitleFontSize 18

#define cMainMintColor [Global uiColorWithHexR:57 G:181 B:181]

#define cToolbarTitleFontSize 18

#define cMainMintColor [Global uiColorWithHexR:57 G:181 B:181]

#define cMainDarkBlue [Global uiColorWithHexR:34 G:59 B:76]
#define cMainOrangeColor [Global uiColorWithHexR:247 G:159 B:26]
#define cSubMenuBGColor [Global uiColorWithHexR:51 G:105 B:141]

#define cMainFontBoldName @"AppleSDGothicNeo-Bold"
#define cMainFontMediumName @"AppleSDGothicNeo-Medium"
#define cMainFontHeavyName @"AppleSDGothicNeo-Heavy"


typedef enum {
    
    CELL_POS_TOP,
    CELL_POS_MID,
    CELL_POS_BOTTOM,
    
} CELL_POS;


typedef void(^CompletionHandler)(BOOL bSuccess, NSError* anError, NSDictionary* aDic);

