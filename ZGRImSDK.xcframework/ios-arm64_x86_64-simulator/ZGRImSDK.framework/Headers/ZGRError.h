
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSErrorDomain const ZGRErrorDomain;

typedef NS_ENUM(NSInteger, ZGRErrorCode) {
    ZGRErrorCodeLocalDatabaseNotEnabled, // Indicates a problem cause of feature
    ZGRErrorCodeJSONDeserializationError, // Indicates a problem occurred while deserializing the response/JSON.
};

/**
 @brief Error class.
 */
@interface ZGRError : NSError

@end

NS_ASSUME_NONNULL_END
