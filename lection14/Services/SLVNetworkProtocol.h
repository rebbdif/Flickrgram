//
//  SLVNetworkProtocol.h
//  flickrgram
//
//  Created by 1 on 18.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SLVNetworkProtocol <NSObject>

- (void)getJSONFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *json))completionHandler;

- (void)getDataFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *data))completionHandler;

- (NSURLSessionDownloadTask *)downloadImageFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSString *dataURL))completionHandler;

@end
