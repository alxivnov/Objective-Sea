//
//  ClockKit+Convenience.m
//  Sleep Diary
//
//  Created by Alexander Ivanov on 12.10.16.
//  Copyright © 2016 Alexander Ivanov. All rights reserved.
//

#import "ClockKit+Convenience.h"

@implementation CLKComplicationTemplate (Convenience)

- (void)setText:(CLKTextProvider *)value {
	cls(CLKComplicationTemplateCircularSmallRingText, self).textProvider = value;
	cls(CLKComplicationTemplateCircularSmallStackImage, self).line2TextProvider = value;

	cls(CLKComplicationTemplateModularSmallRingText, self).textProvider = value;
	cls(CLKComplicationTemplateModularSmallStackImage, self).line2TextProvider = value;

	cls(CLKComplicationTemplateUtilitarianSmallRingText, self).textProvider = value;
	cls(CLKComplicationTemplateUtilitarianSmallFlat, self).textProvider = value;
	cls(CLKComplicationTemplateUtilitarianLargeFlat, self).textProvider = value;
	
	cls(CLKComplicationTemplateGraphicCircularClosedGaugeText, self).centerTextProvider = value;
	cls(CLKComplicationTemplateGraphicCircularStackImage, self).line2TextProvider = value;
	cls(CLKComplicationTemplateGraphicCircularStackText, self).line2TextProvider = value;
}

- (void)setRing:(CLKComplicationRingStyle)value {
	cls(CLKComplicationTemplateCircularSmallRingText, self).ringStyle = value;

	cls(CLKComplicationTemplateModularSmallRingText, self).ringStyle = value;

	cls(CLKComplicationTemplateUtilitarianSmallRingText, self).ringStyle = value;
}

- (void)setFill:(float)value tintColor:(UIColor *)color {
	cls(CLKComplicationTemplateCircularSmallRingText, self).fillFraction = value;

	cls(CLKComplicationTemplateModularSmallRingText, self).fillFraction = value;

	cls(CLKComplicationTemplateUtilitarianSmallRingText, self).fillFraction = value;
	
	CLKSimpleGaugeProvider *gauge = [CLKSimpleGaugeProvider gaugeProviderWithStyle:CLKGaugeProviderStyleRing gaugeColor:color ?: [UIColor whiteColor] fillFraction:fminf(value, 1.0)];
	cls(CLKComplicationTemplateGraphicCircularClosedGaugeImage, self).gaugeProvider = gauge;
	cls(CLKComplicationTemplateGraphicCircularClosedGaugeText, self).gaugeProvider = gauge;
}

- (void)setFill:(float)value {
	[self setFill:value tintColor:[UIColor whiteColor]];
}

- (void)setImage:(UIImage *)value tintColor:(UIColor *)color {
	CLKImageProvider *image = [CLKImageProvider imageProviderWithOnePieceImage:value];
	image.tintColor = color;

	cls(CLKComplicationTemplateCircularSmallStackImage, self).line1ImageProvider = image;
	cls(CLKComplicationTemplateModularSmallStackImage, self).line1ImageProvider = image;
	cls(CLKComplicationTemplateUtilitarianSmallFlat, self).imageProvider = image;
	cls(CLKComplicationTemplateUtilitarianLargeFlat, self).imageProvider = image;
	
	CLKFullColorImageProvider *fcImage = [CLKFullColorImageProvider providerWithFullColorImage:value tintedImageProvider:image];
	cls(CLKComplicationTemplateGraphicCircularImage, self).imageProvider = fcImage;
	cls(CLKComplicationTemplateGraphicCircularStackImage, self).line1ImageProvider = fcImage;
	cls(CLKComplicationTemplateGraphicCircularClosedGaugeImage, self).imageProvider = fcImage;
}

- (void)setImage:(UIImage *)value {
	[self setImage:value tintColor:Nil];
}

- (void)setText:(NSString *)value shortText:(NSString *)text {
	[self setText:[CLKSimpleTextProvider textProviderWithText:value shortText:text]];
}

