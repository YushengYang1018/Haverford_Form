//
//  UserInformation.h
//  Haverford_Form
//
//  Created by YangYusheng on 12/22/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInformation : NSObject

@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *email;
@property (strong,nonatomic)NSString *department;
@property (strong,nonatomic)NSString *major;
@property (strong,nonatomic)NSString *address;
@property (strong,nonatomic)NSString *phoneNumber;

+ (id)sharedUserInformation;

@end
