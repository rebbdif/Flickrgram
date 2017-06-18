//
//  ImageDownloadOperation.h
//  lection14
//
//  Created by 1 on 24.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVFacadeProtocol.h"
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

@property (nonatomic, assign) SLVImageStatus status;

@property (nonatomic, assign) CGSize imageViewSize;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFacade:(id<SLVFacadeProtocol>)facade url:(NSString *)url attribute:(NSString *)attribute;

- (void)pause;

- (void)resume;


@end
