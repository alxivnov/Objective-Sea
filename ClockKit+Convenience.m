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
}

- (void)setRing:(CLKComplicationRingStyle)value {
	cls(CLKComplicationTemplateCircularSmallRingText, self).ringStyle = value;

	cls(CLKComplicationTemplateModularSmallRingText, self).ringStyle = value;

	cls(CLKComplicationTemplateUtilitarianSmallRingText, self).ringStyle = value;
}

- (void)setFill:(float)value {
	cls(CLKComplicationTemplateCircularSmallRingText, self).fillFraction = value;

	cls(CLKComplicationTemplateModularSmallRingText, self).fillFraction = value;

	cls(CLKComplicationTemplateUtilitarianSmallRingText, self).fillFraction = value;
}

- (void)setImage:(CLKImageProvider *)value {
	cls(CLKComplicationTemplateCircularSmallStackImage, self).line1ImageProvider = value;
	cls(CLKComplicationTemplateModularSmallStackImage, self).line1ImageProvider = value;
	cls(CLKComplicationTemplateUtilitarianSmallFlat, self).imageProvider = value;
	cls(CLKComplicationTemplateUtilitarianLargeFlat, self).imageProvider = value;
}

- (void)setText:(NSString *)value shortText:(NSString *)text {
	[self setText:[CLKSimpleTextProvider textProviderWithText:value shortText:text]];
}

- (void)setImage:(UIImage *)value tintColor:(UIColor *)color {
	CLKImageProvider *image = [CLKImageProvider imageProviderWithOnePieceImage:value];
	image.tintColor = color;
	[self setImage:image];
}

+ (CLKComplicationTemplate *)createWithFamily:(CLKComplicationFamily)family member:(CLKComplicationFamilyMember)member {
	switch (family) {
		case CLKComplicationFamilyCircularSmall:
			return member == CLKComplicationFamilyMemberRingImage ? [CLKComplicationTemplateCircularSmallRingImage new]
			: member == CLKComplicationFamilyMemberRingText ? [CLKComplicationTemplateCircularSmallRingText new]
			: member == CLKComplicationFamilyMemberSimpleImage ? [CLKComplicationTemplateCircularSmallSimpleImage new]
			: member == CLKComplicationFamilyMemberSimpleText ? [CLKComplicationTemplateCircularSmallSimpleText new]
			: member == CLKComplicationFamilyMemberStackImage ? [CLKComplicationTemplateCircularSmallStackImage new]
			: member == CLKComplicationFamilyMemberStackText ? [CLKComplicationTemplateCircularSmallStackText new]
			: Nil;
		case CLKComplicationFamilyModularSmall:
			return member == CLKComplicationFamilyMemberRingImage ? [CLKComplicationTemplateModularSmallRingImage new]
			: member == CLKComplicationFamilyMemberRingText ? [CLKComplicationTemplateModularSmallRingText new]
			: member == CLKComplicationFamilyMemberSimpleImage ? [CLKComplicationTemplateModularSmallSimpleImage new]
			: member == CLKComplicationFamilyMemberSimpleText ? [CLKComplicationTemplateModularSmallSimpleText new]
			: member == CLKComplicationFamilyMemberStackImage ? [CLKComplicationTemplateModularSmallStackImage new]
			: member == CLKComplicationFamilyMemberStackText ? [CLKComplicationTemplateModularSmallStackText new]
			: Nil;
		case CLKComplicationFamilyUtilitarianSmall:
			return member == CLKComplicationFamilyMemberRingImage ? [CLKComplicationTemplateUtilitarianSmallRingImage new]
			: member == CLKComplicationFamilyMemberRingText ? [CLKComplicationTemplateUtilitarianSmallRingText new]
			: member == CLKComplicationFamilyMemberSimpleImage ? [CLKComplicationTemplateUtilitarianSmallSquare new]
			: member == CLKComplicationFamilyMemberStackImage ? [CLKComplicationTemplateUtilitarianSmallFlat new]
			: Nil;
		case CLKComplicationFamilyUtilitarianLarge:
			return [CLKComplicationTemplateUtilitarianLargeFlat new];
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
