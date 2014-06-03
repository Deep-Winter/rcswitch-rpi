//
//  LWServiceBrowser.h
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LWServiceBrowserDelegate.h"

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
