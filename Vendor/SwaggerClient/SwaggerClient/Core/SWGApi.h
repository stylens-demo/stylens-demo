#import <Foundation/Foundation.h>

@class SWGApiClient;

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


@protocol SWGApi <NSObject>

@property(readonly, nonatomic, strong) SWGApiClient *apiClient;

-(instancetype) initWithApiClient:(SWGApiClient *)apiClient;

-(void) setDefaultHeaderValue:(NSString*) value forKey:(NSString*)key;
-(NSString*) defaultHeaderForKey:(NSString*)key;

-(NSDictionary *)defaultHeaders;

@end