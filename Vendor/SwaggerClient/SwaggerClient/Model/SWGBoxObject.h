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


#import "SWGBox.h"


@protocol SWGBoxObject
@end

@interface SWGBoxObject : SWGObject


@property(nonatomic) NSString* _id;

@property(nonatomic) SWGBox* box;

@property(nonatomic) NSString* imageId;

@property(nonatomic) NSString* versionId;

@property(nonatomic) NSString* classCode;

@property(nonatomic) NSNumber* score;

@end