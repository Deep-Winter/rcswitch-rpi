//
//  LWViewController.m
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import "LWViewController.h"


@interface LWViewController ()
@property LWRCSwitchServer *server;
@property UIAlertView* alertView;
@end

@implementation LWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"Loading data\nPlease Wait..."
                                                message:nil
                                               delegate:self
                                      cancelButtonTitle:nil
                                      otherButtonTitles: nil];
     [self.alertView show];
    
    self.server = [LWRCSwitchServer createAndConnectWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)RCSwitchServer:(id)theServer stateChanged:(LWRCSwitchServerState)theState {
    NSLog(@"STATE CHANGED TO %d", theState);
    
    if (theState == LWRCSwitchServerState_Connected) {
        [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
        [self.server sendMessage:@"switches_get" withData:@""];
    } else {
        [self.alertView setTitle:@"Connection lost\nTry to reconnect..."];
        //self.alertView updateConstraint
        [self.alertView show];
    }
}

- (void)RCSwitchServer:(id)theServer didReceivedMessage:(NSString *)message widthData:(id)data {
    NSLog(@"Received: %@", message);
}

@end
