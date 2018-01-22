# SWGPlaygroundApi

All URIs are relative to *http://api.stylelens.io*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPlaygroundObjectsByUserImageFile**](SWGPlaygroundApi.md#getplaygroundobjectsbyuserimagefile) | **POST** /playgrounds/objects | 


# **getPlaygroundObjectsByUserImageFile**
```objc
-(NSURLSessionTask*) getPlaygroundObjectsByUserImageFileWithFile: (NSURL*) file
        completionHandler: (void (^)(SWGGetObjectsResponse* output, NSError* error)) handler;
```





### Example 
```objc

NSURL* file = [NSURL fileURLWithPath:@"/path/to/file.txt"]; // User's Image file to upload (only support jpg format yet)

SWGPlaygroundApi*apiInstance = [[SWGPlaygroundApi alloc] init];

// 
[apiInstance getPlaygroundObjectsByUserImageFileWithFile:file
          completionHandler: ^(SWGGetObjectsResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGPlaygroundApi->getPlaygroundObjectsByUserImageFile: %@", error);
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

