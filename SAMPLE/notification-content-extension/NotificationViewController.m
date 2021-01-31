
#import "NotificationViewController.h"

#import <UserNotificationsUI/UserNotificationsUI.h>
#import <ZGRImSDK/ZGRNotificationContent.h>

@interface NotificationViewController () <UNNotificationContentExtension>

@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ZGRNotificationContent sharedInstance] didLoadView:self.view];
}

- (void)didReceiveNotification:(UNNotification *)notification {
    [[ZGRNotificationContent sharedInstance] didReceiveNotification:notification];
}

@end
