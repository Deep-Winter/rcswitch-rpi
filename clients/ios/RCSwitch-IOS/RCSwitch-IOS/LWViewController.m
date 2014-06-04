//
//  LWViewController.m
//  RCSwitch-IOS
//
//  Created by Lars Winter on 03.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import "LWViewController.h"
#import "LWSwitchTableViewCell.h"
#import "LWSwitchModel.h"

@interface LWViewController ()
@property LWRCSwitchServer *server;
@property UIAlertView* alertView;
@property NSMutableArray* models;
@end

@implementation LWViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.models = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    if ([message isEqualToString:@"switches_response"]) {
        [self.models removeAllObjects];
        NSDictionary* modelData;
        for(modelData in (NSArray* )data) {
            LWSwitchModel* model = [LWSwitchModel createModelWithData:modelData];
            [model addObserver:self forKeyPath:@"isOn" options:NSKeyValueObservingOptionNew context:nil];
            [self.models addObject:model];
        }
    
        [self.tableView reloadData];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isOn"]) {
        LWSwitchModel* model = object;
        [self.server sendMessage:@"switch_changed" withData:[model toDictionary]];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LWSwitchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableViewCell" forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    return cell;

}

@end
