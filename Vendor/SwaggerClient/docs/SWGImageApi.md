# SWGImageApi

All URIs are relative to *http://api.stylelens.io*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getImageByHostcodeAndProductNo**](SWGImageApi.md#getimagebyhostcodeandproductno) | **GET** /images/hosts/{hostCode}/images/{productNo} | Get Image by hostCode and productNo
[**getImageById**](SWGImageApi.md#getimagebyid) | **GET** /images/{imageId} | Find Images by ID
[**getImages**](SWGImageApi.md#getimages) | **GET** /images | Get Images by imageId
[**getImagesByObjectId**](SWGImageApi.md#getimagesbyobjectid) | **GET** /images/objects/{objectId} | Query to search images by object id
[**getImagesByUserImageFile**](SWGImageApi.md#getimagesbyuserimagefile) | **POST** /images/userImages | Query to search images
[**getImagesByUserImageIdAndObjectIndex**](SWGImageApi.md#getimagesbyuserimageidandobjectindex) | **GET** /images/userImages/{userImageId}/objects/{objectIndex} | Get Images by userImageId and objectIndex


# **getImageByHostcodeAndProductNo**
```objc
-(NSURLSessionTask*) getImageByHostcodeAndProductNoWithHostCode: (NSString*) hostCode
    productNo: (NSString*) productNo
        completionHandler: (void (^)(SWGGetImageResponse* output, NSError* error)) handler;
```

Get Image by hostCode and productNo

Returns Image belongs to a Host and productNo

### Example 
```objc

NSString* hostCode = @"hostCode_example"; // 
NSString* productNo = @"productNo_example"; // 

SWGImageApi*apiInstance = [[SWGImageApi alloc] init];

// Get Image by hostCode and productNo
[apiInstance getImageByHostcodeAndProductNoWithHostCode:hostCode
              productNo:productNo
          completionHandler: ^(SWGGetImageResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGImageApi->getImageByHostcodeAndProductNo: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **hostCode** | **NSString***|  | 
 **productNo** | **NSString***|  | 

### Return type

[**SWGGetImageResponse***](SWGGetImageResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImageById**
```objc
-(NSURLSessionTask*) getImageByIdWithImageId: (NSString*) imageId
        completionHandler: (void (^)(SWGGetImageResponse* output, NSError* error)) handler;
```

Find Images by ID

Returns a single Image

### Example 
```objc

NSString* imageId = @"imageId_example"; // ID of Image to return

SWGImageApi*apiInstance = [[SWGImageApi alloc] init];

// Find Images by ID
[apiInstance getImageByIdWithImageId:imageId
          completionHandler: ^(SWGGetImageResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGImageApi->getImageById: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageId** | **NSString***| ID of Image to return | 

### Return type

[**SWGGetImageResponse***](SWGGetImageResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImages**
```objc
-(NSURLSessionTask*) getImagesWithImageId: (NSString*) imageId
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
        completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;
```

Get Images by imageId

Returns similar Images with imageId

### Example 
```objc

NSString* imageId = @"imageId_example"; // 
NSNumber* offset = @56; //  (optional)
NSNumber* limit = @56; //  (optional)

SWGImageApi*apiInstance = [[SWGImageApi alloc] init];

// Get Images by imageId
[apiInstance getImagesWithImageId:imageId
              offset:offset
              limit:limit
          completionHandler: ^(SWGGetImagesResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGImageApi->getImages: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageId** | **NSString***|  | 
 **offset** | **NSNumber***|  | [optional] 
 **limit** | **NSNumber***|  | [optional] 

### Return type

[**SWGGetImagesResponse***](SWGGetImagesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImagesByObjectId**
```objc
-(NSURLSessionTask*) getImagesByObjectIdWithObjectId: (NSString*) objectId
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
        completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;
```

Query to search images by object id



### Example 
```objc

NSString* objectId = @"objectId_example"; // 
NSNumber* offset = @56; //  (optional)
NSNumber* limit = @56; //  (optional)

SWGImageApi*apiInstance = [[SWGImageApi alloc] init];

// Query to search images by object id
[apiInstance getImagesByObjectIdWithObjectId:objectId
              offset:offset
              limit:limit
          completionHandler: ^(SWGGetImagesResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGImageApi->getImagesByObjectId: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **objectId** | **NSString***|  | 
 **offset** | **NSNumber***|  | [optional] 
 **limit** | **NSNumber***|  | [optional] 

### Return type

[**SWGGetImagesResponse***](SWGGetImagesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImagesByUserImageFile**
```objc
-(NSURLSessionTask*) getImagesByUserImageFileWithFile: (NSURL*) file
    offset: (NSNumber*) offset
    limit: (NSNumber*) limit
        completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;
```

Query to search images



### Example 
```objc

NSURL* file = [NSURL fileURLWithPath:@"/path/to/file.txt"]; // User's Image file to upload (only support jpg format yet) (optional)
NSNumber* offset = @56; //  (optional)
NSNumber* limit = @56; //  (optional)

SWGImageApi*apiInstance = [[SWGImageApi alloc] init];

// Query to search images
[apiInstance getImagesByUserImageFileWithFile:file
              offset:offset
              limit:limit
          completionHandler: ^(SWGGetImagesResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGImageApi->getImagesByUserImageFile: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **NSURL***| User&#39;s Image file to upload (only support jpg format yet) | [optional] 
 **offset** | **NSNumber***|  | [optional] 
 **limit** | **NSNumber***|  | [optional] 

### Return type

[**SWGGetImagesResponse***](SWGGetImagesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getImagesByUserImageIdAndObjectIndex**
```objc
-(NSURLSessionTask*) getImagesByUserImageIdAndObjectIndexWithUserImageId: (NSString*) userImageId
    objectIndex: (NSNumber*) objectIndex
        completionHandler: (void (^)(SWGGetImagesResponse* output, NSError* error)) handler;
```

Get Images by userImageId and objectIndex

Returns Images belongs to a userImageId and objectIndex

### Example 
```objc

NSString* userImageId = @"userImageId_example"; // 
NSNumber* objectIndex = @56; // 

SWGImageApi*apiInstance = [[SWGImageApi alloc] init];

// Get Images by userImageId and objectIndex
[apiInstance getImagesByUserImageIdAndObjectIndexWithUserImageId:userImageId
              objectIndex:objectIndex
          completionHandler: ^(SWGGetImagesResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGImageApi->getImagesByUserImageIdAndObjectIndex: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userImageId** | **NSString***|  | 
 **objectIndex** | **NSNumber***|  | 

### Return type

[**SWGGetImagesResponse***](SWGGetImagesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

