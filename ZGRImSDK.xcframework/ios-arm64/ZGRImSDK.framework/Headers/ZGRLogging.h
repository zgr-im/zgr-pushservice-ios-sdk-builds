//
//  ZGRLogging.h
//  zgr.im.sdk
//

#import <Foundation/Foundation.h>
#import <OSLog/OSLog.h>

#ifdef DEBUG
#   define log_info(logObject, format, ...)    os_log(logObject, "%s [Line %d] " format, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#   define log_debug(logObject, format, ...)   os_log_debug(logObject, "%s " format, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#   define log_error(logObject, format, ...)   os_log_error(logObject, "%s " format, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#   define log_fault(logObject, format, ...)   os_log_fault(logObject, "%s " format, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#   define log_info(logObject, format, ...)
#   define log_debug(logObject, format, ...)
#   define log_error(logObject, format, ...)
#   define log_fault(logObject, format, ...)
#endif
