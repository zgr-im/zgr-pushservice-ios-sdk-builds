//
//  UIViewController+Alert.m
//  push-sdk-test-app
//
//  Created by Dmitriy Zharov on 05.01.2021.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)


- (void)ext_showAlertWithTitle:(NSString *)title {
    [self ext_showAlertWithTitle:title message:nil];
}

- (void)ext_showAlertWithTitle:(NSString *)title message:(NSString *)message {
    if (self.presentedViewController) {
        return;
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
