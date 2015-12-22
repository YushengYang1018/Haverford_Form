//
//  UserInformation.m
//  Haverford_Form
//
//  Created by YangYusheng on 12/22/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

+ (id)sharedUserInformation
{
    static UserInformation *userInfo = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfo = [[self alloc]init];
    });
    
    return userInfo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"Guest";
        self.email = @"xxxxxx@haverford.org";
        self.department = @"xxxxxx";
        self.major = @"xxxxxx";
        self.address = @"xxxxxx";
        self.phoneNumber = @"xxxx-xxx-xxx";
    }
    return self;
}

@end
