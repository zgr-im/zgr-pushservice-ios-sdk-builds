
#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@end

@implementation HistoryTableViewCell

#pragma mark - Custom Accessors

- (NSString *)body {
    return self.bodyLabel.text;
}

- (void)setBody:(NSString *)body {
    self.bodyLabel.text = body;
}

- (void)setImageURL:(NSURL *)imageURL {
    // MARK: Don't do like this
    __weak __typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithURL:imageURL
                                                                 completionHandler:^(NSData * _Nullable data,
                                                                                     NSURLResponse * _Nullable response,
                                                                                     NSError * _Nullable error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.iconView.image = [UIImage imageWithData:data];
            });
        }
    }];
    [dataTask resume];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.iconView.image = nil;
}

@end
