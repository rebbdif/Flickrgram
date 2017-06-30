//
//  ImageDownloadOperation.h
//  lection14
//
//  Created by 1 on 24.05.17.
//  Copyright © 2017 iOS-School-1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SLVNetworkProtocol.h"
#import "SLVStorageProtocol.h"

@class SLVItem;
@class SLVNetworkManager;

typedef NS_ENUM(NSInteger, SLVImageStatus) {
    SLVImageStatusDownloading,
    SLVImageStatusDownloaded,
    SLVImageStatusCancelled,
    SLVImageStatusError
};

@interface SLVImageDownloadOperation : NSOperation

@property (nonatomic, assign) SLVImageStatus status;

+ (instancetype)new NS_UNAVAILABLE;

- (instancetype)init NS_UNAVAILABLE;

/**
 Инициализатор операции

 @param entityName тип объекта, для которого происходит загрузка
 @param key ключ объекта, для которого происходит загрузка
 @param url url, c которого происходит загрузка
 @param attribute атрибут объекта, в который сохраняем
 */

- (instancetype)initWithNetworkManager:(id<SLVNetworkProtocol>)networkManager storageService:(id<SLVStorageProtocol>)storageService entity:(NSString *)entityName key:(NSString *)key url:(NSString *)url attribute:(NSString *)attribute completion:(void (^)(void))completion;



@end
