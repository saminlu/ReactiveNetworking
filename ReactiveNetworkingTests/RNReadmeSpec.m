//
//  RNReadmeSpec.m
//  ReactiveNetworking
//
//  Created by Plunien, Johannes on 22/06/14.
//  Copyright (c) 2014 Johannes Plunien. All rights reserved.
//

#import <ReactiveNetworking/ReactiveNetworking.h>

@interface RNReadmeUser : RNObject

@property (nonatomic, copy, readonly) NSString *login;
@property (nonatomic, copy, readonly) NSString *name;

@end

@implementation RNReadmeUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSDictionary *mapping = @{@"login": @"login",
                              @"name": @"name"};
	return [super.JSONKeyPathsByPropertyKey mtl_dictionaryByAddingEntriesFromDictionary:mapping];
}

@end

@interface RNReadmeClient : RNClient

- (RACSignal *)fetchUser:(NSString *)username;

@end

@implementation RNReadmeClient

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (url == nil) url = [NSURL URLWithString:@"https://api.example.com"];
    self = [super initWithBaseURL:url];
    if (self) {
        [self registerHTTPOperationClass:AFJSONRequestOperation.class];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    return self;
}

- (RACSignal *)fetchUser:(NSString *)username
{
    NSString *path = [NSString stringWithFormat:@"/users/%@", username];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:nil];
	return [self enqueueRequest:request
                    resultClass:RNReadmeUser.class
                       keyPaths:@[@"user"]];
}

@end

SpecBegin(RNReadmeClient)

describe(@"the example in the readme should work", ^{
    __block BOOL success;
    __block NSError *error;

    beforeEach(^{
        success = NO;
        error = nil;
    });

    it(@"should return the object", ^{
        [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
            return [request.URL.path isEqual:@"/users/plu"];
        } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
            NSURL *fileURL = [[NSBundle bundleForClass:self.class] URLForResource:@"readme" withExtension:@"json"];
            return [OHHTTPStubsResponse responseWithFileAtPath:fileURL.path statusCode:200 headers:@{@"Content-Type": @"application/json"}];
        }];

        RNReadmeClient *client = [[RNReadmeClient alloc] initWithBaseURL:nil];
        expect(client).notTo.beNil();
        expect(client.baseURL).to.equal([NSURL URLWithString:@"https://api.example.com"]);

        RACSignal *result = [client fetchUser:@"plu"];
        RNResponse *response = [result asynchronousFirstOrDefault:nil success:&success error:&error];
        RNReadmeUser *user = response.parsedResult;

        expect(response).notTo.beNil();
        expect(success).to.beTruthy();
        expect(error).to.beNil();
        expect(user.login).to.equal(@"plu");
        expect(user.name).to.equal(@"Johannes Plunien");
        expect(user.objectID).to.equal(@"42");

        // This is just for copy & paste into the readme
        [[client fetchUser:@"plu"] subscribeNext:^(RNResponse *response) {
            NSLog(@"%@", response.parsedResult);
        }];
    });
});


SpecEnd
