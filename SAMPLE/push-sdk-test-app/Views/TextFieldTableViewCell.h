
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TextFieldTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, nullable, copy) NSString *value;

@property (nonatomic, nullable, copy) void (^action)(NSString *value);

@end

NS_ASSUME_NONNULL_END
