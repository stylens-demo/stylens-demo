#import "SWGImageApi.h"
#import "SWGQueryParamCollection.h"
#import "SWGApiClient.h"
#import "SWGGetImageResponse.h"
#import "SWGGetImagesResponse.h"


@interface SWGImageApi ()

@property (nonatomic, strong, readwrite) NSMutableDictionary *mutableDefaultHeaders;

@end

@implementation SWGImageApi

NSString* kSWGImageApiErrorDomain = @"SWGImageApiErrorDomain";
NSInteger kSWGImageApiMissingParamErrorCode = 234513;

@synthesize apiClient = _apiClient;

#pragma mark - Initialize methods

- (instancetype) init {
    return [self initWithApiClient:[SWGApiClient sharedClient]];
}


-(instancetype) initWithApiClient:(SWGApiClient *)apiClient {
    self = [super init];
    if (self) {
        _apiClient = apiClient;
        _mutableDefaultHeaders = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark -

-(NSString*) defaultHeaderForKey:(NSString*)key {
    return self.mutableDefaultHeaders[key];
}

-(void) setDefaultHeaderValue:(NSString*) value forKey:(NSString*)key {
    [self.mutableDefaultHeaders setValue:value forKey:key];
}

-(NSDictionary *)defaultHeaders {
    return self.mutableDefaultHeaders;
}

#pragma mark - Api Methods

///
/// Get Image by hostCode and productNo
/// Returns Image belongs to a Host and productNo
///  @param hostCode  
///
///  @param productNo  
///
///  @returns SWGGetImageResponse*
///
-(NSURLSessionTask*) getImageByHostcodeAndProductNoWithHostCode: (NSString*) hostCode
    productNo: (NSString*) productNo
    completionHandler: (void (^)(SWGGetImageResponse* output, NSError* error)) handler {
    // verify the required parameter 'hostCode' is set
    if (hostCode == nil) {
        NSParameterAssert(hostCode);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"hostCode"] };
            NSError* error = [NSError errorWithDomain:kSWGImageApiErrorDomain code:kSWGImageApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    // verify the required parameter 'productNo' is set
    if (productNo == nil) {
        NSParameterAssert(productNo);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"productNo"] };
            NSError* error = [NSError errorWithDomain:kSWGImageApiErrorDomain code:kSWGImageApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/images/hosts/{hostCode}/images/{productNo}"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (hostCode != nil) {
        pathParams[@"hostCode"] = hostCode;
    }
    if (productNo != nil) {
        pathParams[@"productNo"] = productNo;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    [headerParams addEntriesFromDictionary:self.defaultHeaders];
    // HTTP header `Accept`
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccept:@[@"application/json"]];
    if(acceptHeader.length > 0) {
        headerParams[@"Accept"] = acceptHeader;
    }

    // response content type
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ?: @"";

    // request content type
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentType:@[]];

    // Authentication setting
    NSArray *authSettings = @[];

    id bodyParam = nil;
    NSMutableDictionary *formParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *localVarFiles = [[NSMutableDictionary alloc] init];

    return [self.apiClient requestWithPath: resourcePath
                                    method: @"GET"
                                pathParams: pathParams
                               queryParams: queryParams
                                formParams: formParams
                                     files: localVarFiles
                                      body: bodyParam
                              headerParams: headerParams
                              authSettings: authSettings
                        requestContentType: requestContentType
                       responseContentType: responseContentType
                              responseType: @"SWGGetImageResponse*"
                           completionBlock: ^(id data, NSError *error) {
                                if(handler) {
                                    handler((SWGGetImageResponse*)data, error);
                                }
                            }];
}

///
/// Find Images by ID
/// Returns a single Image
///  @param imageId ID of Image to return 
///
///  @returns SWGGetImageResponse*
///
-(NSURLSessionTask*) getImageByIdWithImageId: (NSString*) imageId
    completionHandler: (void (^)(SWGGetImageResponse* output, NSError* error)) handler {
    // verify the required parameter 'imageId' is set
    if (imageId == nil) {
        NSParameterAssert(imageId);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"imageId"] };
            NSError* error = [NSError errorWithDomain:kSWGImageApiErrorDomain code:kSWGImageApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/images/{imageId}"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (imageId != nil) {
        pathParams[@"imageId"] = imageId;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    [headerParams addEntriesFromDictionary:self.defaultHeaders];
    // HTTP header `Accept`
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccept:@[@"application/json"]];
    if(acceptHeader.length > 0) {
        headerParams[@"Accept"] = acceptHeader;
    }

    // response content type
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ?: @"";

    // request content type
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentType:@[]];

    // Authentication setting
    NSArray *authSettings = @[];

    id bodyParam = nil;
    NSMutableDictionary *formParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *localVarFiles = [[NSMutableDictionary alloc] init];

    return [self.apiClient requestWithPath: resourcePath
                                    method: @"GET"
                                pathParams: pathParams
                               queryParams: queryParams
                                formParams: formParams
                                     files: localVarFiles
                                      body: bodyParam
                              headerParams: headerParams
                              authSettings: authSettings
                        requestContentType: requestContentType
                       responseContentType: responseContentType
                              responseType: @"SWGGetImageResponse*"
                           completionBlock: ^(id data, NSError *error) {
                                if(handler) {
                                    handler((SWGGetImageResponse*)data, error);
                                }
                            }];
}

