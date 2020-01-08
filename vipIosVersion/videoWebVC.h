//
//  videoWebVC.h
//  vipIosVersion
//
//  Created by xiaoquan.jiang on 7/1/2020.
//  Copyright © 2020 xiaoquan.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface videoWebVC : UIViewController

@property (nullable, nonatomic, strong) NSDictionary *platformDic;

@end


@interface viAlertAction : UIAlertAction
@property (nullable, nonatomic, strong) NSDictionary *platformDic;
@end


