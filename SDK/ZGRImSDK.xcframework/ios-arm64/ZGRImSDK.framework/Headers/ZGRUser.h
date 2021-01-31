
#import <Foundation/Foundation.h>

@class ZGRError;

NS_ASSUME_NONNULL_BEGIN

/**
 @brief User information.
 */
@interface ZGRUser : NSObject

@property (nonatomic, nullable, readonly) NSString *externalUserId;
@property (nonatomic, nullable, readonly) NSString *phoneNumber;

- (nullable instancetype)initWithJSON:(NSString *)json error:(ZGRError * _Nullable * _Nullable)error;
- (nullable instancetype)initWithJSONData:(NSData *)jsonData error:(ZGRError * _Nullable * _Nullable)error;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
