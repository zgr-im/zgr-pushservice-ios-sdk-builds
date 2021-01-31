
#import "MainViewController.h"
#import "UIViewController+Alert.h"
#import "AppDelegate.h"
#import <ZGRImSDK/ZGRImSDK.h>

static NSString * NSStringFromNSData(NSData *data) {
    if (!data) {
        return @"<null>";
    }

    char *string = calloc(data.length * 2 + 1, sizeof(char));
    unsigned const char *cdata = data.bytes;
    for (size_t i = 0; i < data.length; i++) {
        sprintf(string + i * 2, "%02x", cdata[i]);
    }

    NSString *nsString = [NSString stringWithUTF8String:string];
    free(string);
    
    return nsString;
}

@interface MainViewController () <UIScrollViewDelegate>

@property (nonatomic, weak) IBOutlet UITextView *deviceTokenTextView;
@property (nonatomic, weak) IBOutlet UITextView *installationIdTextView;

@property (nonatomic, weak) IBOutlet UITextField *phoneNumberField;
@property (nonatomic, weak) IBOutlet UITextField *externalUserIdField;

@property (nonatomic, weak) IBOutlet UITextField *phoneNumberTextView;
@property (nonatomic, weak) IBOutlet UITextField *externalUserIdTextView;

@end

@implementation MainViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

    NSData *deviceToken = ((AppDelegate *)[UIApplication sharedApplication].delegate).deviceToken;
    [self deviceTokenUpdated:deviceToken];

    [[NSNotificationCenter defaultCenter] addObserverForName:@"DeviceTokenUpdated" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSData *token = note.userInfo[@"deviceToken"];
        if ((NSNull *)token == [NSNull null]) {
            token = nil;
        }

        [self deviceTokenUpdated:token];
    }];

    self.installationIdTextView.text = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

#pragma mark - Actions

- (IBAction)onSendPhoneNumberTap:(id)sender {
    if (!self.phoneNumberField.text.length) {
        [self ext_showAlertWithTitle:@"Не заполнен номер телефона"];
    }
    
    __weak __typeof(self) weakSelf = self;
    BOOL correctPhoneNumberFormat = [[ZGRMessaging sharedInstance] saveUserPhoneNumber:self.phoneNumberField.text
                                                                 withCompletionHandler:^(ZGRUser * _Nullable user, ZGRError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf ext_showAlertWithTitle:@"Номер телефона успешно сохранен"];
        });
    }];
    
    UIColor *failureColor = UIColor.redColor;
    UIColor *successColor;
    if (@available(iOS 13.0, *)) {
        successColor = UIColor.labelColor;
    } else {
        successColor = UIColor.blackColor;
    }
    self.phoneNumberField.textColor = correctPhoneNumberFormat ? successColor : failureColor;
}

- (IBAction)onPersonalizeTap:(id)sender {
    if (!self.externalUserIdField.text.length) {
        [self ext_showAlertWithTitle:@"Не заполнен externalUserId"];
    }
    
    __weak __typeof(self) weakSelf = self;
    [[ZGRMessaging sharedInstance] personalizeWithExternalUserId:self.externalUserIdField.text
                                               completionHandler:^(ZGRUser * _Nullable user, ZGRError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf ext_showAlertWithTitle:@"Персонализировано"];
        });
    }];
}

- (IBAction)onGetProfileTap:(id)sender {
    __weak __typeof(self) weakSelf = self;
    [[ZGRMessaging sharedInstance] fetchUserWithCompletionHandler:^(ZGRUser * _Nullable user, ZGRError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!user) {
                [strongSelf ext_showAlertWithTitle:@"Не персонализировано"];
            }
            
            strongSelf.phoneNumberTextView.text = user.phoneNumber ?: @"Отсутствует";
            strongSelf.externalUserIdTextView.text = user.externalUserId ?: @"Отсутствует";
        });
    }];
}

- (IBAction)onLogoutTap:(id)sender {
    __weak __typeof(self) weakSelf = self;
    [[ZGRMessaging sharedInstance] depersonalizeWithCompletionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf onGetProfileTap:nil];
        });
    }];
    
    self.phoneNumberField.text = nil;
    self.externalUserIdField.text = nil;
    
    [self ext_showAlertWithTitle:@"Выполнена деперсонализация, все локальные данные удалены"];
}

- (IBAction)onDoneTap:(id)sender {
    [sender resignFirstResponder];
}

- (void)deviceTokenUpdated:(NSData *)token {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.deviceTokenTextView.text = NSStringFromNSData(token);
    });
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.phoneNumberField resignFirstResponder];
    [self.externalUserIdField resignFirstResponder];
}

@end
