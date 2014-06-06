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

BOOL _processModelChanges = YES;

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
    [model addObserver:self forKeyPath:@"isOn" options:NSKeyValueObservingOptionNew context:nil];
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
    if (_processModelChanges)
        self.model.isOn = sender.on;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"isOn"]) {
        LWSwitchModel* model = object;
        _processModelChanges = NO;
        [self.switchState setOn:model.isOn animated:YES];
        _processModelChanges = YES;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
