//
//  LZHttpTask.h
//  Pods
//
//  Created by 栗志 on 2018/12/15.
//

#import <Foundation/Foundation.h>

/**
 * 任务状态
 */
typedef NS_ENUM(NSInteger, LZHttpTaskStatus) {
    LZHttpTaskStatusFinish,
    LZHttpTaskStatusExecuting
};

NS_ASSUME_NONNULL_BEGIN

@interface LZHttpTask : NSObject

@property (nonatomic, strong, readonly) NSString *url;
@property (nonatomic, strong, readonly) NSDictionary *params;
@property (nonatomic, strong, readonly) NSDictionary *header;
@property (nonatomic, assign, readonly) NSUInteger identifier;
@property (nonatomic, strong, readonly) NSURLRequest *request;
@property (nonatomic, strong) NSURLSessionTask *task;

@property (nonatomic, assign) LZHttpTaskStatus taskStatus;

- (instancetype)initWithTask:(NSURLSessionTask *) task
                     withUrl:(NSString *) url
                  withParams:(NSDictionary *)params
                  withHeader:(NSDictionary *) header;

- (void)cancel;

- (BOOL)isExecuting;

@end

NS_ASSUME_NONNULL_END
