//
//  UITableViewCell+Convenience.h
//  Crowd Guard
//
//  Created by Alexander Ivanov on 23.05.17.
//  Copyright © 2017 Alexander Ivanov. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Dispatch+Convenience.h"
#import "Accelerate+Convenience.h"
#import "NSObject+Convenience.h"

@interface UITableViewCell (Convenience)

- (void)removeSeparators;

- (UITableView *)tableView;

- (void)setAccessoryView:(UIView *)accessoryView insets:(UIEdgeInsets)insets;

@property (strong, nonatomic) NSArray<__kindof UIView *> *accessoryViews;

@property (strong, nonatomic, readonly) UILabel *accessoryLabel;
@property (strong, nonatomic, readonly) UISwitch *accessorySwitch;
@property (strong, nonatomic, readonly) UIStepper *accessoryStepper;
@property (strong, nonatomic, readonly) UISegmentedControl *accessorySegment;
@property (strong, nonatomic, readonly) UIButton *accessoryButton;

@end

@interface UISwitchTableViewCell : UITableViewCell

@property (strong, nonatomic, readonly) UISwitch *switchView;

@end

#if __has_include("UserNotifications+Convenience.h") && __has_include(<UserNotifications/UserNotifications.h>)

#import "UserNotifications+Convenience.h"

@interface UNTableViewCell : UISwitchTableViewCell

@property (assign, nonatomic) UNAuthorizationOptions authorizationOptions;

@end

#endif

#if __has_include("CoreLocation+Convenience.h")

#import "CoreLocation+Convenience.h"

@interface CLTableViewCell : UISwitchTableViewCell

@property (assign, nonatomic) BOOL requestAlwaysAuthorization;

@end

#endif

#if __has_include("AVAudioRecorder+Convenience.h")

#import "AVAudioRecorder+Convenience.h"

@interface AVFTableViewCell : UISwitchTableViewCell

@end

#endif
