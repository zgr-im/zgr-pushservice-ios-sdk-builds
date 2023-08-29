
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

@class UIApplication;
@class ZGRConfig;
@class ZGRNotification;
@class ZGRAction;
@class ZGRUser;
@class ZGRInstallation;
@class ZGRDatabaseRequest;
@class ZGRError;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief Main class for working with messaging.
 */
@interface ZGRMessaging : NSObject

/**
 @brief Current integration config.
 */
@property (nonatomic, null_resettable, readonly) ZGRConfig *config;

/**
 @brief Current device id. Default: [[[UIDevice currentDevice] identifierForVendor] UUIDString].
 */
@property (nonatomic, null_resettable, copy) NSString *deviceId;

/**
 @brief Current installation id. Default: [[ZGRDatabase sharedInstance] getInstallationId]. If default is nil, then [_random randomUUIDString]
 */
@property (nonatomic, null_resettable, copy) NSString *installationId;

/**
 @brief Precreated shared instance.
 */
+ (instancetype)sharedInstance;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

@interface ZGRMessaging (Main)

/**
 @brief Register for remote notifications.
 @param token Token for remote notifications.
 */
- (void)registerForRemoteNotifications:(nullable NSData *)token;

/**
 @brief Try to handle silent and VOIP push notifications. If notification isn't from ZGR, this method returns NO.
 @param application Current application.
 @param userInfo Notification response.
*/
- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;

/**
 @brief Try to handle silent and VOIP push notifications. If notification isn't from ZGR, this method returns NO and callback will not be called.
 @param application Current application.
 @param userInfo Notification response.
 @param completionHandler Handled notification..
*/
- (BOOL)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo withCompletionHandler:(nullable void(^)(ZGRNotification * _Nonnull notification))completionHandler;

/**
 @brief Try to handle user response to delivered remote push notification. If notification isn't from ZGR, this method returns NO.
 @param center Notification center instance.
 @param response Notification response.
 */
- (BOOL)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response;

/**
 @brief Try to handle user response to delivered remote push notification. If notification isn't from ZGR, this method returns NO and callback will not be called.
 @param center Notification center instance.
 @param response Notification response.
 @param completionHandler Handled notification and selected by user action.
 */
- (BOOL)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(nullable void(^)(ZGRNotification * _Nonnull notification,
                                                                                                          ZGRAction * _Nonnull selectedAction))completionHandler;

/**
 @brief Try to show web page with url passed through action button in push notification.
 @param url Url of page
 @param vc App's main view controller.
 */
- (void)showLinkPageWithURL:(NSURL *)url andViewController:(UIViewController *)vc;

/**
 @brief Set application badge number
 @param application Current application.
 @param number number that setted.
*/
- (void)application:(UIApplication *)application setApplicationBadgeNumber:(NSInteger)number;

/**
 @brief Check swiped notifications in UNUserNotificationCenter and updated its status in local database.
 */
- (void)checkSeensAndUpdateNotificationStatus;

/**
 @brief Broadcast event of launch/open application from received push notification.
 */
- (void)broadcastEventLaunchAppFromRemoteNotification;

/**
 @brief Update status on PGW for selected notification.
 */
- (void)updateNotificationStatus:(NSString *)status forNotificationWithID:(NSString *)notificationId;

@end

@interface ZGRMessaging (User)

/**
 @brief User profile retrieving.
 @param completionHandler Completion handler.
 */
- (void)fetchUserWithCompletionHandler:(void(^)(ZGRUser * _Nullable user, ZGRError * _Nullable error))completionHandler;

/**
 @brief Associates phone number with user.
 @param phoneNumber Phone number including +, hyphens, spaces, (, ) are removed. Regex: "7\d{10}". Passing number containing letters is illegal and be discarded.
 @return This method returns YES if phone number has correct format.
 */
- (BOOL)saveUserPhoneNumber:(NSString *)phoneNumber withCompletionHandler:(void(^)(ZGRUser * _Nullable user, ZGRError * _Nullable error))completionHandler;

/**
 @brief Associates external user id and phone number (optional) with this installation.
 @param externalUserId External user identifier.
 @param phoneNumber Phone number including +, hyphens, spaces, (, ) are removed. Regex: "7\d{10}". Passing number containing letters is illegal and be discarded.
 @param completionHandler Completion handler.
 */
- (BOOL)saveUserPhoneNumber:(NSString *)phoneNumber externalUserId:(NSString *)externalUserId withCompletionHandler:(void(^)(ZGRUser * _Nullable user, ZGRError * _Nullable error))completionHandler;

@end

@interface ZGRMessaging (Personalize)

/**
 @brief Associates external user id and phone number (optional) with this installation.
 @param externalUserId External user identifier.
 @param completionHandler Completion handler.
 */
- (void)personalizeWithExternalUserId:(NSString *)externalUserId completionHandler:(void(^)(ZGRUser * _Nullable user, ZGRError * _Nullable error))completionHandler;

/**
 @brief Depersonalize (logout) from current device. Resets configured installation.
 @param completionHandler Completion handler.
 */
- (void)depersonalizeWithCompletionHandler:(nullable void(^)(void))completionHandler;

@end

@interface ZGRMessaging (Installation)

/**
 @brief User profile retrieving.
 @param completionHandler Completion handler.
 */
- (void)fetchInstallationWithCompletionHandler:(void(^)(ZGRInstallation * _Nullable installation, ZGRError * _Nullable error))completionHandler;

/**
 @brief Update user installation.
 @param completionHandler Completion handler.
 */
- (void)saveInstallation:(ZGRInstallation *)installation withCompletionHandler:(nullable void(^)(void))completionHandler;

@end

@interface ZGRMessaging (Database)

@property (nonatomic, assign, getter=isLocalDatabaseEnabled) BOOL localDatabaseEnabled; /**< Default value: NO. */

/**
 @brief Fetch all notifications from local database.
 @param completionHandler Completion handler.
 */
- (void)fetchAllNotificationsWithCompletionHandler:(void(^)(NSArray<ZGRNotification *> * _Nullable notifications,
                                                            ZGRError * _Nullable error))completionHandler;

/**
 @brief Fetch all notifications from local database with provided request (filter).
 @param completionHandler Completion handler.
 */
- (void)fetchNotificationsWithRequest:(ZGRDatabaseRequest *)request completionHandler:(void(^)(NSArray<ZGRNotification *> * _Nullable notifications,
                                                                                               ZGRError * _Nullable error))completionHandler;

/**
 @brief Delete notification from local database.
 @param notification Notification to delete.
 @param completionHandler Completion handler.
 */
- (void)deleteNotification:(ZGRNotification *)notification withCompletionHandler:(void(^)(BOOL success, ZGRError * _Nullable error))completionHandler;

/**
 @brief Delete array of notifications from local database.
 @param array Array of notifications to delete.
 @param completionHandler Completion handler.
 */
- (void)deleteNotificationsArray:(NSArray<ZGRNotification *> *)array withCompletionHandler:(void(^)(BOOL success, ZGRError * _Nullable error))completionHandler;

/**
 @brief Update notification's status in local database.
 @param notification Notification to update.
 @param status Status to update. Must be "New" or "Seen".
 @param completionHandler Completion handler.
 */
- (void)updateNotification:(ZGRNotification *)notification status:(NSString *)status withCompletionHandler:(void(^)(BOOL success, ZGRError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
