
#import "HistoryViewController.h"
#import "HistoryTableViewCell.h"

#import <ZGRImSDK/ZGRImSDK.h>

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *pageItem;
@property (weak, nonatomic) IBOutlet UIStepper *pageStepper;
@property (weak, nonatomic) IBOutlet UISegmentedControl *pageSizeControl;

@property (weak, nonatomic) IBOutlet UISwitch *fromSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *fromPicker;

@property (weak, nonatomic) IBOutlet UISwitch *toSwitch;
@property (weak, nonatomic) IBOutlet UIDatePicker *toPicker;

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSMutableArray<ZGRNotification *> *notifications;
@property (nonatomic, strong) ZGRDatabaseRequest *request;

@end

@implementation HistoryViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupDateFormatter];
    
    [self fetchData];
}

- (void)setupTableView {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)setupDateFormatter {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy HH:mm";
    self.dateFormatter = dateFormatter;
}

#pragma mark - Custom Accessors

- (ZGRDatabaseRequest *)request {
    if (!_request) {
        _request = [ZGRDatabaseRequest new];
    }
    return _request;
}

#pragma mark - Data

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)fetchData {
    __weak __typeof(self) weakSelf = self;
    [[ZGRMessaging sharedInstance] fetchNotificationsWithRequest:self.request completionHandler:^(NSArray<ZGRNotification *> * _Nullable notifications,
                                                                                                  ZGRError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        strongSelf.notifications = [notifications mutableCopy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf reloadData];
        });
    }];
}

- (void)deleteObjectAtIndexPath:(NSIndexPath *)indexPath {
    ZGRNotification *notification = self.notifications[indexPath.row];
    
    __weak __typeof(self) weakSelf = self;
    [[ZGRMessaging sharedInstance] deleteNotification:notification withCompletionHandler:^(BOOL success, ZGRError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        if (!success) {
            return;
        }
        
        [strongSelf.notifications removeObject:notification];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [strongSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notifications.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ZGRNotification *notification = self.notifications[indexPath.row];
    
    HistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HistoryTableViewCell class])];
    
    NSMutableString *body = [NSMutableString new];
    [body appendFormat:@"push-id: %@", notification.identifier];
    if (notification.title) {
        [body appendFormat:@" | title: %@", notification.title];
    }
    if (notification.text) {
        [body appendFormat:@" | text: %@", notification.text];
    }
    [body appendFormat:@" | date: %@", [self.dateFormatter stringFromDate:notification.date]];
    if (notification.content.url) {
        [body appendFormat:@" | url: %@", notification.content.url];
    }
    if (notification.customPayload) {
        NSString *customPayload = ((NSObject *)notification.customPayload).description;
        if (customPayload.length > 50) {
            customPayload = [customPayload substringToIndex:50];
        }
        [body appendFormat:@" | customPayload: %@", customPayload];
    }
    cell.body = body;
    
    if (notification.content.type == ZGRContentTypeImage) {
        cell.imageURL = notification.content.url;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (nullable UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
 trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak __typeof(self) weakSelf = self;
    UIContextualAction *deleteAction = [UIContextualAction
                                        contextualActionWithStyle:UIContextualActionStyleDestructive
                                        title:@"Удалить"
                                        handler:^(UIContextualAction * _Nonnull action,
                                                  __kindof UIView * _Nonnull sourceView,
                                                  void (^ _Nonnull completionHandler)(BOOL)) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        
        [strongSelf deleteObjectAtIndexPath:indexPath];
        
        completionHandler(YES);
    }];
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}

#pragma mark - Actions

- (IBAction)onPageValueChange:(UIStepper *)sender {
    NSUInteger page = sender.value;
    self.pageItem.title = [NSString stringWithFormat:@"Стр. %@", @(page + 1)];
    self.request.pageOffset = page;
    
    [self fetchData];
}

- (IBAction)onPageSizeChange:(UISegmentedControl *)sender {
    NSUInteger size = NSUIntegerMax;
    switch (sender.selectedSegmentIndex) {
        case 0:
            size = 3;
            break;
        case 1:
            size = 10;
            break;
        default:
            size = NSUIntegerMax;
            break;
    }
    self.request.fetchLimit = size;
    
    [self fetchData];
}

- (IBAction)onFromDateToggle:(UISwitch *)sender {
    self.request.fromDate = sender.isOn ? self.fromPicker.date : nil;
    self.fromPicker.hidden = !sender.isOn;
    
    [self fetchData];
}

- (IBAction)onFromDateValueChange:(UIDatePicker *)sender {
    if (!self.fromSwitch.isOn) {
        return;
    }
    self.request.fromDate = sender.date;
    
    [self fetchData];
}

- (IBAction)onToDateToggle:(UISwitch *)sender {
    self.request.toDate = sender.isOn ? self.toPicker.date : nil;
    self.toPicker.hidden = !sender.isOn;
    
    [self fetchData];
}

- (IBAction)onToDateValueChange:(UIDatePicker *)sender {
    if (!self.toSwitch.isOn) {
        return;
    }
    self.request.toDate = sender.date;
    
    [self fetchData];
}

@end
