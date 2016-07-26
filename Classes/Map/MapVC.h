//
//  MapVC.h
//  ARDemo
//
//  Created by Zan on 7/22/16.
//  Copyright © 2016 Zan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotations.h"
#import "ARKit.h"
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface MapVC : UIViewController <MKMapViewDelegate, ARViewDelegate, CLLocationManagerDelegate> {
    MKMapView *mapView;
    
    Annotations *myAnnotation;
    NSMutableArray *annotations;
    
    NSArray *points;
    ARKitEngine *engine;
    
    NSInteger selectedIndex;
    
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}

@end
