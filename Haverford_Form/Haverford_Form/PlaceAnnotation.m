//
//  PlaceAnnotation.m
//  Haverford_Form
//
//  Created by YangYusheng on 12/21/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import "PlaceAnnotation.h"

@implementation PlaceAnnotation

- (instancetype)initAnnotationWith:(CLLocation *)location andTitle:(NSString *)title
{
    self = [self init];
    if (self) {
        self.title = title;
        self.coordinate = location.coordinate;
        return self;
    }
    return self;
}

@end
