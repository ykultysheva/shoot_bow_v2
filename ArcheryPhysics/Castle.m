//
//  Castle.m
//  ArcheryPhysics
//
//  Created by JOSE PILAPIL on 2016-07-28.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "Castle.h"

@implementation Castle

-(instancetype)init {
    self = [super initWithColor:[SKColor grayColor] size:CGSizeMake(70, 20)];
    if (self) {
        _healthPoints = 100;
    }
    return self;
}

@end