///
/// Get Images by imageId
/// Returns similar Images with imageId
///  @param imageId  
///
///  @param offset  (optional)
///
///  @param limit  (optional)
///
///  @returns SWGGetImagesResponse*
///
-(NSURLSessionTask*) getImagesWithImageId: (NSString*) imageId
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler {
    // verify the required parameter 'imageId' is set
    if (imageId == nil) {
        NSParameterAssert(imageId);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"imageId"] };
            NSError* error = [NSError errorWithDomain:kSWGImageApiErrorDomain code:kSWGImageApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/images"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    if (imageId != nil) {
        queryParams[@"imageId"] = imageId;
    }
    if (offset != nil) {
        queryParams[@"offset"] = offset;
    }
    if (limit != nil) {
        queryParams[@"limit"] = limit;
    }
    NSMutableDictionary* headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    [headerParams addEntriesFromDictionary:self.defaultHeaders];
    // HTTP header `Accept`
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccept:@[@"application/json"]];
    if(acceptHeader.length > 0) {
        headerParams[@"Accept"] = acceptHeader;
    }

    // response content type
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ?: @"";

    // request content type
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentType:@[]];

    // Authentication setting
    NSArray *authSettings = @[];

    id bodyParam = nil;
    NSMutableDictionary *formParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *localVarFiles = [[NSMutableDictionary alloc] init];

    return [self.apiClient requestWithPath: resourcePath
                                    method: @"GET"
                                pathParams: pathParams
                               queryParams: queryParams
                                formParams: formParams
                                     files: localVarFiles
                                      body: bodyParam
                              headerParams: headerParams
                              authSettings: authSettings
                        requestContentType: requestContentType
                       responseContentType: responseContentType
                              responseType: @"SWGGetImagesResponse*"
                           completionBlock: ^(id data, NSError *error) {
                                if(handler) {
                                    handler((SWGGetImagesResponse*)data, error);
                                }
                            }];
}

///
/// Query to search images by object id
/// 
///  @param objectId  
///
///  @param offset  (optional)
///
///  @param limit  (optional)
///
///  @returns SWGGetImagesResponse*
///
-(NSURLSessionTask*) getImagesByObjectIdWithObjectId: (NSString*) objectId
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler {
    // verify the required parameter 'objectId' is set
    if (objectId == nil) {
        NSParameterAssert(objectId);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"objectId"] };
            NSError* error = [NSError errorWithDomain:kSWGImageApiErrorDomain code:kSWGImageApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/images/objects/{objectId}"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (objectId != nil) {
        pathParams[@"objectId"] = objectId;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    if (offset != nil) {
        queryParams[@"offset"] = offset;
    }
    if (limit != nil) {
        queryParams[@"limit"] = limit;
    }
    NSMutableDictionary* headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    [headerParams addEntriesFromDictionary:self.defaultHeaders];
    // HTTP header `Accept`
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccept:@[@"application/json"]];
    if(acceptHeader.length > 0) {
        headerParams[@"Accept"] = acceptHeader;
    }

    // response content type
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ?: @"";

    // request content type
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentType:@[]];

    // Authentication setting
    NSArray *authSettings = @[];

    id bodyParam = nil;
    NSMutableDictionary *formParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *localVarFiles = [[NSMutableDictionary alloc] init];

    return [self.apiClient requestWithPath: resourcePath
                                    method: @"GET"
                                pathParams: pathParams
                               queryParams: queryParams
                                formParams: formParams
                                     files: localVarFiles
                                      body: bodyParam
                              headerParams: headerParams
                              authSettings: authSettings
                        requestContentType: requestContentType
                       responseContentType: responseContentType
                              responseType: @"SWGGetImagesResponse*"
                           completionBlock: ^(id data, NSError *error) {
                                if(handler) {
                                    handler((SWGGetImagesResponse*)data, error);
                                }
                            }];
}

