//
//  MapVC.m
//  ARDemo
//
//  Created by Zan on 7/22/16.
//  Copyright © 2016 Zan. All rights reserved.
//

#import "MapVC.h"
#import <CoreLocation/CoreLocation.h>

@interface MapVC () 

@end

@implementation MapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
    
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Camera" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setBackgroundColor: UIColor.whiteColor];
    button.frame = CGRectMake(mapView.frame.size.width-100, mapView.frame.size.height-60, 80.0, 40.0);
    [mapView addSubview:button];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSMutableArray *arrayLatitude = [[NSMutableArray alloc] init];
    NSMutableArray *arrayLongitude = [[NSMutableArray alloc] init];
    
    // Mocked data
    
    selectedIndex = -1;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:46.05202143 longitude:14.51028943];
    [arrayLatitude addObject:[NSNumber numberWithDouble: 46.05202143]];
    [arrayLongitude addObject:[NSNumber numberWithDouble: 14.51028943]];
    ARGeoCoordinate *db = [ARGeoCoordinate coordinateWithLocation:location];
    db.dataObject = @"Dragon bridge";
    
    location  = [[CLLocation alloc] initWithLatitude:46.04900577 longitude:14.50840116];
    [arrayLatitude addObject:[NSNumber numberWithDouble: 46.04900577]];
    [arrayLongitude addObject:[NSNumber numberWithDouble: 14.50840116]];
    ARGeoCoordinate *cof = [ARGeoCoordinate coordinateWithLocation:location];
    cof.dataObject = @"Castle of Ljubljana";
    
    location  = [[CLLocation alloc] initWithLatitude:46.05023439 longitude:14.50380921];
    [arrayLatitude addObject:[NSNumber numberWithDouble: 46.05023439]];
    [arrayLongitude addObject:[NSNumber numberWithDouble: 14.50380921]];
    ARGeoCoordinate *pz = [ARGeoCoordinate coordinateWithLocation:location];
    pz.dataObject = @"Park Zvezda";
    
    location  = [[CLLocation alloc] initWithLatitude:46.0494451 longitude:14.50421691];
    [arrayLatitude addObject:[NSNumber numberWithDouble: 46.0494451]];
    [arrayLongitude addObject:[NSNumber numberWithDouble: 14.50421691]];
    ARGeoCoordinate *uof = [ARGeoCoordinate coordinateWithLocation:location];
    uof.dataObject = @"Uni of Ljubljana";
    
    location  = [[CLLocation alloc] initWithLatitude:46.06596577 longitude:14.54813004];
    [arrayLatitude addObject:[NSNumber numberWithDouble: 46.06596577]];
    [arrayLongitude addObject:[NSNumber numberWithDouble: 14.54813004]];
    ARGeoCoordinate *btc = [ARGeoCoordinate coordinateWithLocation:location];
    btc.dataObject = @"BTC";
    
    location  = [[CLLocation alloc] initWithLatitude:46.05165472 longitude:14.51145083];
    [arrayLatitude addObject:[NSNumber numberWithDouble: 46.05165472]];
    [arrayLongitude addObject:[NSNumber numberWithDouble: 14.51145083]];
    ARGeoCoordinate *kamino = [ARGeoCoordinate coordinateWithLocation:location];
    kamino.dataObject = @"Kamino";
    
    points = @[db , cof, pz, uof, btc, kamino];
    
    annotations = [[NSMutableArray alloc] init];
    for (int i=0; i<[arrayLatitude count]; i++) {
        CLLocationCoordinate2D coordinate;
        
        coordinate.latitude  = [[arrayLatitude objectAtIndex:i] floatValue];
        coordinate.longitude = [[arrayLongitude objectAtIndex:i] floatValue];
        
        myAnnotation = [[Annotations alloc] init];
        myAnnotation.coordinate = coordinate;
        [mapView addAnnotation:myAnnotation];
        [annotations addObject:myAnnotation];
        
    }
    
    NSLog(@"%lu",(unsigned long)[annotations count]);
    
    MKMapRect flyTo = MKMapRectNull;
    for (id <MKAnnotation> annotation in annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo))
        {
            flyTo = pointRect;
        }
        else
        {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    mapView.visibleMapRect = flyTo;
    
}

