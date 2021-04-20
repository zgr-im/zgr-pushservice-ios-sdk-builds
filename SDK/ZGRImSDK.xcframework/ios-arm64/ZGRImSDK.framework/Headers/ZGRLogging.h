//
//  ZGRLogging.h
//  zgr.im.sdk
//
//  Created by alex on 08.04.2021.
//

#import <Foundation/Foundation.h>
#import <OSLog/OSLog.h>

#define log(format, ...)    os_log_with_type(OS_LOG_DEFAULT, OS_LOG_TYPE_DEFAULT, format, ##__VA_ARGS__)