+ (CLKComplicationTemplate *)createWithFamily:(CLKComplicationFamily)family member:(CLKComplicationFamilyMember)member {
	switch (family) {
		case CLKComplicationFamilyModularSmall:
			return member == CLKComplicationFamilyMemberRingImage ? [CLKComplicationTemplateModularSmallRingImage new]
			: member == CLKComplicationFamilyMemberRingText ? [CLKComplicationTemplateModularSmallRingText new]
			: member == CLKComplicationFamilyMemberSimpleImage ? [CLKComplicationTemplateModularSmallSimpleImage new]
			: member == CLKComplicationFamilyMemberSimpleText ? [CLKComplicationTemplateModularSmallSimpleText new]
			: member == CLKComplicationFamilyMemberStackImage ? [CLKComplicationTemplateModularSmallStackImage new]
			: member == CLKComplicationFamilyMemberStackText ? [CLKComplicationTemplateModularSmallStackText new]
			: Nil;
		case CLKComplicationFamilyModularLarge:
			return Nil;
		case CLKComplicationFamilyUtilitarianSmall:
			return member == CLKComplicationFamilyMemberRingImage ? [CLKComplicationTemplateUtilitarianSmallRingImage new]
			: member == CLKComplicationFamilyMemberRingText ? [CLKComplicationTemplateUtilitarianSmallRingText new]
			: member == CLKComplicationFamilyMemberSimpleImage ? [CLKComplicationTemplateUtilitarianSmallSquare new]
			: member == CLKComplicationFamilyMemberStackImage ? [CLKComplicationTemplateUtilitarianSmallFlat new]
			: Nil;
		case CLKComplicationFamilyUtilitarianSmallFlat:	// 3.0
			return Nil;
		case CLKComplicationFamilyUtilitarianLarge:
			return [CLKComplicationTemplateUtilitarianLargeFlat new];
		case CLKComplicationFamilyCircularSmall:
			return member == CLKComplicationFamilyMemberRingImage ? [CLKComplicationTemplateCircularSmallRingImage new]
			: member == CLKComplicationFamilyMemberRingText ? [CLKComplicationTemplateCircularSmallRingText new]
			: member == CLKComplicationFamilyMemberSimpleImage ? [CLKComplicationTemplateCircularSmallSimpleImage new]
			: member == CLKComplicationFamilyMemberSimpleText ? [CLKComplicationTemplateCircularSmallSimpleText new]
			: member == CLKComplicationFamilyMemberStackImage ? [CLKComplicationTemplateCircularSmallStackImage new]
			: member == CLKComplicationFamilyMemberStackText ? [CLKComplicationTemplateCircularSmallStackText new]
			: Nil;
		case CLKComplicationFamilyExtraLarge:			// 3.0
			return Nil;
			// 5.0
		case CLKComplicationFamilyGraphicCorner:
			return Nil;
		case CLKComplicationFamilyGraphicBezel:
			return Nil;
		case CLKComplicationFamilyGraphicCircular:
			return member == CLKComplicationFamilyMemberRingImage ? [CLKComplicationTemplateGraphicCircularClosedGaugeImage new]	// gauge + image
			: member == CLKComplicationFamilyMemberRingText ? [CLKComplicationTemplateGraphicCircularClosedGaugeText new]		// gauge + text
			: member == CLKComplicationFamilyMemberSimpleImage ? [CLKComplicationTemplateGraphicCircularImage new]				// image
			: member == CLKComplicationFamilyMemberStackImage ? [CLKComplicationTemplateGraphicCircularStackImage new]			// image + text
			: member == CLKComplicationFamilyMemberStackText ? [CLKComplicationTemplateGraphicCircularStackText new]			// text + text
			: Nil;
		case CLKComplicationFamilyGraphicRectangular:
			return Nil;
		default:
			return Nil;
	}
}

@end

@implementation CLKComplicationServer (Convenience)

- (void)extendTimeline:(CLKComplication *)complication {
	if (complication)
		[self extendTimelineForComplication:complication];
	else
		for (CLKComplication *activeComplication in self.activeComplications)
			[self extendTimelineForComplication:activeComplication];
}

- (void)reloadTimeline:(CLKComplication *)complication {
	if (complication)
		[self reloadTimelineForComplication:complication];
	else
		for (CLKComplication *activeComplication in self.activeComplications)
			[self reloadTimelineForComplication:activeComplication];
}

@end