///
/// Query to search images
/// 
///  @param file User's Image file to upload (only support jpg format yet) (optional)
///
///  @param offset  (optional)
///
///  @param limit  (optional)
///
///  @returns SWGGetImagesResponse*
///
-(NSURLSessionTask*) getImagesByUserImageFileWithFile: (NSURL*) file
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler {
    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/images/userImages"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    if (offset != nil) {
        queryParams[@"offset"] = offset;
    }
    if (limit != nil) {
        queryParams[@"limit"] = limit;
    }
    NSMutableDictionary* headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    [headerParams addEntriesFromDictionary:self.defaultHeaders];
    // HTTP header `Accept`
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccept:@[@"application/json"]];
    if(acceptHeader.length > 0) {
        headerParams[@"Accept"] = acceptHeader;
    }

    // response content type
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ?: @"";

    // request content type
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentType:@[@"multipart/form-data"]];

    // Authentication setting
    NSArray *authSettings = @[];

    id bodyParam = nil;
    NSMutableDictionary *formParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *localVarFiles = [[NSMutableDictionary alloc] init];
    localVarFiles[@"file"] = file;

    return [self.apiClient requestWithPath: resourcePath
                                    method: @"POST"
                                pathParams: pathParams
                               queryParams: queryParams
                                formParams: formParams
                                     files: localVarFiles
                                      body: bodyParam
                              headerParams: headerParams
                              authSettings: authSettings
                        requestContentType: requestContentType
                       responseContentType: responseContentType
                              responseType: @"SWGGetImagesResponse*"
                           completionBlock: ^(id data, NSError *error) {
                                if(handler) {
                                    handler((SWGGetImagesResponse*)data, error);
                                }
                            }];
}

///
/// Get Images by userImageId and objectIndex
/// Returns Images belongs to a userImageId and objectIndex
///  @param userImageId  
///
///  @param objectIndex  
///
///  @returns SWGGetImagesResponse*
///
-(NSURLSessionTask*) getImagesByUserImageIdAndObjectIndexWithUserImageId: (NSString*) userImageId
    objectIndex: (NSNumber*) objectIndex
    completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler {
    // verify the required parameter 'userImageId' is set
    if (userImageId == nil) {
        NSParameterAssert(userImageId);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"userImageId"] };
            NSError* error = [NSError errorWithDomain:kSWGImageApiErrorDomain code:kSWGImageApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    // verify the required parameter 'objectIndex' is set
    if (objectIndex == nil) {
        NSParameterAssert(objectIndex);
        if(handler) {
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey : [NSString stringWithFormat:NSLocalizedString(@"Missing required parameter '%@'", nil),@"objectIndex"] };
            NSError* error = [NSError errorWithDomain:kSWGImageApiErrorDomain code:kSWGImageApiMissingParamErrorCode userInfo:userInfo];
            handler(nil, error);
        }
        return nil;
    }

    NSMutableString* resourcePath = [NSMutableString stringWithFormat:@"/images/userImages/{userImageId}/objects/{objectIndex}"];

    NSMutableDictionary *pathParams = [[NSMutableDictionary alloc] init];
    if (userImageId != nil) {
        pathParams[@"userImageId"] = userImageId;
    }
    if (objectIndex != nil) {
        pathParams[@"objectIndex"] = objectIndex;
    }

    NSMutableDictionary* queryParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary* headerParams = [NSMutableDictionary dictionaryWithDictionary:self.apiClient.configuration.defaultHeaders];
    [headerParams addEntriesFromDictionary:self.defaultHeaders];
    // HTTP header `Accept`
    NSString *acceptHeader = [self.apiClient.sanitizer selectHeaderAccept:@[@"application/json"]];
    if(acceptHeader.length > 0) {
        headerParams[@"Accept"] = acceptHeader;
    }

    // response content type
    NSString *responseContentType = [[acceptHeader componentsSeparatedByString:@", "] firstObject] ?: @"";

    // request content type
    NSString *requestContentType = [self.apiClient.sanitizer selectHeaderContentType:@[]];

    // Authentication setting
    NSArray *authSettings = @[];

    id bodyParam = nil;
    NSMutableDictionary *formParams = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *localVarFiles = [[NSMutableDictionary alloc] init];

    return [self.apiClient requestWithPath: resourcePath
                                    method: @"GET"
                                pathParams: pathParams
                               queryParams: queryParams
                                formParams: formParams
                                     files: localVarFiles
                                      body: bodyParam
                              headerParams: headerParams
                              authSettings: authSettings
                        requestContentType: requestContentType
                       responseContentType: responseContentType
                              responseType: @"SWGGetImagesResponse*"
                           completionBlock: ^(id data, NSError *error) {
                                if(handler) {
                                    handler((SWGGetImagesResponse*)data, error);
                                }
                            }];
}



@end
