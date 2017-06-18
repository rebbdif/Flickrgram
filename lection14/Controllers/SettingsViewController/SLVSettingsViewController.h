//
//  SLVSettingsViewController.h
//  lection14
//
//  Created by 1 on 01.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLVModelProtocol.h"

@interface SLVSettingsViewController : UIViewController

- (instancetype)initWithModel:(id<SLVModelProtocol>)model;

@end
