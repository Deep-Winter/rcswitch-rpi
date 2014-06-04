//
//  LWRCSwitchServer.h
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWServiceBrowser.h"
#import "SocketIO.h"

typedef NS_ENUM(NSInteger, LWRCSwitchServerState) {
    LWRCSwitchServerState_Connected,
    LWRCSwitchServerState_NotConnected,
    LWRCSwitchServerState_Browsing
};

@protocol LWRCSwitchServerDelegate <NSObject>
- (void)RCSwitchServer:(id)theServer stateChanged:(LWRCSwitchServerState) theState;
- (void)RCSwitchServer:(id)theServer didReceivedMessage:(NSString*)message widthData:(id)data;
@end


@interface LWRCSwitchServerConnection : NSObject
@property  NSString* hostName;
@property  NSInteger port;
@property NSString* serviceName;
@end



@interface LWRCSwitchServer : NSObject <LWServiceBrowserDelegate, SocketIODelegate>
@property LWRCSwitchServerState state;
@property LWRCSwitchServerConnection* connection;
@property (assign) id<LWRCSwitchServerDelegate> delegate;

- (id)initWithDelegate:(id<LWRCSwitchServerDelegate>)theDelegate;
- (void)connect;
- (void)sendMessage:(NSString*)message withData:(id) data;

+ (id)createAndConnectWithDelegate:(id<LWRCSwitchServerDelegate>)theDelegate;

@end
