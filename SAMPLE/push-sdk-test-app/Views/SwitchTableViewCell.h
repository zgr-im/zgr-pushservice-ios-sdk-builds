
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SwitchTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, getter=isToggled) BOOL toggled;

@property (nonatomic, nullable, copy) void (^action)(BOOL toggled);

@end

NS_ASSUME_NONNULL_END
