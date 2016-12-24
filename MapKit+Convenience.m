//
//  MapKit+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 17.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "MapKit+Convenience.h"

@implementation MKMapView (Convenience)

- (void)setRegionDistance:(double)regionDistance animated:(BOOL)animated {
	double latitude = regionDistance;
	if (self.bounds.size.height < self.bounds.size.width)
		latitude *= self.bounds.size.height / self.bounds.size.width;

	double longitude = regionDistance;
	if (self.bounds.size.width < self.bounds.size.height)
		longitude *= self.bounds.size.width / self.bounds.size.height;

	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.userLocation.coordinate, latitude, longitude);
	[self setRegion:region animated:animated];
}

- (void)setRegionDistance:(double)regionDistance {
	[self setRegionDistance:regionDistance animated:NO];
}

- (void)removeAllAnnotations {
	if (self.annotations)
		[self removeAnnotations:self.annotations];
}

@end

@implementation MKDistanceFormatter (Convenience)

static MKDistanceFormatter *_defaultFormatter;

+ (instancetype)defaultFormatter {
	@synchronized (self) {
		if (!_defaultFormatter)
			_defaultFormatter = [self new];
	}

	return _defaultFormatter;
}

@end

@implementation MKShape (Convenience)

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
	self = [self init];

	if (self) {
		self.title = title;
		self.subtitle = subtitle;
	}

	return self;
}

@end

@implementation MKPointAnnotation (Convenience)

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle {
	self = [self initWithTitle:title subtitle:subtitle];

	if (self)
		self.coordinate = coordinate;

	return self;
}

@end
