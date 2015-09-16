//
//  ScanQRCodeViewController.m
//  DiDi
//
//  Created by jaybin on 15/7/28.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "QRView.h"
#import "Masonry.h"
#import "UIColor+HEX.h"

#define IOS_VERSION    [[[UIDevice currentDevice] systemVersion] floatValue]

#define LIGHTBUTTONTAG      100
#define IMPORTBUTTONTAG     101
#define CONFIRMBUTTONTAG    102

@interface ScanQRCodeViewController (){
    ZBarReaderView *_readview;//扫描二维码ZBarReaderView
    QRView *_qrRectView;//自定义的扫描视图
    
    UIButton *_lightingBtn;//照明按钮
    UIButton *_importQRCodeImageBtn;//导入二维码图片按钮
    UIButton *_importQRCodeImage;
    
    UIImagePickerController *_picker;//系统相册视图
    
}

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(IOS_VERSION>=7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:[UIColor colorWithRed:148.0/255.0 green:148.0/255.0 blue:148.0/255.0 alpha:1.0]];
    //初始化扫描视图
    [self configuredZBarReader];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //开始扫描
    [self setZBarReaderViewStart];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止扫描
    [self setZBarReaderViewStop];
}

/**
 *初始化扫描二维码对象ZBarReaderView
 *@param 设置扫描二维码视图的窗口布局、参数
 */
-(void)configuredZBarReader{
    //初始化照相机窗口
    _readview = [[ZBarReaderView alloc] init];
    //设置扫描代理
    _readview.readerDelegate = self;
    //关闭闪光灯
    _readview.torchMode = 0;
    //显示帧率
    _readview.showsFPS = NO;
    //将其照相机拍摄视图添加到要显示的视图上
    [self.view addSubview:_readview];
    //二维码/条形码识别设置
    ZBarImageScanner *scanner = _readview.scanner;
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    //Layout ZBarReaderView
    __weak __typeof(self) weakSelf = self;
    [_readview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).with.offset(0);
        make.left.equalTo(weakSelf.view).with.offset(0);
        make.right.equalTo(weakSelf.view).with.offset(0);
        make.bottom.equalTo(weakSelf.view).with.offset(0);
    }];
    
    //初始化扫描二维码视图的子控件
    [self configuredZBarReaderMaskView];
    
    //启动，必须启动后，手机摄影头拍摄的即时图像菜可以显示在readview上
    //[_readview start];
    //[_qrRectView startScan];
}


/**
 *自定义扫描二维码视图样式
 *@param 初始化扫描二维码视图的子控件
 */
- (void)configuredZBarReaderMaskView{
    //扫描的矩形方框视图
    _qrRectView = [[QRView alloc] init];
    _qrRectView.transparentArea = CGSizeMake(220, 220);
    _qrRectView.backgroundColor = [UIColor clearColor];
    [_readview addSubview:_qrRectView];
    [_qrRectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_readview).with.offset(0);
        make.left.equalTo(_readview).with.offset(0);
        make.right.equalTo(_readview).with.offset(0);
        make.bottom.equalTo(_readview).with.offset(0);
    }];
    
    //照明按钮
    _lightingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_lightingBtn setTitle:@"照明" forState:UIControlStateNormal];
    [_lightingBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    _lightingBtn.layer.borderColor = [UIColor colorWithHexString:@"#3498db"].CGColor;
    _lightingBtn.layer.borderWidth = 1.0;
    _lightingBtn.layer.cornerRadius = 8.0;
    [_lightingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [_lightingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lightingBtn setBackgroundColor:[UIColor clearColor]];
    _lightingBtn.tag = LIGHTBUTTONTAG;
    [_lightingBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_qrRectView addSubview:_lightingBtn];
    [_lightingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_qrRectView).with.offset(-100);
        make.centerX.equalTo(_qrRectView);
        make.size.mas_equalTo(CGSizeMake(88, 28));
    }];
    UIImageView *lightImage = [[UIImageView alloc] init];
    lightImage.image = [UIImage imageNamed:@"bulb"];
    [_lightingBtn addSubview:lightImage];
    [lightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_lightingBtn);
        make.left.equalTo(_lightingBtn).with.offset(17);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    
    //导入二维码图片
    _importQRCodeImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_importQRCodeImageBtn setTitle:@"导入二维码" forState:UIControlStateNormal];
    [_importQRCodeImageBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_importQRCodeImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_importQRCodeImageBtn setBackgroundColor:[UIColor clearColor]];
    _importQRCodeImageBtn.tag = IMPORTBUTTONTAG;
    [_importQRCodeImageBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_qrRectView addSubview:_importQRCodeImageBtn];
    [_importQRCodeImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_qrRectView.mas_bottom).with.offset(-32);
        make.right.equalTo(_qrRectView.mas_right).with.offset(-20);
        make.size.mas_equalTo(CGSizeMake(60, 12));
    }];
    
    _importQRCodeImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_importQRCodeImage setBackgroundImage:[UIImage imageNamed:@"album"] forState:UIControlStateNormal];
    _importQRCodeImage.tag = IMPORTBUTTONTAG;
    [_importQRCodeImage addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_qrRectView addSubview:_importQRCodeImage];
    [_importQRCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_qrRectView).with.offset(-48);
        make.centerX.equalTo(_importQRCodeImageBtn);
        make.size.mas_equalTo(CGSizeMake(32, 32));
    }];
}

