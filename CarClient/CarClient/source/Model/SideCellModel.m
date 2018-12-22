//
//  SideCellModel.m
//  CarClient
//
//  Created by 栗志 on 2018/12/22.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "SideCellModel.h"

@interface SideCellModel()

@property(nonatomic,copy,readwrite)NSString *imageName;
@property(nonatomic,copy,readwrite)NSString *title;
@property(nonatomic,unsafe_unretained,readwrite)SEL action;

@end

@implementation SideCellModel

- (instancetype)initWithImage:(NSString *)imageName title:(NSString *)title action:(SEL)action
{
    if (self = [super init]) {
        self.imageName = imageName;
        self.title = title;
        self.action = action;
    }
    
    return self;
}

@end
