//
//  NSObject+apiManager.h
//  vipIosVersion
//
//  Created by xiaoquan.jiang on 7/1/2020.
//  Copyright © 2020 xiaoquan.jiang. All rights reserved.
//
 
#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (apiManager)

- (AFHTTPSessionManager  *)sessionManager;

- (id)json:(NSString*)fileName;

- (NSArray<NSDictionary*>*)adUrlList;

- (NSArray<NSDictionary*>*)p2pPlatList;

- (NSArray<NSDictionary*>*)tranferList;

@end

NS_ASSUME_NONNULL_END
