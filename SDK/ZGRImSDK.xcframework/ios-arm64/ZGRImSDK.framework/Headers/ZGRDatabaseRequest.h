
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZGRDatabaseRequest : NSObject

@property (nonatomic, assign) NSUInteger fetchLimit; /**< Default: NSUIntegerMax */
@property (nonatomic, assign) NSUInteger pageOffset; /**< Default: 0. Offsets results by provided number of pages (size of page is equal to ` fetchLimit`) */
@property (nonatomic, nullable, strong) NSDate *fromDate;
@property (nonatomic, nullable, strong) NSDate *toDate;

@end

NS_ASSUME_NONNULL_END
