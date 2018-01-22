#import "SWGBoxObject.h"

@implementation SWGBoxObject

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
  return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{ @"_id": @"id", @"box": @"box", @"imageId": @"image_id", @"versionId": @"version_id", @"classCode": @"class_code", @"score": @"score" }];
}

/**
 * Indicates whether the property with the given name is optional.
 * If `propertyName` is optional, then return `YES`, otherwise return `NO`.
 * This method is used by `JSONModel`.
 */
+ (BOOL)propertyIsOptional:(NSString *)propertyName {

  NSArray *optionalProperties = @[@"_id", @"box", @"imageId", @"versionId", @"classCode", @"score"];
  return [optionalProperties containsObject:propertyName];
}

@end
