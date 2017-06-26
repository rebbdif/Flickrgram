//
//  SLVPostModelProtocol.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVFacadeProtocol.h"

@class UIImage;
@class SLVItem;

@protocol SLVPostModelProtocol <NSObject>

- (void)makeFavorite:(BOOL)favorite;

- (void)passSelectedItem:(SLVItem *)selectedItem;

- (SLVItem *)getSelectedItem;

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(void (^)(void))completionHandler;

@end
