
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGRNotificationContent : NSObject

- (void)didLoadView:(UIView *)view;
- (void)didReceiveNotification:(UNNotification *)notification completionHandler:(void(^)(NSArray<UNNotificationAction *>* _Nullable notificationActions))completionHandler;

- (BOOL)isZGRNotification:(NSDictionary *)userInfo;

+ (instancetype)sharedInstance;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
