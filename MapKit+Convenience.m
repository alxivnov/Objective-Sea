//
//  MapKit+Convenience.m
//  Crowd Guard
//
//  Created by Alexander Ivanov on 17.11.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "MapKit+Convenience.h"

@implementation MKMapView (Convenience)

- (void)setRegionWithCenter:(CLLocationCoordinate2D)center distance:(CLLocationDistance)distance animated:(BOOL)animated {
	double latitude = distance;
	if (self.bounds.size.height < self.bounds.size.width)
		latitude *= self.bounds.size.height / self.bounds.size.width;

	double longitude = distance;
	if (self.bounds.size.width < self.bounds.size.height)
		longitude *= self.bounds.size.width / self.bounds.size.height;

	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(center, latitude, longitude);
	[self setRegion:region animated:animated];
}

- (void)removeAllAnnotations {
	if (self.annotations)
		[self removeAnnotations:self.annotations];
}

- (void)removeAllOverlays {
	if (self.overlays)
		[self removeOverlays:self.overlays];
}

- (void)removeAllAnnotationsAndOverlays {
	[self removeAllAnnotations];

	[self removeAllOverlays];
}

- (MKAnnotationView *)viewForNullableAnnotation:(id<MKAnnotation>)annotation {
	return annotation ? [self viewForAnnotation:annotation] : Nil;
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

@implementation MKDirectionsRequest (Convenience)

- (instancetype)initWithSource:(MKMapItem *)source destination:(MKMapItem *)destination transportType:(MKDirectionsTransportType)transportType requestsAlternateRoutes:(BOOL)requestsAlternateRoutes {
	self = [self init];

	if (self) {
		self.source = source;
		self.destination = destination;
		self.transportType = transportType;
		self.requestsAlternateRoutes = requestsAlternateRoutes;
	}

	return self;
}

- (instancetype)initWithSourcePlacemark:(MKPlacemark *)source destinationPlacemark:(MKPlacemark *)destination transportType:(MKDirectionsTransportType)transportType requestsAlternateRoutes:(BOOL)requestsAlternateRoutes {
	return [self initWithSource:[[MKMapItem alloc] initWithPlacemark:source] destination:[[MKMapItem alloc] initWithPlacemark:destination] transportType:transportType requestsAlternateRoutes:requestsAlternateRoutes];
}

- (instancetype)initWithSourceCoordinate:(CLLocationCoordinate2D)source destinationCoordinate:(CLLocationCoordinate2D)destination transportType:(MKDirectionsTransportType)transportType requestsAlternateRoutes:(BOOL)requestsAlternateRoutes {
	return [self initWithSourcePlacemark:[[MKPlacemark alloc] initWithCoordinate:source] destinationPlacemark:[[MKPlacemark alloc] initWithCoordinate:destination] transportType:transportType requestsAlternateRoutes:requestsAlternateRoutes];
}

- (MKDirections *)calculateDirectionsWithCompletionHandler:(MKDirectionsHandler)completionHandler {
	MKDirections *directions = [[MKDirections alloc] initWithRequest:self];

	[directions calculateDirectionsWithCompletionHandler:completionHandler];

	return directions;
}

- (MKDirections *)calculateETAWithCompletionHandler:(MKETAHandler)completionHandler {
	MKDirections *directions = [[MKDirections alloc] initWithRequest:self];

	[directions calculateETAWithCompletionHandler:completionHandler];

	return directions;
}

@end

@implementation MKMapSnapshotOptions (Convenience)

- (instancetype)initWithMapRect:(MKMapRect)mapRect {
	self = [self init];

	if (self)
		self.mapRect = mapRect;

	return self;
}

- (instancetype)initWithRegion:(MKCoordinateRegion)region {
	self = [self init];

	if (self)
		self.region = region;

	return self;
}

- (MKMapSnapshotter *)snapshotWithCompletionHandler:(MKMapSnapshotCompletionHandler)completionHandler {
	MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:self];
	[snapshotter startWithCompletionHandler:completionHandler];
	return snapshotter;
}

- (MKMapSnapshotter *)snapshotWithQueue:(dispatch_queue_t)queue completionHandler:(MKMapSnapshotCompletionHandler)completionHandler {
	MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:self];
	[snapshotter startWithQueue:queue completionHandler:completionHandler];
	return snapshotter;
}

@end
