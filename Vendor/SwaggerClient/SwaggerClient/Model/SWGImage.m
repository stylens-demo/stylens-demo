#import "SWGImage.h"

@implementation SWGImage

- (instancetype)init {
  self = [super init];
  if (self) {
    // initialize property's default value, if any
    
  }
  return self;
}


/**
 * Maps json key to property name.
 * This method is used by `JSONModel`.
 */
+ (JSONKeyMapper *)keyMapper {
  return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"_id": @"id", @"productName": @"product_name", @"productId": @"product_id", @"hostCode": @"host_code", @"hostUrl": @"host_url", @"hostName": @"host_name", @"classCode": @"class_code", @"price": @"price", @"currencyUnit": @"currency_unit", @"productUrl": @"product_url", @"productNo": @"product_no", @"nation": @"nation", @"mainImageMobileFull": @"main_image_mobile_full", @"mainImageMobileThumb": @"main_image_mobile_thumb", @"version": @"version", @"images": @"images" }];
}

/**
 * Indicates whether the property with the given name is optional.
 * If `propertyName` is optional, then return `YES`, otherwise return `NO`.
 * This method is used by `JSONModel`.
 */
+ (BOOL)propertyIsOptional:(NSString *)propertyName {

  NSArray *optionalProperties = @[@"_id", @"productName", @"productId", @"hostCode", @"hostUrl", @"hostName", @"classCode", @"price", @"currencyUnit", @"productUrl", @"productNo", @"nation", @"mainImageMobileFull", @"mainImageMobileThumb", @"version", @"images"];
  return [optionalProperties containsObject:propertyName];
}

@end
