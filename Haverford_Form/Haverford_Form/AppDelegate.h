//
//  AppDelegate.h
//  Haverford_Form
//
//  Created by YangYusheng on 12/21/15.
//  Copyright © 2015 softwaremerchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import <Google/SignIn.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic)CLLocationManager *locationManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

