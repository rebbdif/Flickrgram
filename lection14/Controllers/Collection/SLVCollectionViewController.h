//
//  CollectionViewController.h
//  lection14
//
//  Created by iOS-School-1 on 27.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLVCollectionModelProtocol.h"

extern NSString * const slvCollectionReuseIdentifier;

@interface SLVCollectionViewController : UIViewController

- (instancetype)initWithModel:(id<SLVCollectionModelProtocol>)model;

@end
