//
//  Annotations.h
//  ARDemo
//
//  Created by Zan on 7/25/16.
//  Copyright © 2016 Zan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotations : NSObject <MKAnnotation>
{
    
    CLLocationCoordinate2D  coordinate;
    NSString*               title;
    NSString*               subtitle;
}

@property (nonatomic, assign)CLLocationCoordinate2D coordinate;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;

@end
