//
//  LWSwitchTableViewCell.m
//  RCSwitch-IOS
//
//  Created by Lars Winter on 04.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import "LWSwitchTableViewCell.h"

@implementation LWSwitchTableViewCell
@synthesize model;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (LWSwitchModel*) model {
    return model;
}

-(void) setModel:(LWSwitchModel *)newModel {
    model = newModel;
    if (!model) return;
    [self fillDataFromModel];
}

- (void)fillDataFromModel {
    if (!model) {
        self.labelTitel.text = @"no name";
        self.switchState.on = NO;
    } else {
        self.labelTitel.text = self.model.name;
        self.switchState.on = self.model.isOn;
    }
}

//-(void) updateModel:(LWSwitchModel)

- (IBAction)onSwitchValueChanged:(UISwitch *)sender {
    NSLog(@"CHECKED %d", sender.on);
    self.model.isOn = sender.on;
}

@end
