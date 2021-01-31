
#import <Foundation/Foundation.h>

@class ZGRError;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Entry type.
 */
typedef NS_ENUM(NSInteger, ZGRSubscriptionType) {
    ZGRSubscriptionTypeSetting,
    ZGRSubscriptionTypePermission,
};

/**
 @brief Installation subscription entry.
 */
@interface ZGRSubscription : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, assign) ZGRSubscriptionType type;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy, readonly) NSString *value;
- (BOOL)setValueWithBool:(BOOL)value; /**< Returns failure for ZGRSubscriptionTypeSetting */
- (BOOL)setValueWithString:(NSString *)value; /**< Returns failure for ZGRSubscriptionTypePermission */

- (NSDictionary *)dictionary;

- (nullable instancetype)initWithJSON:(NSString *)json error:(ZGRError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithJSONData:(NSData *)jsonData error:(ZGRError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionary error:(ZGRError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
