//
//  LWRCSwitchServerDelegate.h
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LWRCSwitchServerState) {
    LWRCSwitchServerState_Connected,
    LWRCSwitchServerState_NotConnected,
    LWRCSwitchServerState_Browsing
};

@protocol LWRCSwitchServerDelegate <NSObject>

- (void)RCSwitchServer:(id)theServer stateChanged:(LWRCSwitchServerState) theState;
- (void)RCSwitchServer:(id)theServer didReceivedMessage:(NSString*)message widthData:(id)data;

@end


