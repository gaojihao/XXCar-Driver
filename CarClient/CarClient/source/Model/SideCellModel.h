//
//  SideCellModel.h
//  CarClient
//
//  Created by 栗志 on 2018/12/22.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SideCellModel : NSObject

- (instancetype)initWithImage:(NSString *)imageName title:(NSString *)title action:(SEL)action;

@property(nonatomic,copy,readonly)NSString *imageName;
@property(nonatomic,copy,readonly)NSString *title;
@property(nonatomic,unsafe_unretained,readonly)SEL action;

@end

NS_ASSUME_NONNULL_END
