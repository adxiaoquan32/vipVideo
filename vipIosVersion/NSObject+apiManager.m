//
//  NSObject+apiManager.m
//  vipIosVersion
//
//  Created by xiaoquan.jiang on 7/1/2020.
//  Copyright © 2020 xiaoquan.jiang. All rights reserved.
//

#import "NSObject+apiManager.h"
#import <objc/runtime.h>
  
@implementation NSObject (apiManager)


- (AFHTTPSessionManager  *)sessionManager {
    static AFHTTPSessionManager *_af_defaultHTTPSessionManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_defaultHTTPSessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _af_defaultHTTPSessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _af_defaultHTTPSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    });

    return objc_getAssociatedObject(self, @selector(sessionManager)) ?: _af_defaultHTTPSessionManager;
}

- (void)setSessionManager:(AFHTTPSessionManager *)sessionManager {
    objc_setAssociatedObject(self, @selector(sessionManager), sessionManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (id)json:(NSString*)fileName{
     NSError *error = nil;
     NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
     NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
     return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

- (NSArray<NSDictionary*>*)adUrlList{
    static NSArray *_af_adUrlList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _af_adUrlList = [self json:@"adlist"];
    });
    return _af_adUrlList;
}

- (NSArray<NSDictionary*>*)p2pPlatList{
    static NSArray *_af_p2pPlatList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *fileDic = [self json:@"vlist"];
        _af_p2pPlatList = fileDic[@"platformlist"];
    });
    return _af_p2pPlatList;
}

- (NSArray<NSDictionary*>*)tranferList{
    static NSArray *_af_tranferList = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *fileDic = [self json:@"vlist"];
        _af_tranferList = fileDic[@"list"];
    });
    return _af_tranferList;
}


@end
