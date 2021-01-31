//
//  DetailTableViewCell.h
//  push-sdk-test-app
//
//  Created by Dmitriy Zharov on 05.01.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, nullable, copy) NSString *value;

@end

NS_ASSUME_NONNULL_END
