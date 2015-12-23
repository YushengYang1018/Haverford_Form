//
//  MainViewController.h
//  Haverford_Form
//
//  Created by YangYusheng on 12/21/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceAnnotation.h"
#import <GoogleSignIn/GoogleSignIn.h>

NSString * const centerLocationString = @"485 Devon Park Drive, Wayne, PA, 19087";


@interface MainViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate, GIDSignInUIDelegate>

@end
