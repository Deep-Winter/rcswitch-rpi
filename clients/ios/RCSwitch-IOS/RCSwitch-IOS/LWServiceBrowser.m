//
//  LWServiceBrowser.m
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import "LWServiceBrowser.h"

@interface LWServiceBrowser ()
@property NSNetServiceBrowser* serviceBrowser;
@property NSString* serviceName;
@property NSNetService* service;
@end

@implementation LWServiceBrowser

/***********************************************************/
#pragma mark Initialization
/***********************************************************/

- (id)init {
    self = [super init];
    if (self) {
        [self initBrowser];
    }
    return self;
}

- (void)initBrowser {
    self.searching = NO;
    self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
    self.serviceBrowser.delegate = self;
}

/***********************************************************/
#pragma mark public API
/***********************************************************/

-(id)initWithDelegate:(id<LWServiceBrowserDelegate>)theDelegate {
    self = [super init];
    
    if (self) {
        self.delegate = theDelegate;
        [self initBrowser];
    }
    
    return self;
}

- (void)startSearchingServiceWithName:(NSString*)serviceName {
    if (!self.delegate) {
        NSLog(@"delegate not set");
        return;
    }
    
    self.serviceName = serviceName;
    
    [_serviceBrowser searchForServicesOfType:@"_http._tcp" inDomain:@""];
}

/***********************************************************/
#pragma mark NSNetServiceBrowserDelegate
/***********************************************************/
-(void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    self.searching = YES;
    [self onStateChanged];
}

-(void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)aNetServiceBrowser {
    self.searching = NO;
    [self onStateChanged];
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
                didFindService:(NSNetService *)aNetService
                moreComing:(BOOL)moreComing {
    
    if (![aNetService.name isEqualToString: self.serviceName]) return;
    
    self.service = aNetService;
    self.service.delegate = self;
    [self.service resolveWithTimeout:10];
    //[self.serviceBrowser stop];
}

-(void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
        didRemoveService:(NSNetService *)aNetService
        moreComing:(BOOL)moreComing {
    
    if (![aNetService.name isEqualToString: self.serviceName]) return;
    self.service = nil;
    
    if (!self.delegate) return;
    [self.delegate serviceBrowser:self lostService:self.serviceName];
}


/***********************************************************/
#pragma mark NSNetServiceDelegate
/***********************************************************/

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    
    if (!self.delegate) return;
    
    [self.delegate serviceBrowser:self foundHostname:sender.hostName
                        andPort:sender.port
                        forService:self.serviceName];
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    NSLog(@"FAILED");
}


/***********************************************************/
#pragma mark private API
/***********************************************************/
-(void)onStateChanged {
    if(!self.delegate) return;
    [self.delegate serviceBrowser:self browsingStateChangedTo:self.searching];
}

@end


