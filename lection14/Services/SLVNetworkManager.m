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

- (NSURLSessionTask *)downloadImageFromURL:(NSURL *)url withCompletionHandler:(void (^)(NSString *dataURL))completionHandler {
    NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:url completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode != 200) {
            NSLog(@"nsurlTask statusCode == %ld", httpResponse.statusCode);
        }
        if (error) {
            NSLog(@"error when downloading image %@", error.localizedDescription);
        } else {
            NSString *newUrl = [self moveToDocumentsFromLocation:location lastPathComponent:[url lastPathComponent]];
            completionHandler(newUrl);
        }
    }];
    [task resume];
    return task;
}

- (NSString *)moveToDocumentsFromLocation:(NSURL *)location lastPathComponent:(NSString *)lastPathComponent {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *savedURLs=[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsDirectory = [savedURLs objectAtIndex:0];
    NSURL *destinationUrl = [documentsDirectory URLByAppendingPathComponent:lastPathComponent];
    
    NSError *error = nil;
    [fileManager removeItemAtURL:destinationUrl error:NULL];
    [fileManager copyItemAtURL:location toURL:destinationUrl error:&error];
    return [destinationUrl path];
}

@end
