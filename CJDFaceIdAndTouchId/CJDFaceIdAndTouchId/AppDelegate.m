//
//  AppDelegate.m
//  CJDFaceIdAndTouchId
//
//  Created by 陈嘉栋 on 2022/5/12.
//

#import "AppDelegate.h"
#import "ViewController.h"
@interface AppDelegate ()

@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ViewController *vc = [[ViewController alloc] init];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColor.whiteColor;
    
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
    return YES;
}





@end
