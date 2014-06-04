//
//  LWServiceBrowser.h
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LWServiceBrowserDelegate <NSObject>

- (void)serviceBrowser:(id)browser
browsingStateChangedTo:(BOOL)isSearching;

- (void)serviceBrowser:(id)browser
         foundHostname:(id)hostname
               andPort:(int)port
            forService:(id)serviceId;

- (void)serviceBrowser:(id)browser
           lostService:(id)serviceId;
@end


@interface LWServiceBrowser : NSObject <NSNetServiceBrowserDelegate,
                                        NSNetServiceDelegate>
@property (assign) id <LWServiceBrowserDelegate> delegate;
@property BOOL searching;

/**
Initializes and sets the delegate
Example usage:
@code
LWServiceBrowser* browser = 
                [[LWServiceBrowser alloc] initWithDelegate: self];
@endcode
@param theDelegate
delegate must be type of LWServiceBrowserDelegate
@return LWServiceBrowser
*/
- (id) initWithDelegate:(id <LWServiceBrowserDelegate>) theDelegate;


- (void) startSearchingServiceWithName:(NSString*)serviceName;

@end
