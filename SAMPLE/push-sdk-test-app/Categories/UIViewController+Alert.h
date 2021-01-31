//
//  UIViewController+Alert.h
//  push-sdk-test-app
//
//  Created by Dmitriy Zharov on 05.01.2021.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)

- (void)ext_showAlertWithTitle:(NSString *)title;
- (void)ext_showAlertWithTitle:(NSString *)title message:(nullable NSString *)message;

@end

NS_ASSUME_NONNULL_END
