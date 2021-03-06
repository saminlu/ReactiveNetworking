//
//  RNClient.h
//  ReactiveNetworking
//
//  Created by Johannes Plunien on 23/06/14.
//  Copyright (c) 2014 Johannes Plunien. All rights reserved.
//

#import "RNBaseClient.h"

@interface RNClient : RNBaseClient

// Inject a custom subclass of RNResponse as responseClass.
- (instancetype)initWithBaseURL:(NSURL *)url responseClass:(Class)responseClass;

- (RACSignal *)enqueueRequest:(NSMutableURLRequest *)request resultClass:(Class)resultClass;
- (RACSignal *)enqueueRequest:(NSMutableURLRequest *)request resultClass:(Class)resultClass keyPaths:(NSArray *)keyPaths;

@end
