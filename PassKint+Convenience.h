//
//  PKMutablePass.h
//  vCard
//
//  Created by Alexander Ivanov on 07.04.2018.
//  Copyright © 2018 Alexander Ivanov. All rights reserved.
//

#import <PassKit/PassKit.h>

#import "NSURLSession+Convenience.h"

@interface PKMutableObject : NSObject

@property (strong, nonatomic, readonly) NSDictionary *dictionary;

@end

@interface PKMutablePassField : PKMutableObject

+ (instancetype)fieldWithKey:(NSString *)key value:(NSString *)value label:(NSString *)label;

// Standard Field Dictionary Keys
// Information about a field.
// These keys are used for all dictionaries that define a field.

// Required. The key must be unique within the scope of the entire pass. For example, “departure-gate.”
@property (strong, nonatomic, readonly) NSString *key;
// Required. Value of the field, for example, 42.
// localizable string, ISO 8601 date as a string, or number
@property (strong, nonatomic, readonly) NSString *value;

// Optional. Attributed value of the field.
// localizable string, ISO 8601 date as a string, or number
// The value may contain HTML markup for links. Only the <a> tag and its href attribute are supported. For example, the following is key-value pair specifies a link with the text “Edit my profile”:
// "attributedValue": "<a href='http://example.com/customers/123'>Edit my profile</a>"
// This key’s value overrides the text specified by the value key.
// Available in iOS 7.0.
@property (strong, nonatomic) NSString *localizedAttributedValue;
// Optional. Format string for the alert text that is displayed when the pass is updated. The format string must contain the escape %@, which is replaced with the field’s new value. For example, “Gate changed to %@.”
// If you don’t specify a change message, the user isn’t notified when the field changes.
@property (strong, nonatomic) NSString *localizedChangeMessage;
// Optional. Data detectors that are applied to the field’s value. Valid values are:
// PKDataDetectorTypePhoneNumber
// PKDataDetectorTypeLink
// PKDataDetectorTypeAddress
// PKDataDetectorTypeCalendarEvent
// The default value is all data detectors. Provide an empty array to use no data detectors.
// Data detectors are applied only to back fields.
@property (strong, nonatomic) NSArray<NSString *> *dataDetectorTypes;
// Optional. Label text for the field.
@property (strong, nonatomic) NSString *localizedLabel;
// Optional. Alignment for the field’s contents. Must be one of the following values:
// PKTextAlignmentLeft
// PKTextAlignmentCenter
// PKTextAlignmentRight
// PKTextAlignmentNatural
// The default value is natural alignment, which aligns the text appropriately based on its script direction.
// This key is not allowed for primary fields or back fields.
@property (strong, nonatomic) NSString *textAlignment;


// Date Style Keys
// Information about how a date should be displayed in a field.
// If any of these keys is present, the value of the field is treated as a date. Either specify both a date style and a time style, or neither.

// Style of date to display. Must be one of the styles listed in Table 4-1.
@property (strong, nonatomic) NSString *dateStyle;
// Optional. Always display the time and date in the given time zone, not in the user’s current time zone. The default value is false.
// The format for a date and time always requires a time zone, even if it will be ignored. For backward compatibility with iOS 6, provide an appropriate time zone, so that the information is displayed meaningfully even without ignoring time zones.
// This key does not affect how relevance is calculated.
// Available in iOS 7.0.
@property (assign, nonatomic) BOOL ignoresTimeZone;
// Optional. If true, the label’s value is displayed as a relative date; otherwise, it is displayed as an absolute date. The default value is false.
// This key does not affect how relevance is calculated.
@property (assign, nonatomic) BOOL isRelative;
// Style of time to display. Must be one of the styles listed in Table 4-1.
@property (strong, nonatomic) NSString *timeStyle;

// Table 4-1  Date and time styles
// Date style			Corresponding formatter style
// PKDateStyleNone		NSDateFormatterNoStyle
// PKDateStyleShort		NSDateFormatterShortStyle
// PKDateStyleMedium	NSDateFormatterMediumStyle
// PKDateStyleLong		NSDateFormatterLongStyle
// PKDateStyleFull		NSDateFormatterFullStyle


