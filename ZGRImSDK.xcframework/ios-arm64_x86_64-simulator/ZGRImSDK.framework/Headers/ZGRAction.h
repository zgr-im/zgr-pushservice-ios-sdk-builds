
#import <Foundation/Foundation.h>

@class UNNotificationResponse;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZGRActionType) {
    ZGRActionTypeDefault, // User clicked notification content
    ZGRActionTypeDismiss, // User dismissed notification (never seen this from system)
    ZGRActionTypeOther // Custom action from ZGR
};

/**
 @brief Notification action (default content click or button under rich-content)
 */
@interface ZGRAction : NSObject

@property (nonatomic, assign, readonly) ZGRActionType type;
@property (nonatomic, copy, readonly) NSString *identifier;
@property (nonatomic, copy, readonly) NSString *title;

- (nullable instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithNotificationResponse:(UNNotificationResponse *)response;
- (instancetype)initWithIdentifier:(NSString *)identifier title:(NSString *)title;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
