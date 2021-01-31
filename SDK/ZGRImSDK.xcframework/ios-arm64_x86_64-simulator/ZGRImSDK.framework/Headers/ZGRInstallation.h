
#import <Foundation/Foundation.h>

@class ZGRSubscription;
@class ZGRError;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief User installation information.
 */
@interface ZGRInstallation : NSObject

@property (nonatomic, assign, getter=isPrimary) BOOL primary; /**< Primary device attribute */
@property (nonatomic, assign, getter=isPushOsEnabled) BOOL pushOsEnabled; /**< System level permission for push notifications */
@property (nonatomic, assign, getter=isPushEnabled) BOOL pushEnabled; /**< Application level permission for receiving push notifications */

@property (nonatomic, copy) NSArray<ZGRSubscription *> *subscriptions;

- (nullable instancetype)initWithJSON:(NSString *)json error:(ZGRError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithJSONData:(NSData *)jsonData error:(ZGRError * _Nullable * _Nullable)error;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
