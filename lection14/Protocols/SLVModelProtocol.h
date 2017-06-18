//
//  SLVModelProtocol.h
//  flickrgram
//
//  Created by 1 on 17.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLVItem;
@class UIImage;

@protocol SLVModelProtocol <NSObject>

- (void)loadImageForItem:(SLVItem *)currentItem forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler;
- (UIImage *)imageForItem:(SLVItem *)item;
- (void)cancelOperations;
- (void)resumeOperations;
- (void)clearModel:(BOOL)entirely;

@end
