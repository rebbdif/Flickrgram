//
//  SLVNetworkProtocol.h
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLVNetworkProtocol <NSObject>

- (void)getModelFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *json))completionHandler;
- (NSURLSessionTask *)downloadImageFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSString *dataURL))completionHandler;

@end
