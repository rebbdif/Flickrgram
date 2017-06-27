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
@class SLVHuman;

typedef void (^voidBlock)(void);

@protocol SLVPostModelProtocol <NSObject>

- (void)makeFavorite:(BOOL)favorite;

- (void)passSelectedItem:(SLVItem *)selectedItem;

- (SLVItem *)getSelectedItem;

- (void)loadImageForItem:(SLVItem *)item withCompletionHandler:(voidBlock)completionHandler;

- (void)getMetadataForSelectedItemWithCompletionHandler:(voidBlock)completionHandler;

- (void)getAvatarForHuman:(SLVHuman *)human withCompletionHandler:(void (^)(UIImage *avatar))completionHandler;

@end