- (void)buttonClicked:(UIButton *)sender{
    switch (sender.tag) {
        case LIGHTBUTTONTAG://照明按钮
        {
            if(0 != _readview.torchMode){
                //关闭闪光灯
                _readview.torchMode = 0;
            }else if (0 == _readview.torchMode){
                //打开闪光灯
                _readview.torchMode = 1;
            }
            
        }
            break;
        case IMPORTBUTTONTAG://导入二维码图片
        {
            [self presentImagePickerController];
        }
            break;
    
        default:
            break;
    }
}

/**
 *打开二维码扫描视图ZBarReaderView
 *@param 关闭闪光灯
 */
- (void)setZBarReaderViewStart{
    _readview.torchMode = 0;//关闭闪光灯
    [_readview start];//开始扫描二维码
    [_qrRectView startScan];
    
}

/**
 *关闭二维码扫描视图ZBarReaderView
 *@param 关闭闪光灯
 */
- (void)setZBarReaderViewStop{
    _readview.torchMode = 0;//关闭闪光灯
    [_readview stop];//关闭扫描二维码
    [_qrRectView stopScan];
}

//弹出系统相册、相机
-(void)presentImagePickerController{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker = [[UIImagePickerController alloc] init];
    _picker.sourceType               = sourceType;
    _picker.allowsEditing            = YES;
    //    NSArray *temp_MediaTypes        = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
    //    picker.mediaTypes               = temp_MediaTypes;
    _picker.delegate                 = self;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_picker.view];
    [_picker.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(window);
        make.size.equalTo(window);
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //收起相册
    [picker.view removeFromSuperview];
}

#pragma mark -
#pragma mark ZBarReaderViewDelegate
//扫描二维码的时候，识别成功会进入此方法，读取二维码内容
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image{
    //停止扫描
    [self setZBarReaderViewStop];
    
    ZBarSymbol *symbol = nil;
    for (symbol in symbols) {
        break;
    }
    NSString *urlStr = symbol.data;
    
    if(urlStr==nil || urlStr.length<=0){
        //二维码内容解析失败
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //重新扫描
            [weakSelf setZBarReaderViewStart];
        }];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
        }];
        
        return;
    }
    
    NSLog(@"urlStr: %@",urlStr);
    
    //二维码扫描成功，弹窗提示
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描成功" message:[NSString stringWithFormat:@"二维码内容:\n%@",urlStr] preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //继续扫描
        [weakSelf setZBarReaderViewStart];
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:^{
        
    }];
    
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
//导入二维码的时候会进入此方法，处理选中的相片获取二维码内容
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //停止扫描
    [self setZBarReaderViewStop];
    
    //处理选中的相片,获得二维码里面的内容
    ZBarReaderController *reader = [[ZBarReaderController alloc] init];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGImageRef cgimage = image.CGImage;
    ZBarSymbol *symbol = nil;
    for(symbol in [reader scanImage:cgimage])
        break;
    NSString *urlStr = symbol.data;
    
    [picker.view removeFromSuperview];
    
    if(urlStr==nil || urlStr.length<=0){
        //二维码内容解析失败
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weak __typeof(self) weakSelf = self;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //重新扫描
            [weakSelf setZBarReaderViewStart];
        }];
        [alertVC addAction:action];
        [self presentViewController:alertVC animated:YES completion:^{
        }];

        return;
    }
    
    NSLog(@"urlStr: %@",urlStr);
    
    //二维码扫描成功，弹窗提示
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"扫描成功" message:[NSString stringWithFormat:@"二维码内容:\n%@",urlStr] preferredStyle:UIAlertControllerStyleAlert];
    __weak __typeof(self) weakSelf = self;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //继续扫描
        [weakSelf setZBarReaderViewStart];
    }];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:^{
    }];
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
