//
//  LWSwitchTableViewCell.h
//  RCSwitch-IOS
//
//  Created by Lars Winter on 04.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWSwitchModel.h"

@interface LWSwitchTableViewCell : UITableViewCell
@property LWSwitchModel* model;
@property (weak, nonatomic) IBOutlet UILabel *labelTitel;
@property (weak, nonatomic) IBOutlet UISwitch *switchState;

- (IBAction)onSwitchValueChanged:(UISwitch *)sender;

@end
