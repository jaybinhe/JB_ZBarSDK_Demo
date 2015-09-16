//
//  ViewController.m
//  JB_ZBarSDK_Demo
//
//  Created by jaybin on 15/8/26.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "ScanQRCodeViewController.h"
#import "UIColor+HEX.h"
#import "CreateRQCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *normalScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [normalScanBtn setTitle:@"常规扫描二维码" forState:UIControlStateNormal];
    [normalScanBtn setBackgroundColor:[UIColor colorWithHexString:@"#3498db"]];
    [normalScanBtn addTarget:self action:@selector(normalScanQRCodeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:normalScanBtn];
    __weak __typeof(self) weakSelf = self;
    [normalScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    UIButton *customScanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customScanBtn setTitle:@"自定义扫描二维码" forState:UIControlStateNormal];
    [customScanBtn setBackgroundColor:[UIColor colorWithHexString:@"#3498db"]];
    [customScanBtn addTarget:self action:@selector(customScanQRCodeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customScanBtn];
    [customScanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(200);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
    
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [createBtn setTitle:@"生成二维码" forState:UIControlStateNormal];
    [createBtn setBackgroundColor:[UIColor colorWithHexString:@"#3498db"]];
    [createBtn addTarget:self action:@selector(createQRCodeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createBtn];
    [createBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.view).with.offset(300);
        make.size.mas_equalTo(CGSizeMake(150, 40));
    }];
}

- (void)customScanQRCodeView{
    ScanQRCodeViewController *scanQRCodeVC = [[ScanQRCodeViewController alloc] initWithNibName:@"ScanQRCodeViewController" bundle:nil];
    [self.navigationController pushViewController:scanQRCodeVC animated:YES];
}

- (void)createQRCodeView{
    CreateRQCodeViewController *createQRCodeVC = [[CreateRQCodeViewController alloc] initWithNibName:@"CreateRQCodeViewController" bundle:nil];
    [self.navigationController pushViewController:createQRCodeVC animated:YES];
}

- (void)normalScanQRCodeView{
    //初始化相机控制器
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //基本适配
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    //二维码/条形码识别设置
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    //弹出系统照相机，全屏拍摄
    [self presentViewController:reader animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark ZBarReaderDelegate
//扫描二维码的时候，识别成功会进入此方法，读取二维码内容
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *result = symbol.data;
    
    NSLog(@"%@",result);
    
    //二维码扫描成功，弹窗提示
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描成功" message:[NSString stringWithFormat:@"二维码内容:\n%@",result] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:^{
    }];
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
