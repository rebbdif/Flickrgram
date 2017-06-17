//
//  SLVPostDataProvider.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVPostModelProtocol.h"
#import "SLVPostViewCells.h"
@import UIKit;

@interface SLVPostDataProvider : NSObject<UITableViewDataSource>

- (instancetype)initWithModel:(id<SLVPostModelProtocol>)model andController:(id<UITableViewDelegate, SLVCellsDelegate>)controller;

@end
