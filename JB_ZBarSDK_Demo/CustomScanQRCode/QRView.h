//  自定义扫描视图
//  QRView.h
//  QRWeiXinDemo
//
//  Created by lovelydd on 15/4/25.
//  Copyright (c) 2015年 lovelydd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRView : UIView

/**
 *  透明的区域
 */
@property (nonatomic, assign) CGSize transparentArea;

- (void)startScan;
- (void)stopScan;

@end
