//
//  LWSwitchModel.h
//  RCSwitch-IOS
//
//  Created by Lars Winter on 04.06.14.
//  Copyright (c) 2014 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LWSwitchModel : NSObject
@property NSString* identifier;
@property NSString* name;
@property NSString* description;
@property BOOL isOn;

+ (LWSwitchModel* )createModelWithData:(NSDictionary*)serverData;
- (NSMutableDictionary*) toDictionary;

@end
