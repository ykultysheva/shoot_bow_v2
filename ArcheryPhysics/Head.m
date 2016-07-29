//
//  Head.m
//  ArcheryPhysics
//
//  Created by Yana Kultysheva on 2016-07-27.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "Head.h"
#import "GameScene.h"
#import "GameData.h"

@implementation Head

-(instancetype)init {
    self = [super initWithColor:[SKColor orangeColor] size:CGSizeMake(40, 40)];
    if (self) {
    }
    return self;
}

- (void)setUpHead {
    self.position = CGPointMake(0.0, 60.0);
    
            self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
            self.physicsBody.dynamic = YES;
            self.physicsBody.affectedByGravity = NO;
            self.physicsBody.categoryBitMask = headCategory;
            self.physicsBody.contactTestBitMask = projectileCategory;
            self.physicsBody.collisionBitMask = 0;
}

- (void)projectile:(SKSpriteNode *)projectile didCollideWithHead:(SKSpriteNode *)head {
    NSLog(@"Hit Head");
    SKAction *soundAction = [SKAction playSoundFileNamed:@"ping.wav" waitForCompletion:NO];
    [self runAction:soundAction];
    [projectile removeFromParent];
    
    SKSpriteNode *obstacle = (SKSpriteNode*)[self childNodeWithName:@"//SpawnedObstacle"];
    [obstacle removeFromParent];
    
    SKAction *hover = [SKAction sequence:@[
                                           
                                           [SKAction moveByX:15 y:00 duration:0.05],
                                           [SKAction moveByX:-30.0 y:00 duration:0.05],
                                           [SKAction moveByX:30.0 y:00 duration:0.05],
                                           [SKAction moveByX:-15.0 y:00 duration:0.05]]];
    [head runAction: hover];
    
    
}


@end