// Number Style Keys
// Information about how a number should be displayed in a field.
// These keys are optional if the field’s value is a number; otherwise, they are not allowed. Only one of these keys is allowed per field.

// ISO 4217 currency code for the field’s value.
@property (strong, nonatomic) NSString *currencyCode;
// Style of number to display. Must be one of the following values:
// PKNumberStyleDecimal
// PKNumberStylePercent
// PKNumberStyleScientific
// PKNumberStyleSpellOut
// Number styles have the same meaning as the Cocoa number formatter styles with corresponding names. For more information, see NSNumberFormatterStyle.
@property (strong, nonatomic) NSString *numberStyle;

@end

@interface PKMutablePassStyle : PKMutableObject

+ (instancetype)boardingPass;//	Information specific to a boarding pass.
+ (instancetype)coupon;//		Information specific to a coupon.
+ (instancetype)eventTicket;//	Information specific to an event ticket.
+ (instancetype)generic;//		Information specific to a generic pass.
+ (instancetype)storeCard;//	Information specific to a store card.

@property (strong, nonatomic, readonly) NSString *key;


// Pass Structure Dictionary Keys
// Keys that define the structure of the pass.
// These keys are used for all pass styles and partition the fields into the various parts of the pass.

// Optional. Additional fields to be displayed on the front of the pass.
@property (strong, nonatomic, readonly) NSMutableArray<PKMutablePassField *> *auxiliaryFields;
// Optional. Fields to be on the back of the pass.
@property (strong, nonatomic, readonly) NSMutableArray<PKMutablePassField *> *backFields;
// Optional. Fields to be displayed in the header on the front of the pass.
// Use header fields sparingly; unlike all other fields, they remain visible when a stack of passes are displayed.
@property (strong, nonatomic, readonly) NSMutableArray<PKMutablePassField *> *headerFields;
// Optional. Fields to be displayed prominently on the front of the pass.
@property (strong, nonatomic, readonly) NSMutableArray<PKMutablePassField *> *primaryFields;
// Optional. Fields to be displayed on the front of the pass.
@property (strong, nonatomic, readonly) NSMutableArray<PKMutablePassField *> *secondaryFields;
// Required for boarding passes; otherwise not allowed. Type of transit. Must be one of the following values: PKTransitTypeAir, PKTransitTypeBoat, PKTransitTypeBus, PKTransitTypeGeneric,PKTransitTypeTrain.
@property (strong, nonatomic) NSString *transitType;

@end

@interface PKMutablePass : PKMutableObject

// Standard Keys
// Information that is required for all passes.

// Required. Brief description of the pass, used by the iOS accessibility technologies.
// Don’t try to include all of the data on the pass in its description, just include enough detail to distinguish passes of the same type.
@property (strong, nonatomic) NSString *localizedDescription;
// Required. Version of the file format. The value must be 1.
@property (assign, nonatomic, readonly) NSUInteger formatVersion;
// Required. Display name of the organization that originated and signed the pass.
@property (strong, nonatomic) NSString *localizedOrganizationName;
// Required. Pass type identifier, as issued by Apple. The value must correspond with your signing certificate.
@property (strong, nonatomic) NSString *passTypeIdentifier;
// Required. Serial number that uniquely identifies the pass. No two passes with the same pass type identifier may have the same serial number.
@property (strong, nonatomic) NSString *serialNumber;
// Required. Team identifier of the organization that originated and signed the pass, as issued by Apple.
@property (strong, nonatomic) NSString *teamIdentifier;


// Style Keys
// Keys that specify the pass style
// Provide exactly one key—the key that corresponds with the pass’s type. The value of this key is a dictionary containing the keys in Pass Structure Dictionary Keys.
@property (strong, nonatomic) PKMutablePassStyle *style;

@property (strong, nonatomic, readonly) NSData *data;

@end
