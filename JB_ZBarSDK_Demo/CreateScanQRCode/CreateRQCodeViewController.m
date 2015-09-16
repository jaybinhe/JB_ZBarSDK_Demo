//
//  CreateRQCodeViewController.m
//  DiDi
//
//  Created by jaybin on 15/8/4.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import "CreateRQCodeViewController.h"
#import "QRCodeGenerator.h"
#import "Masonry.h"

#define IOS_VERSION    [[[UIDevice currentDevice] systemVersion] floatValue]


@interface CreateRQCodeViewController ()

@end

@implementation CreateRQCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(IOS_VERSION>=7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)buttonClicked:(id)sender{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 100://生成二维码
        {
            /*字符转二维码
             */
            testImageView.image = [QRCodeGenerator qrImageForString:testTextField.text imageSize:testImageView.bounds.size.width];
        }
            break;
        case 101://保存二维码到相册
        {
            [self saveImageToAlbum];
        }
            break;
        default:
            break;
    }
    
}

//保存二维码图片到相册
-(void)saveImageToAlbum
{
    UIImageWriteToSavedPhotosAlbum(testImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//保存图片回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void *)contextInfo
{
    if(error != NULL)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请打开应用的相册权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
        }];
    }
    else
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"已保存到相册" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
