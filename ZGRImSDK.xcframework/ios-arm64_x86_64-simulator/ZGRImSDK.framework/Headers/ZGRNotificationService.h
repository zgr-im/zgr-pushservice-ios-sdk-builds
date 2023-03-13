
#import <UserNotifications/UserNotifications.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGRNotificationService : UNNotificationServiceExtension

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request
                   withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler;
- (void)serviceExtensionTimeWillExpire;
- (BOOL)isZGRNotification:(NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
