//
//  PHMapView.h
//  pherret
//
//  Created by Ethan Sherbondy on 7/15/12.
//  Copyright (c) 2012 Ethan Sherbondy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;
@protocol MKMapViewDelegate;

@interface PHMapView : UIView <MKMapViewDelegate>

- (void)removeAllPins;
- (void)addPinAtLocation:(NSDictionary *)location;

@property (nonatomic, readonly, strong) MKMapView *mapView;

@end
