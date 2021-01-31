//
//  DetailTableViewCell.m
//  push-sdk-test-app
//
//  Created by Dmitriy Zharov on 05.01.2021.
//

#import "DetailTableViewCell.h"

@interface DetailTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *detailLabel;

@end

@implementation DetailTableViewCell

#pragma mark - Custom Accessors

- (NSString *)title {
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)value {
    return self.detailLabel.text;
}

- (void)setValue:(NSString *)value {
    self.detailLabel.text = value;
}

@end