//MARK: button actions

- (void)buttonPressed:(UIButton *)sender{
    ARKitConfig *config = [ARKitConfig defaultConfigFor:self];
    
    CGSize s = [UIScreen mainScreen].bounds.size;
    config.radarPoint = CGPointMake(s.height - 50, s.width - 50);
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeBtn sizeToFit];
    [closeBtn addTarget:self action:@selector(closeAr) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.center = CGPointMake(50, 50);
    
    engine = [[ARKitEngine alloc] initWithConfig:config];
    [engine addCoordinates:points];
    [engine addExtraView:closeBtn];
    [engine startListening];
}

- (void) closeAr {
    [engine hide];
}

//MARK: mapView delegate

- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.003;
    span.longitudeDelta = 0.003;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
    MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
    pinView.animatesDrop   = NO;
    pinView.canShowCallout = YES;
    pinView.pinColor = MKPinAnnotationColorRed;
    
    UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightButton setTitle:nil forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(pinPressed) forControlEvents:UIControlEventTouchUpInside];
    pinView.rightCalloutAccessoryView = rightButton;
    
    return pinView;
}

- (void)pinPressed {
    //Action when pin is pressed
    
    
}

//MARK - ARViewDelegate protocol Methods

- (ARObjectView *)viewForCoordinate:(ARGeoCoordinate *)coordinate floorLooking:(BOOL)floorLooking {
    NSString *text = (NSString *)coordinate.dataObject;
    NSString *text2 = [NSString stringWithFormat:@"%d", (int)[coordinate.geoLocation distanceFromLocation:currentLocation]];
    
    ARObjectView *view = nil;
    
    if (floorLooking) {
        UIImage *arrowImg = [UIImage imageNamed:@"arrow.png"];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:arrowImg];
        view = [[ARObjectView alloc] initWithFrame:arrowView.bounds];
        [view addSubview:arrowView];
        view.displayed = NO;
    } else {
        UIImageView *boxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"box.png"]];
        boxView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        UILabel *locationNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 16, boxView.frame.size.width - 8, 20)];
        locationNameLabel.adjustsFontSizeToFitWidth = YES;
        locationNameLabel.backgroundColor = [UIColor clearColor];
        locationNameLabel.textColor = [UIColor whiteColor];
        locationNameLabel.textAlignment = NSTextAlignmentCenter;
        locationNameLabel.text = text;
        locationNameLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        UILabel *distanceLabel =[[UILabel alloc] initWithFrame:CGRectMake(4, 50, boxView.frame.size.width - 8, 20)];
        distanceLabel.adjustsFontSizeToFitWidth = YES;
        distanceLabel.backgroundColor = [UIColor clearColor];
        distanceLabel.textColor = [UIColor whiteColor];
        distanceLabel.textAlignment = NSTextAlignmentCenter;
        distanceLabel.text = text2;
        distanceLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        
        view = [[ARObjectView alloc] initWithFrame:boxView.frame];
        [view addSubview:boxView];
        [view addSubview:locationNameLabel];
        [view addSubview:distanceLabel];
    }
    
    [view sizeToFit];
    return view;
}

- (void) itemTouchedWithIndex:(NSInteger)index {
    selectedIndex = index;
}

- (void) didChangeLooking:(BOOL)floorLooking {
    if (floorLooking) {
        if (selectedIndex != -1) {
            ARObjectView *floorView = [engine floorViewWithIndex:selectedIndex];
            floorView.displayed = YES;
        }
    } else {
        if (selectedIndex != -1) {
            ARObjectView *floorView = [engine floorViewWithIndex:selectedIndex];
            floorView.displayed = NO;
            selectedIndex = -1;
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                        message:@"There was an error retrieving your location"
                                                        delegate:nil cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
}

@end
