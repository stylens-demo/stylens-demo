#import <Foundation/Foundation.h>
#import "SWGGetImageResponse.h"
#import "SWGGetImagesResponse.h"
#import "SWGApi.h"

/**
* style-api
* This is a API document for Stylens Service
*
* OpenAPI spec version: 0.0.2
* Contact: master@bluehack.net
*
* NOTE: This class is auto generated by the swagger code generator program.
* https://github.com/swagger-api/swagger-codegen.git
* Do not edit the class manually.
*/



@interface SWGImageApi: NSObject <SWGApi>

extern NSString* kSWGImageApiErrorDomain;
extern NSInteger kSWGImageApiMissingParamErrorCode;

-(instancetype) initWithApiClient:(SWGApiClient *)apiClient NS_DESIGNATED_INITIALIZER;

/// Get Image by hostCode and productNo
/// Returns Image belongs to a Host and productNo
///
/// @param hostCode 
/// @param productNo 
/// 
///  code:200 message:"successful operation",
///  code:400 message:"Invalid input supplied",
///  code:404 message:"Host or productNo not found"
///
/// @return SWGGetImageResponse*
-(NSURLSessionTask*) getImageByHostcodeAndProductNoWithHostCode: (NSString*) hostCode
    productNo: (NSString*) productNo
    completionHandler: (void (^)(SWGGetImageResponse* output, NSError* error)) handler;


/// Find Images by ID
/// Returns a single Image
///
/// @param imageId ID of Image to return
/// 
///  code:200 message:"successful operation",
///  code:400 message:"Invalid ID supplied",
///  code:404 message:"Image not found"
///
/// @return SWGGetImageResponse*
-(NSURLSessionTask*) getImageByIdWithImageId: (NSString*) imageId
    completionHandler: (void (^)(SWGGetImageResponse* output, NSError* error)) handler;


/// Get Images by imageId
/// Returns similar Images with imageId
///
/// @param imageId 
/// @param offset  (optional)
/// @param limit  (optional)
/// 
///  code:200 message:"successful operation",
///  code:400 message:"Invalid input supplied",
///  code:404 message:"imageId or objectId not found"
///
/// @return SWGGetImagesResponse*
-(NSURLSessionTask*) getImagesWithImageId: (NSString*) imageId
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;


/// Query to search images by object id
/// 
///
/// @param objectId 
/// @param offset  (optional)
/// @param limit  (optional)
/// 
///  code:200 message:"successful operation",
///  code:400 message:"Invalid input"
///
/// @return SWGGetImagesResponse*
-(NSURLSessionTask*) getImagesByObjectIdWithObjectId: (NSString*) objectId
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;


/// Query to search images
/// 
///
/// @param file User&#39;s Image file to upload (only support jpg format yet) (optional)
/// @param offset  (optional)
/// @param limit  (optional)
/// 
///  code:200 message:"successful operation",
///  code:400 message:"Invalid input"
///
/// @return SWGGetImagesResponse*
-(NSURLSessionTask*) getImagesByUserImageFileWithFile: (NSURL*) file
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;


/// Get Images by userImageId and objectIndex
/// Returns Images belongs to a userImageId and objectIndex
///
/// @param userImageId 
/// @param objectIndex 
/// 
///  code:200 message:"successful operation",
///  code:400 message:"Invalid input supplied",
///  code:404 message:"userImageId or objectIndex not found"
///
/// @return SWGGetImagesResponse*
-(NSURLSessionTask*) getImagesByUserImageIdAndObjectIndexWithUserImageId: (NSString*) userImageId
    objectIndex: (NSNumber*) objectIndex
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;



@end