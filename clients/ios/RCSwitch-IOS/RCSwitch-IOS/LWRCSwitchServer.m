//
//  LWRCSwitchServer.m
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import "LWRCSwitchServer.h"
#import "LWServiceBrowser.h"
#import "SocketIOPacket.h"

@interface LWRCSwitchServer ()
@property LWServiceBrowser* serviceBrowser;
@property SocketIO* socket;
@end

@implementation LWRCSwitchServer

/***********************************************************/
#pragma mark Public API
/***********************************************************/

+ (id)createAndConnectWithDelegate:(id<LWRCSwitchServerDelegate>)theDelegate {
    LWRCSwitchServer* server = [[LWRCSwitchServer alloc] initWithDelegate:theDelegate];
    [server connect];
    return server;
}

- (id)initWithDelegate:(id<LWRCSwitchServerDelegate>)theDelegate {
    self = [super init];
    
    if (self) {
        self.delegate = theDelegate;
    }
    
    return self;
}

-(void)connect {
    self.serviceBrowser = [[LWServiceBrowser alloc] initWithDelegate:self];
    [self.serviceBrowser startSearchingServiceWithName:@"rcswitch-rpi-server"];
    
}

- (void)sendMessage:(NSString *)message withData:(id)data {
    if (!self.state == LWRCSwitchServerState_Connected) return;
    if (!self.socket.isConnected) return;
    
    [self.socket sendEvent:message withData:data];
}

/***********************************************************/
#pragma mark LWServiceBrowserDelegate
/***********************************************************/

- (void)serviceBrowser:(id)browser browsingStateChangedTo:(BOOL)isSearching {
    self.state = LWRCSwitchServerState_Browsing;
    [self onStateChanged];
}

- (void)serviceBrowser:(id)browser foundHostname:(id)hostname andPort:(int)port forService:(id)serviceId {
    self.connection = [[LWRCSwitchServerConnection alloc] init];
    self.connection.hostName = hostname;
    self.connection.port = port;
    self.connection.serviceName = serviceId;
    
    self.socket = [[SocketIO alloc] initWithDelegate:self];
    [self.socket connectToHost:hostname onPort:port];
}

-(void)serviceBrowser:(id)browser lostService:(id)serviceId {
    self.state = LWRCSwitchServerState_NotConnected;
    self.connection = nil;
    
    [self.socket disconnect];
    self.socket = nil;
    
    [self onStateChanged];
}

/***********************************************************/
#pragma mark SocketIODelegate
/***********************************************************/

- (void)socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected to server");
    
    self.state = LWRCSwitchServerState_Connected;
    [self onStateChanged];
    
    //[socket sendEvent:@"switches_get" withData:@""];
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error
{
    NSLog(@"onError() %@", error);
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    if (!self.delegate) return;
    [self.delegate RCSwitchServer:self didReceivedMessage:packet.name widthData:packet.dataAsJSON[@"args"][0]];
}

/***********************************************************/
#pragma mark Private API
/***********************************************************/

-(void)onStateChanged {
    NSLog(@"LWRCSwitchServer=>state: %d", self.state);
    if (!self.delegate) return;
    
    [self.delegate RCSwitchServer:self stateChanged:self.state];
}

@end
