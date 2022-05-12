//
//  CJDTouchIDTool.h
//  HtmzApp
//
//  Created by 陈嘉栋 on 2022/5/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CJDValidateTouchIDTool) {
    CJDValidateTouchIDToolSuccess,
    CJDValidateTouchIDToolFailed,
    CJDValidateTouchIDToolCancel,
    CJDValidateTouchIDToolFallback,
    CJDValidateTouchIDToolPasscodeNotSet,
    CJDValidateTouchIDToolNotAvailable,
    CJDValidateTouchIDToolNotEnrolled,
    CJDValidateTouchIDToolTouchIDLockout,
    CJDValidateTouchIDToolUnopenedDvice,
    CJDValidateTouchIDToolNotSupport
};

typedef void(^ValidateTouchIDBlock)(CJDValidateTouchIDTool code);

@interface CJDTouchIDTool : NSObject

+ (NSString *)dviceMode;

+ (BOOL)isX;

+ (void)validateTouchID:(ValidateTouchIDBlock)complete andTitle:(NSString*)rightTItle;

@end

NS_ASSUME_NONNULL_END
