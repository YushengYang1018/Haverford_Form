//
//  PlaceAnnotation.h
//  Haverford_Form
//
//  Created by YangYusheng on 12/21/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceAnnotation : NSObject <MKAnnotation>

@property (copy,nonatomic)NSString *title;
@property (assign,nonatomic)CLLocationCoordinate2D coordinate;

- (instancetype)initAnnotationWith:(CLLocation *)location andTitle:(NSString *)title;

@end
