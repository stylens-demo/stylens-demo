# SWGObjectApi

All URIs are relative to *http://api.stylelens.io*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getObjectsByImageId**](SWGObjectApi.md#getobjectsbyimageid) | **GET** /objects/images/{imageId} | Query to search multiple objects
[**getObjectsByUserImageFile**](SWGObjectApi.md#getobjectsbyuserimagefile) | **POST** /objects | Query to search objects and images


# **getObjectsByImageId**
```objc
-(NSURLSessionTask*) getObjectsByImageIdWithImageId: (NSString*) imageId
        completionHandler: (void (^)(SWGGetObjectsByImageIdResponse* output, NSError* error)) handler;
```

Query to search multiple objects



### Example 
```objc

NSString* imageId = @"imageId_example"; // 

SWGObjectApi*apiInstance = [[SWGObjectApi alloc] init];

// Query to search multiple objects
[apiInstance getObjectsByImageIdWithImageId:imageId
          completionHandler: ^(SWGGetObjectsByImageIdResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGObjectApi->getObjectsByImageId: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **imageId** | **NSString***|  | 

### Return type

[**SWGGetObjectsByImageIdResponse***](SWGGetObjectsByImageIdResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getObjectsByUserImageFile**
```objc
-(NSURLSessionTask*) getObjectsByUserImageFileWithFile: (NSURL*) file
        completionHandler: (void (^)(SWGGetObjectsResponse* output, NSError* error)) handler;
```

Query to search objects and images



### Example 
```objc

NSURL* file = [NSURL fileURLWithPath:@"/path/to/file.txt"]; // User's Image file to upload (only support jpg format yet)

SWGObjectApi*apiInstance = [[SWGObjectApi alloc] init];

// Query to search objects and images
[apiInstance getObjectsByUserImageFileWithFile:file
          completionHandler: ^(SWGGetObjectsResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGObjectApi->getObjectsByUserImageFile: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **file** | **NSURL***| User&#39;s Image file to upload (only support jpg format yet) | 

### Return type

[**SWGGetObjectsResponse***](SWGGetObjectsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

