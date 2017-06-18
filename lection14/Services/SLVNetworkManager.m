//
//  NetworkManager.m
//  lection14
//
//  Created by iOS-School-1 on 04.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import "SLVNetworkManager.h"
#import <UIKit/UIKit.h>

@interface SLVNetworkManager()

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation SLVNetworkManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return self;
}

- (void)getModelFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSDictionary *json))completionHandler {
    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            NSError *jsonError=nil;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
            if (!jsonError) {
                completionHandler(json);
            } else {
                NSLog(@"ERROR PARSING JSON %@",error.userInfo);
            }
        } else if (error) {
            NSLog(@"error while downloading data %@",error.userInfo);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }];
    task.priority=NSURLSessionTaskPriorityHigh;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    [task resume];
}

- (NSURLSessionTask *)downloadImageFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSData *data))completionHandler {
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSData *data = [NSData dataWithContentsOfURL:location];
        NSError *fileError = nil;
        [[NSFileManager defaultManager] removeItemAtURL:location error:&fileError];
        completionHandler(data);
    }];
    [task resume];
    return task;
}


@end
