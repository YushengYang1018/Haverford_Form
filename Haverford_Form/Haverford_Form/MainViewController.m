//
//  MainViewController.m
//  Haverford_Form
//
//  Created by YangYusheng on 12/21/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import "MainViewController.h"
#import <BFPaperButton/BFPaperButton.h>
#import <UIColor+BFPaperColors/UIColor+BFPaperColors.h>


@interface MainViewController ()

@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic,strong)CLLocation *centerLocation;
@property (nonatomic,strong)CLCircularRegion *safeRegion;

@property (weak, nonatomic) IBOutlet BFPaperButton *checkInButton;
@property (weak, nonatomic) IBOutlet BFPaperButton *checkOutButton;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeLocationTracking];
    //init buttons
    [self.checkInButton setTitle:@"Chech-In" forState:UIControlStateNormal];
    self.checkInButton.backgroundColor = [UIColor paperColorRed900];
    [self.checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.checkInButton.isRaised = YES;
    
    [self.checkOutButton setTitle:@"Chech-Out" forState:UIControlStateNormal];
    self.checkOutButton.backgroundColor = [UIColor paperColorRed900];
    [self.checkOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.checkOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.checkOutButton.isRaised = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.locationManager.delegate = nil;
    [self.locationManager stopMonitoringForRegion:self.safeRegion];
}

#pragma mark - cllocation delegate
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    //    if ([region.identifier isEqualToString:@"Times Square"]) {
    //        NSLog(@"enter");
    //    }
    [self showAlertViewWithTitle:@"enter" andMessage:@"Please check in"];
//    if ([region.identifier isEqualToString:@"Software Merchant"]) {
//        NSLog(@"Hello SM");
//    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    //    if ([region.identifier isEqualToString:@"Times Square"]) {
    //        NSLog(@"exist");
    //    }
    [self showAlertViewWithTitle:@"exist" andMessage:@"Please check out"];
    
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    NSLog(@"START-->%@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    if (error) {
        NSLog(@"ERROR");
    }
}

#pragma mark - init
- (void)initilizeLocationTracking
{
    _locationManager = [[CLLocationManager alloc] init];
    assert(self.locationManager);
    
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    // start tracking the user's location
    [self.locationManager startUpdatingLocation];
    self.mapView.showsUserLocation = YES;
    
    [self.locationManager startMonitoringForRegion:self.safeRegion];
}

#pragma mark - lazy init

- (CLLocation *)centerLocation
{
    if (!_centerLocation) {
        CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        [geocoder geocodeAddressString:centerLocationString completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *placemark = [placemarks firstObject];
            _centerLocation = [[CLLocation alloc]initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
            NSLog(@"sm-->lat:%f,lon:%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
            [self performSelectorOnMainThread:@selector(placeAnnotation:) withObject:_centerLocation waitUntilDone:YES];
        }];
        
    }
    
    return _centerLocation;
}

- (CLCircularRegion *)safeRegion
{
    if (!_safeRegion) {
        _safeRegion = [[CLCircularRegion alloc]initWithCenter:self.centerLocation.coordinate radius:100.0 identifier:@"Software Merchant"];
//        _safeRegion = [[CLCircularRegion alloc]initWithCenter:CLLocationCoordinate2DMake(40.075522, -75.413383) radius:1000.0 identifier:@"Software Merchant"];
        _safeRegion.notifyOnEntry = YES;
        _safeRegion.notifyOnExit = YES;
    }
    return _safeRegion;
}

#pragma mark -utilies
- (void)showAlertViewWithTitle:(NSString *)title andMessage:(NSString *)msg
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:alertAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)placeAnnotation:(CLLocation *)location
{
    //add annotation
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc]initAnnotationWith:location andTitle:@"SM"];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
    [self.mapView addAnnotation:annotation];
    [self.mapView setRegion:region animated:YES];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
