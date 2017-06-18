//
//  ImageDownloadOperation.h
//  lection14
//
//  Created by 1 on 24.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class SLVItem;
@class SLVNetworkManager;

typedef NS_ENUM(NSInteger, SLVImageStatus) {
    SLVImageStatusDownloading,
    SLVImageStatusDownloaded,
    SLVImageStatusFiltered,
    SLVImageStatusCropped,
    SLVImageStatusCancelled,
    SLVImageStatusNone
};

@interface SLVImageDownloadOperation : NSOperation

@property (weak, nonatomic) NSString *key;
@property (assign, nonatomic) SLVImageStatus status;
@property (assign, nonatomic) CGSize imageViewSize;
@property (weak, nonatomic) NSString *url;
@property (assign, nonatomic) BOOL large;

- (void)pause;
- (void)resume;

@end
