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

- (SLVItem *)fetchItemForKey:(NSString *)key;

- (void)loadImageForItem:(SLVItem *)currentItem forURL:(NSString *)url forAttribute:(NSString *)attribute withCompletionHandler:(void (^)(void))completionHandler;

- (void)cancelOperations;

- (void)resumeOperations;

- (void)clearModel:(BOOL)entirely;

@end
