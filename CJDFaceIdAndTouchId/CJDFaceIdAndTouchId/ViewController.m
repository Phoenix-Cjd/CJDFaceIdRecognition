//
//  ViewController.m
//  CJDFaceIdAndTouchId
//
//  Created by 陈嘉栋 on 2022/5/12.
//

#import "ViewController.h"
#import "CJDTouchIDTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    
    button.center = self.view.center;
    button.backgroundColor = UIColor.blueColor;
    [button setTitle:[NSString stringWithFormat:@"点击进行%@",[CJDTouchIDTool dviceMode]] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)buttonDidClicked:(UIButton *)sender
{
    [CJDTouchIDTool validateTouchID:^(CJDValidateTouchIDTool code) {
        
        if (code == CJDValidateTouchIDToolSuccess) {
            
            NSLog(@"面容识别成功");
        }
        
    } andTitle:@"面容识别失败"];
}

@end
