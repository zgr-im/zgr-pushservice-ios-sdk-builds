
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const ZGRAppGroupNameKey = @"ZGR_APP_GROUP_NAME_KEY";

/**
 @brief Configuration class.
 */
@interface ZGRConfig : NSObject

@property (nonatomic, null_resettable, copy) NSString *applicationId; /**< Default value must be provided by embedding `ZGRConfig.json` file. It can be changed in runtime.  */
@property (nonatomic, null_resettable, copy) NSString *apiKey; /**< Default value must be provided by embedding `ZGRConfig.json` file. It can be changed in runtime.  */
@property (nonatomic, null_resettable, strong) NSURL *endpoint; /**< Default value must be provided by embedding `ZGRConfig.json` file. It can be changed in runtime.  */

/**
 @brief Resets all parameters to provided in `ZGRConfig.json` file.
 */
- (void)resetToEmbeddedConfig;

/**
 @brief Return string with current number version of SDK 
 */
- (NSString *)getSDKVersion;

/**
 @brief Gets the NSBundle of the primary application
 */
+ (NSBundle *)primaryBundle;

/**
 @brief Shared instance of config
 */
+ (nullable instancetype)sharedInstance;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
