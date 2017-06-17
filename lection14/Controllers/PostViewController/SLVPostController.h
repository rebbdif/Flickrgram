//
//  SLVPostViewController.h
//  lection14
//
//  Created by 1 on 01.06.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLVPostModelProtocol.h"

@interface SLVPostController : UIViewController

- (instancetype)initWithModel:(id<SLVPostModelProtocol>)model;

@end
