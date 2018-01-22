#import <Foundation/Foundation.h>
#import "SWGGetObjectsResponse.h"
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



@interface SWGPlaygroundApi: NSObject <SWGApi>

extern NSString* kSWGPlaygroundApiErrorDomain;
extern NSInteger kSWGPlaygroundApiMissingParamErrorCode;

-(instancetype) initWithApiClient:(SWGApiClient *)apiClient NS_DESIGNATED_INITIALIZER;

/// 
/// 
///
/// @param file User&#39;s Image file to upload (only support jpg format yet)
/// 
///  code:200 message:"successful operation",
///  code:400 message:"Invalid input"
///
/// @return SWGGetObjectsResponse*
-(NSURLSessionTask*) getPlaygroundObjectsByUserImageFileWithFile: (NSURL*) file
    completionHandler: (void (^)(SWGGetObjectsResponse* output, NSError* error)) handler;



@end