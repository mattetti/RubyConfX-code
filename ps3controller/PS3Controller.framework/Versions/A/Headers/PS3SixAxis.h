//
//  PS3SixAxis.h
//  PS3SixAxis
//
//  Created by Tobias Wetzel on 04.05.10.
//  Copyright 2010 Outcut. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol PS3SixAxisDelegate <NSObject>
@optional

- (void) onDeviceConnected;
- (void) onDeviceDisconnected;
- (void) onDeviceConnectionError:(NSInteger)error;

- (void) onAxisX:(NSInteger)x Y:(NSInteger)y Z:(NSInteger)z;

- (void) onLeftStick:(NSPoint)axis pressed:(BOOL)isPressed;
- (void) onRightStick:(NSPoint)axis pressed:(BOOL)isPressed;

- (void) onNorthButton:(BOOL)state;
- (void) onEastButton:(BOOL)state;
- (void) onSouthButton:(BOOL)state;
- (void) onWestButton:(BOOL)state;

- (void) onNorthButtonWithPressure:(NSInteger)value;
- (void) onEastButtonWithPressure:(NSInteger)value;
- (void) onSouthButtonWithPressure:(NSInteger)value;
- (void) onWestButtonWithPressure:(NSInteger)value;

- (void) onTriangleButton:(BOOL)state;
- (void) onCircleButton:(BOOL)state;
- (void) onCrossButton:(BOOL)state;
- (void) onSquareButton:(BOOL)state;

- (void) onTriangleButtonWithPressure:(NSInteger)value;
- (void) onCircleButtonWithPressure:(NSInteger)value;
- (void) onCrossButtonWithPressure:(NSInteger)value;
- (void) onSquareButtonWithPressure:(NSInteger)value;

- (void) onL1Button:(BOOL)state;
- (void) onL2Button:(BOOL)state;
- (void) onR1Button:(BOOL)state;
- (void) onR2Button:(BOOL)state;

- (void) onL1ButtonWithPressure:(NSInteger)value;
- (void) onL2ButtonWithPressure:(NSInteger)value;
- (void) onR1ButtonWithPressure:(NSInteger)value;
- (void) onR2ButtonWithPressure:(NSInteger)value;

- (void) onSelectButton:(BOOL)state;
- (void) onStartButton:(BOOL)state;
- (void) onPSButton:(BOOL)state;

@end


@interface PS3SixAxis : NSObject {
@private
	id<PS3SixAxisDelegate> delegate;
	BOOL useBuffered;
}

+ (id) sixAixisController;
+ (id) sixAixisControllerWithDelegate:(id<PS3SixAxisDelegate>)aDelegate;
- (id) initSixAixisControllerWithDelegate:(id<PS3SixAxisDelegate>)aDelegate;

- (void)connect:(BOOL)enableBluetooth;
- (void)disconnect;

- (void)setDelegate:(id<PS3SixAxisDelegate>)aDelegate;
- (id<PS3SixAxisDelegate>)delegate;

- (void)setUseBuffered:(BOOL)doUseBuffered;
- (BOOL)useBuffered;

@end
