//
//  SLVMetadataLoadOperation.m
//  flickrgram
//
//  Created by 1 on 28.06.17.
//  Copyright © 2017 serebryanyy. All rights reserved.
//

#import "SLVMetadataLoadOperation.h"
#import "NSString+SLVString.h"
#import "SLVHuman.h"
#import "SLVItem.h"
#import "SLVComment.h"

typedef void (^voidBlock)(void);

@interface SLVMetadataLoadOperation()

@property (nonatomic, strong) SLVItem *selectedItem;
@property (nonatomic, strong, readonly) id<SLVStorageProtocol> storageService;
@property (nonatomic, strong, readonly) id<SLVNetworkProtocol> networkManager;

@property (nonatomic, strong) dispatch_semaphore_t infoSemaphore;
@property (nonatomic, strong) dispatch_semaphore_t favoritesSemaphore;
@property (nonatomic, strong) dispatch_semaphore_t commentsSemaphore;


@end

@implementation SLVMetadataLoadOperation

- (instancetype)initWithItem:(SLVItem *)item storageService:(id<SLVStorageProtocol>)storageService networkManager:(id<SLVNetworkProtocol>)networkManager {
    self = [super init];
    if (self) {
        _selectedItem = item;
        _storageService = storageService;
        _networkManager = networkManager;
    }
    return self;
}

- (void)main {
    __weak typeof(self)weakSelf = self;
    self.infoSemaphore = dispatch_semaphore_create(0);
    self.favoritesSemaphore = dispatch_semaphore_create(0);
    self.commentsSemaphore = dispatch_semaphore_create(0);
    
    const char apiKeyChar[] = "api_key=6a719063cc95dcbcbfb5ee19f627e05e";
    NSString *apiKey = [NSString stringWithCString:apiKeyChar encoding:1];
    NSString *photoID = [NSString stringWithFormat:@"photo_id=%@", self.selectedItem.photoID];
    NSString *secret = [NSString stringWithFormat:@"secret=%@", self.selectedItem.photoSecret];
    
    NSString *infoPath = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&format=json&nojsoncallback=1&%@&%@&%@", apiKey, photoID, secret];
    NSURL *infoURL = [NSURL URLWithString:infoPath];
    [self.networkManager getJSONFromURL:infoURL withCompletionHandler:^(NSDictionary *json) {
        [weakSelf parseInfo:json];
    }];

//    NSString *favoritesPath = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.getFavorites&format=json&nojsoncallback=1&%@&%@", apiKey, photoID];
//    NSURL *favoritesURL = [NSURL URLWithString:favoritesPath];
//    [self.networkManager getJSONFromURL:favoritesURL withCompletionHandler:^(NSDictionary *json) {
//        [weakSelf parseFavorites:json];
//    }];
//
    NSString *commetnsPath = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.comments.getList&format=json&nojsoncallback=1&%@&%@", apiKey, photoID];
    NSURL *commentsURL = [NSURL URLWithString:commetnsPath];
    [self.networkManager getJSONFromURL:commentsURL withCompletionHandler:^(NSDictionary *json) {
        [weakSelf parseComments:json];
    }];
    
    dispatch_semaphore_wait(self.infoSemaphore, DISPATCH_TIME_FOREVER);
//    dispatch_semaphore_wait(self.favoritesSemaphore, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(self.commentsSemaphore, DISPATCH_TIME_FOREVER);
}

- (void)parseInfo:(NSDictionary *)json {
    [self.storageService performBlockAsynchronously:^{
        NSString *country = json[@"photo"][@"location"][@"country"][@"_content"];
        NSString *unicodeCountry = [NSString stringWithEscapedEmojis:country];
        NSString *city = json[@"photo"][@"location"][@"locality"][@"_content"];
        NSString *unicodeCity = [NSString stringWithEscapedEmojis:city];
        NSString *location = [NSString stringWithFormat:@"%@, %@", unicodeCity, unicodeCountry];
        
        SLVHuman *owner = [SLVHuman humanWithDictionary:json[@"photo"][@"owner"] storage:self.storageService];
        self.selectedItem.author = owner;
        self.selectedItem.location = location;
    } withCompletion:^{
        dispatch_semaphore_signal(self.infoSemaphore);
    }];
}

- (void)parseFavorites:(NSDictionary *)json {
    [self.storageService performBlockAsynchronously:^{
        NSString *numberOfLikes = json[@"photo"][@"total"];
        self.selectedItem.numberOfLikes = numberOfLikes;
        NSMutableSet *favorited = [NSMutableSet new];
        for (NSDictionary *likeDictionary in json[@"photo"][@"person"]) {
            SLVComment *like = [SLVComment commentWithDictionary:likeDictionary type:SLVCommentTypeLike storage:self.storageService];
            [favorited addObject:like];
        }
        [self.selectedItem addComments:favorited];
    } withCompletion:^{
        dispatch_semaphore_signal(self.favoritesSemaphore);
    }];
}

- (void)parseComments:(NSDictionary *)json {
    [self.storageService performBlockAsynchronously:^{
        NSArray *commentsJSON = json[@"comments"][@"comment"];
        NSString *numberOfComments = [NSString stringWithFormat:@"%ld", commentsJSON.count];
        self.selectedItem.numberOfComments = numberOfComments;
        NSMutableSet *comments = [NSMutableSet new];
        for (NSDictionary *commentDictionary in commentsJSON) {
            SLVComment *comment = [SLVComment commentWithDictionary:commentDictionary type:SLVCommentTypeComment storage:self.storageService];
            [comments addObject:comment];
        }
        [self.selectedItem addComments:comments];
    } withCompletion:^{
        dispatch_semaphore_signal(self.commentsSemaphore);
    }];    
}

@end
