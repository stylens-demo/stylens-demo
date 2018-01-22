#import <Foundation/Foundation.h>
#import "SWGObject.h"

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


#import "SWGImage.h"


@protocol SWGSearchImageResponse
@end

@interface SWGSearchImageResponse : SWGObject


@property(nonatomic) NSString* message;

@property(nonatomic) NSArray<SWGImage>* data;

@end
