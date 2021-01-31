
#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

- (void)serviceExtensionTimeWillExpire {
    [super serviceExtensionTimeWillExpire];
}

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    [super didReceiveNotificationRequest:request withContentHandler:contentHandler];

    self.bestAttemptContent = [request.content mutableCopy];
    self.bestAttemptContent.title = @"Ok, my own method";
    self.bestAttemptContent.body = @"Not handled by ZGR";
    
    contentHandler(self.bestAttemptContent);
}

@end
