//
//  PHMapView.m
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import "PHMapView.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PHAnnotation : NSObject <MKAnnotation>
@end

@implementation PHAnnotation

@synthesize coordinate = _coordinate, title = _title, subtitle = _subtitle;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle
{
    if (self = [super init]){
        _coordinate = coordinate;
        _title = title;
        _subtitle = subtitle;
    }
    return self;
}

@end

@implementation PHMapView

@synthesize mapView = _mapView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        _mapView = [[MKMapView alloc] initWithFrame:self.frame];
        _mapView.showsUserLocation = YES;
        [_mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
        [self addSubview:_mapView];
    }
    return self;
}

- (void)removeAllPins {
    [_mapView removeAnnotations:[_mapView annotations]];
}

- (void)addPinAtLocation:(NSDictionary *)location {
    // should actually do the proper thing with coords
    CLLocationCoordinate2D coordinate = {[[location objectForKey:@"latitude"] doubleValue],
                                         [[location objectForKey:@"longitude"] doubleValue]};
    PHAnnotation *annotation = [[PHAnnotation alloc] initWithCoordinate:coordinate title:@"Photo 1" subtitle:@"by Ethan"];
    [_mapView addAnnotation:annotation];
}

- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views {
    for(MKAnnotationView *annotationView in views) {
        if(annotationView.annotation == mv.userLocation) {
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            span.latitudeDelta=0.1;
            span.longitudeDelta=0.1;
            
            CLLocationCoordinate2D location=mv.userLocation.coordinate;
            
            region.span=span;
            region.center=location;
            
            [mv setRegion:region animated:TRUE];
            [mv regionThatFits:region];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
