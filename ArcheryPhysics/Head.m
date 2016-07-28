//
//  Head.m
//  ArcheryPhysics
//
//  Created by Yana Kultysheva on 2016-07-27.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "Head.h"
#import "GameScene.h"

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
    [projectile removeFromParent];
    
    SKAction *hover = [SKAction sequence:@[
                                           
                                           [SKAction moveByX:15 y:00 duration:0.05],
                                           [SKAction moveByX:-30.0 y:00 duration:0.05],
                                           [SKAction moveByX:30.0 y:00 duration:0.05],
                                           [SKAction moveByX:-15.0 y:00 duration:0.05]]];
    [head runAction: hover];
    
//    add score
    self.gameScene.score ++;
    SKLabelNode *score = (SKLabelNode*)[self.gameScene childNodeWithName:@"score"];
    score.text = [NSString stringWithFormat:@"Score: %i", self.gameScene.score];
    
}


@end
