# SWGFeedApi

All URIs are relative to *http://api.stylelens.io*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getFeeds**](SWGFeedApi.md#getfeeds) | **GET** /feeds | 


# **getFeeds**
```objc
-(NSURLSessionTask*) getFeedsWithOffset: (NSNumber*) offset
    limit: (NSNumber*) limit
        completionHandler: (void (^)(SWGGetFeedResponse* output, NSError* error)) handler;
```



Returns Main Feeds

### Example 
```objc

NSNumber* offset = @56; //  (optional)
NSNumber* limit = @56; //  (optional)

SWGFeedApi*apiInstance = [[SWGFeedApi alloc] init];

// 
[apiInstance getFeedsWithOffset:offset
              limit:limit
          completionHandler: ^(SWGGetFeedResponse* output, NSError* error) {
                        if (output) {
                            NSLog(@"%@", output);
                        }
                        if (error) {
                            NSLog(@"Error calling SWGFeedApi->getFeeds: %@", error);
                        }
                    }];
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **offset** | **NSNumber***|  | [optional] 
 **limit** | **NSNumber***|  | [optional] 

### Return type

[**SWGGetFeedResponse***](SWGGetFeedResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

