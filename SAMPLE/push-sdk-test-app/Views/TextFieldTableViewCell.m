
#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation TextFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self registerForKeyboardNotifications];
}

#pragma mark - Custom Accessors

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)value {
    return self.textField.text;
}

- (void)setValue:(NSString *)value {
    self.textField.text = value;
}

#pragma mark - Actions

- (IBAction)onEditEnd:(UITextField *)sender {
    if (self.action) {
        self.action(sender.text);
    }
}

- (IBAction)onEditExit:(UITextField *)sender {
    [sender resignFirstResponder];
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
 
   [[NSNotificationCenter defaultCenter] addObserver:self
                                            selector:@selector(keyboardWillHide:)
                                                name:UIKeyboardWillHideNotification object:nil];
}
 
- (void)keyboardDidShow:(NSNotification *)notification {
    if (![self.textField isFirstResponder] || ![self.superview.superview isKindOfClass:[UITableView class]]) {
        return;
    }
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
 
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    tableView.contentInset = contentInsets;
    tableView.scrollIndicatorInsets = contentInsets;
 
    CGRect rect = self.frame;
    rect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(rect, self.textField.frame.origin) ) {
        [tableView scrollRectToVisible:self.textField.frame animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (![self.textField isFirstResponder] || ![self.superview.superview isKindOfClass:[UITableView class]]) {
        return;
    }
    UITableView *tableView = (UITableView *)self.superview.superview;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tableView.contentInset = contentInsets;
    tableView.scrollIndicatorInsets = contentInsets;
}

@end
