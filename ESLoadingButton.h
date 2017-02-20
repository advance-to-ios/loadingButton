//
//  ESLoadingButton.h
//  EduSoho
//
//  Created by LiweiWang on 2016/11/24.
//  Copyright © 2016年 Kuozhi Network Technology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ESLoadingButton : UIButton

- (void)showLoadingBlock:(void (^)())block;

- (void)dismissLoadingBlock:(void (^)())block;

@end
