
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZGRContentType) {
    ZGRContentTypeNone,
    ZGRContentTypeHTML,
    ZGRContentTypeImage,
    ZGRContentTypeOther
};

/**
 @brief Notification media content.
 */
@interface ZGRContent : NSObject

@property (nonatomic, assign, readonly) ZGRContentType type;
@property (nonatomic, strong, readonly) NSURL *url;

- (nullable NSString *)rawType;

- (nullable instancetype)initWithUserInfo:(NSDictionary *)userInfo;
- (nullable instancetype)initWithURL:(NSURL *)url type:(ZGRContentType)type;

+ (ZGRContentType)contentTypeFromString:(NSString *)string;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
