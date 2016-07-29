//
//  Monster.m
//  ArcheryPhysics
//
//  Created by JOSE PILAPIL on 2016-07-28.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "Monster.h"
#import "GameScene.h"

@implementation Monster


-(instancetype)init{
    self = [super initWithColor:[SKColor purpleColor] size:CGSizeMake(40, 40)];
    if (self) {
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = monsterCategory;
        self.physicsBody.contactTestBitMask = projectileCategory;
        self.physicsBody.collisionBitMask = 0;
    }
    return self;
}


@end
