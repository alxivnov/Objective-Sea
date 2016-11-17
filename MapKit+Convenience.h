//
//  MapKit+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 17.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Convenience)

- (void)setRegionDistance:(double)regionDistance animated:(BOOL)animated;
- (void)setRegionDistance:(double)regionDistance;

@end
