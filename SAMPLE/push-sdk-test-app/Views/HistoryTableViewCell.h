
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *body;
@property (nonatomic, nullable, strong) NSURL *imageURL;

@end

NS_ASSUME_NONNULL_END
