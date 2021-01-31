
#import <ZGRImSDK/ZGRAction.h>
#import <ZGRImSDK/ZGRContent.h>

@class UNNotificationContent;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Notification info.
 */
@interface ZGRNotification : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic, nullable, copy) NSString *title;
@property (nonatomic, nullable, copy) NSString *subtitle;
@property (nonatomic, nullable, copy) NSString *text;

@property (nonatomic, nullable, strong) ZGRContent *content; /**< Notification media content */
@property (nonatomic, nullable, copy) NSArray<ZGRAction *> *actions; /**< Notification actions */

@property (nonatomic, nullable, copy) id customPayload; /**< Additional data for your's own purposes. NSArray, NSDictionary or any other top-level object. */

- (nullable instancetype)initWithNotificationContent:(UNNotificationContent *)content;
- (nullable instancetype)initWithRemoteNotification:(NSDictionary *)userInfo;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
