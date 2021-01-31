
#import "AppDelegate.h"
#import "UIViewController+Alert.h"

#import <UserNotifications/UserNotifications.h>
#import <ZGRImSDK/ZGRImSDK.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application registerForRemoteNotifications];

    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    UNAuthorizationOptions options = UNAuthorizationOptionAlert | UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:options
                                                                        completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];

    [ZGRMessaging sharedInstance].deviceId = nil;
    [ZGRMessaging sharedInstance].localDatabaseEnabled = YES;
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[ZGRMessaging sharedInstance] registerForRemoteNotifications:deviceToken];
    self.deviceToken = deviceToken;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceTokenUpdated" object:self userInfo:@{
        @"deviceToken": deviceToken ?: [NSNull null]
    }];
}


#pragma mark - UIApplicationDelegate

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // MARK: Here you will receive silent and VOIP push notification
    if (![[ZGRMessaging sharedInstance] application:application
                       didReceiveRemoteNotification:userInfo
                              withCompletionHandler:^(ZGRNotification * _Nonnull notification) {
        // Handle remote notification from ZGR
    }]) {
        // Handle foreign remote notification
    }
    completionHandler(UIBackgroundFetchResultNoData);
}

#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // MARK: You should know that when app in opened state, notification will be silenced by default cause of implicit completionHandler(UNNotificationPresentationOptionNone) call
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // MARK: User responded to notification
    if (![[ZGRMessaging sharedInstance] userNotificationCenter:center
                                didReceiveNotificationResponse:response
                                         withCompletionHandler:^(ZGRNotification * _Nonnull notification,
                                                                 ZGRAction * _Nonnull selectedAction) {
        // Handle notification from ZGR
        
        // User clicked notification content
        if (selectedAction.type == ZGRActionTypeDefault) {
            // Perform any code
        }
        
        // User clicked custom button under notification content
        if (selectedAction.type == ZGRActionTypeOther) {
            NSString *zgrActionId = selectedAction.identifier;
            if (zgrActionId.length > 0) {
                NSLog(@"User did select custom action with Id: %@", zgrActionId);
            }
        }
        
        // Optional data for your's own purposes
        NSObject *customPayload = notification.customPayload;
        if (customPayload) {
            // My own code
            [self.window.rootViewController ext_showAlertWithTitle:@"Custom payload" message:customPayload.description];
        }
        
    }]) {
        // Handle foreign notification
    }

    // My own code
    
    completionHandler();
}

@end
