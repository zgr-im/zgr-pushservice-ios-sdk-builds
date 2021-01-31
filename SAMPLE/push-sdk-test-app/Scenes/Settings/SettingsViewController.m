
#import "SettingsViewController.h"
#import "UIViewController+Alert.h"
#import "SwitchTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "DetailTableViewCell.h"

#import <ZGRImSDK/ZGRImSDK.h>

typedef NS_ENUM(NSInteger, SectionType) {
    SectionTypeCommon,
    SectionTypeSubscriptions,
    SectionTypeConfig,
};

@interface SettingsViewController () <UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, nullable, strong) ZGRInstallation *installation;

@end

@implementation SettingsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    
    [self fetchData];
}

#pragma mark - Data

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)fetchData {
    __weak __typeof(self) weakSelf = self;
    [[ZGRMessaging sharedInstance] fetchInstallationWithCompletionHandler:^(ZGRInstallation * _Nullable installation, ZGRError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.installation = installation;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf reloadData];
        });
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case SectionTypeCommon:
            return 3;
        case SectionTypeSubscriptions:
            return self.installation.subscriptions.count;
        case SectionTypeConfig:
            return 3;
    }
    return 0;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case SectionTypeCommon:
            return @"Общие";
        case SectionTypeSubscriptions:
            return @"Подписки";
        case SectionTypeConfig:
            return @"Конфиг";
    }
    return nil;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case SectionTypeCommon:
            return [self tableView:tableView cellForInstallationSectionAtRow:indexPath.row];
        case SectionTypeSubscriptions:
            return [self tableView:tableView cellForSubscriptionsSectionAtRow:indexPath.row];
        case SectionTypeConfig:
            return [self tableView:tableView cellForConfigSectionAtRow:indexPath.row];
    }
    
    return [UITableViewCell new];
}

#pragma mark - Private

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForInstallationSectionAtRow:(NSUInteger)row {
    switch (row) {
        case 0: { // Primary device
            SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchTableViewCell class])];
            cell.title = @"Основное устройство";
            cell.toggled = self.installation.primary;
            cell.action = ^(BOOL toggled) {
                self.installation.primary = toggled;
            };
            
            return cell;
        }
        case 1: { // Push (App) enabled
            SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchTableViewCell class])];
            cell.title = @"Разрешить уведомления";
            cell.toggled = self.installation.pushEnabled;
            cell.action = ^(BOOL toggled) {
                self.installation.pushEnabled = toggled;
            };
            
            return cell;
        }
        case 2: { // Push (OS) enabled
            DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailTableViewCell class])];
            cell.title = @"Показ уведомлений системой";
            cell.value = self.installation.pushOsEnabled ? @"Да" : @"Нет";
            
            return cell;
        }
    }
    
    return [UITableViewCell new];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForSubscriptionsSectionAtRow:(NSUInteger)row {
    ZGRSubscription *subscription = self.installation.subscriptions[row];
    
    switch (subscription.type) {
        case ZGRSubscriptionTypeSetting: {
            TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFieldTableViewCell class])];
            cell.title = subscription.title;
            cell.value = subscription.value;
            cell.action = ^(NSString *value) {
                [subscription setValueWithString:value];
            };
            
            return cell;
        }
        case ZGRSubscriptionTypePermission: {
            SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SwitchTableViewCell class])];
            cell.title = subscription.title;
            cell.toggled = [subscription.value boolValue];
            cell.action = ^(BOOL toggled) {
                [subscription setValueWithBool:toggled];
            };
            
            return cell;
        }
    }
    
    return [UITableViewCell new];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForConfigSectionAtRow:(NSUInteger)row {
    ZGRConfig *config = [[ZGRMessaging sharedInstance] config];
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextFieldTableViewCell class])];
    
    switch (row) {
        case 0: {
            cell.title = @"Application id";
            cell.value = config.applicationId;
            cell.action = ^(NSString *value) {
                config.applicationId = value;
            };
            
            return cell;
        }
        case 1: {
            cell.title = @"Api key";
            cell.value = config.apiKey;
            cell.action = ^(NSString *value) {
                config.apiKey = value;
            };
            
            return cell;
        }
        case 2: {
            cell.title = @"Endpoint";
            cell.value = config.endpoint.absoluteString;
            cell.action = ^(NSString *value) {
                config.endpoint = [NSURL URLWithString:value];
            };
            
            return cell;
        }
    }
    
    return [UITableViewCell new];
}

#pragma mark - Actions

- (IBAction)onDoneTap:(id)sender {
    __weak __typeof(self) weakSelf = self;
    [[ZGRMessaging sharedInstance] saveInstallation:self.installation withCompletionHandler:^{
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
        });
    }];
}

@end
