
#import "SwitchTableViewCell.h"

@interface SwitchTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *switchView;

@end

@implementation SwitchTableViewCell

#pragma mark - Custom Accessors

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (BOOL)isToggled {
    return self.switchView.on;
}

- (void)setToggled:(BOOL)toggled {
    self.switchView.on = toggled;
}

#pragma mark - Actions

- (IBAction)onToggle:(UISwitch *)sender {
    if (self.action) {
        self.action(sender.isOn);
    }
}

@end
