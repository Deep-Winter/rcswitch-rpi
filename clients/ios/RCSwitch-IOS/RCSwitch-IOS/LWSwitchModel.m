//
//  LWSwitchModel.m
//  RCSwitch-IOS
//
//  Created by Lars Winter on 04.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import "LWSwitchModel.h"

@implementation LWSwitchModel

+ (LWSwitchModel *)createModelWithData:(NSDictionary *)serverData {
    LWSwitchModel* model = [[LWSwitchModel alloc] init];
    model.identifier = [NSString stringWithFormat:@"%@", serverData[@"id"]];
    model.name = [NSString stringWithFormat:@"%@", serverData[@"name"]];
    model.description = [NSString stringWithFormat:@"%@", serverData[@"description"]];
    model.isOn = [[NSString stringWithFormat:@"%@", serverData[@"status"]] boolValue];
    return model;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.identifier forKey:@"id"];
    [dic setObject:self.name forKey:@"name"];
    [dic setObject:self.description forKey:@"description"];
    [dic setObject:[NSNumber numberWithBool:self.isOn]  forKey:@"status"];
    return dic;
}

@end
