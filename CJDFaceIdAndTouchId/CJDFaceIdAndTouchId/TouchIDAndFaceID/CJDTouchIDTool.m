//
//  CJDTouchIDTool.m
//  HtmzApp
//
//  Created by 陈嘉栋 on 2022/5/12.
//

#import "CJDTouchIDTool.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import "UIDevice+Hardware.h"

@implementation CJDTouchIDTool

+ (void)
validateTouchID:(ValidateTouchIDBlock)complete andTitle:(NSString*)rightTItle{
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        NSLog(@"系统版本不支持TouchID");
        return;
    }
    
    LAContext *context = [[LAContext alloc] init];
    if (rightTItle && rightTItle.length > 0) {
        context.localizedFallbackTitle = rightTItle;
    }else{
        context.localizedFallbackTitle = @"";
    }
    NSError *err = nil;
    BOOL can = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&err];
//处理警告        LAErrorTouchIDLockout
        if (err.code == LAErrorBiometryLockout) {
            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self validateTouchID:complete andTitle:rightTItle];
                        });
                    });
                }else{
                    //输入密码验证失败
                    complete(CJDValidateTouchIDToolFailed);
                }
            }];
        }
    if (can) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:[UIDevice currentDevice].isX ? @"面容ID" : @"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if (complete) {
                if (error) {
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:
                            complete(CJDValidateTouchIDToolFailed);
                            break;
                        case LAErrorUserCancel:
                            complete(CJDValidateTouchIDToolCancel);
                            break;
                        case LAErrorUserFallback:
//                            [self validateTouchID:complete];
                            if ([rightTItle isEqualToString:@"再试一次"]) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                        [self validateTouchID:complete andTitle:@"再试一次"];
                                    });
                                });
                            }else{
                                complete(CJDValidateTouchIDToolFallback);
                            }
                            break;
                        case LAErrorPasscodeNotSet:
                            complete(CJDValidateTouchIDToolPasscodeNotSet);
                            break;
                        case LAErrorBiometryNotAvailable: //LAErrorTouchIDNotAvailable:
                            complete(CJDValidateTouchIDToolNotAvailable);
                            break;
                        case LAErrorBiometryNotEnrolled:
//处理警告                          LAErrorTouchIDNotEnrolled:
                            complete(CJDValidateTouchIDToolNotEnrolled);
                            break;
                        case LAErrorBiometryLockout:
                            //LAErrorTouchIDLockout:
                            complete(CJDValidateTouchIDToolTouchIDLockout);
                            break;
                        case LAErrorSystemCancel:
//处理警告                    complete(CJDValidateTouchIDToolCancel);
                            break;
                        default:
                            complete(CJDValidateTouchIDToolFailed);
                            break;
                    }
                } else {
                    complete(CJDValidateTouchIDToolSuccess);
                }
            }
        }];
    } else {
        if (err.code == -6) {
            if ([UIDevice currentDevice].isX) {
                [self alertMessage];
                complete(CJDValidateTouchIDToolUnopenedDvice);
            } else {
                complete(CJDValidateTouchIDToolNotSupport);
            }
        } else if (err.code == -7) {
            [self alertMessage];
            complete(CJDValidateTouchIDToolUnopenedDvice);
        }
    }
}

+ (void)alertMessage {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"设备未开启识别功能" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if (@available(iOS 10.0, *)) {
            NSDictionary *options = @{UIApplicationOpenURLOptionsOpenInPlaceKey : @YES};
            [[UIApplication sharedApplication] openURL:url options:options completionHandler:^(BOOL success) {
            }];

        } else {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];

        }
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

+ (NSString *)dviceMode {
    if ([UIDevice currentDevice].isX) {
        return @"面部识别解锁";
    }
    return @"指纹解锁";
}

+ (BOOL)isX {
    return [UIDevice currentDevice].isX;
}

@end
