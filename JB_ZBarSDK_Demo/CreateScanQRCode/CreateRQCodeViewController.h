//
//  CreateRQCodeViewController.h
//  DiDi
//
//  Created by jaybin on 15/8/4.
//  Copyright (c) 2015年 jaybin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateRQCodeViewController : UIViewController<UITextFieldDelegate>{
    IBOutlet UIImageView *testImageView;//二维码图片
    IBOutlet UITextField *testTextField;
    
}

- (IBAction)buttonClicked:(id)sender;

@end
