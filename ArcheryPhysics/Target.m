//
//  Target.m
//  ArcheryPhysics
//
//  Created by Yana Kultysheva on 2016-07-27.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "Target.h"
#import "GameScene.h"
#import "GameData.h"

@implementation Target


-(instancetype)init {
    self = [super initWithColor:[SKColor redColor] size:CGSizeMake(40, 80)];
    if (self) {
    }
    return self;
}

- (void)setUpTarget {
    
    self.position = CGPointMake((self.sceneFrame.size.width-self.size.width/2), self.sceneFrame.size.height/2);
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = targetCategory;
    self.physicsBody.contactTestBitMask = projectileCategory;
    self.physicsBody.collisionBitMask = 0;

}


-(void)startUpDownTarget {
    
    //  set  up and down movements
    
    int minYTarget = (self.size.height / 2) + 20;
//    int maxYTarget = (self.sceneFrame.size.height - self.size.height / 2) - head.size.height;
      int maxYTarget = (self.sceneFrame.size.height - self.size.height / 2) - 40;
  
    int durationTarget = 4.0;
    SKAction * actionMoveUpTarget = [SKAction moveTo:CGPointMake((self.sceneFrame.size.width-self.size.width/2), maxYTarget) duration:durationTarget];
    
    SKAction * actionMoveDownTarget = [SKAction moveTo:CGPointMake((self.sceneFrame.size.width-self.size.width/2), minYTarget) duration:durationTarget];
    SKAction *updownTarget = [SKAction sequence:@[actionMoveUpTarget, actionMoveDownTarget]];
    SKAction *updownForeverTarget = [SKAction repeatActionForever:updownTarget];
    [self runAction: updownForeverTarget];
    
    //    set up physics body for collision
    
    }

// collision method
- (void)projectile:(SKSpriteNode *)projectile didCollideWithTarget:(SKSpriteNode *)target {
    
    SKAction *soundAction = [SKAction playSoundFileNamed:@"ping.wav" waitForCompletion:NO];
    [self runAction:soundAction];
    SKSpriteNode *obstacle = (SKSpriteNode*)[self childNodeWithName:@"//SpawnedObstacle"];
    [obstacle removeFromParent];
    NSLog(@"Hit Body");
    
//    add score
    [projectile removeFromParent];
    
    SKAction *blink = [SKAction sequence:@[
                                           [SKAction fadeOutWithDuration:0.50],
                                           [SKAction fadeInWithDuration:0.50]]];
    SKAction *blinkTwice = [SKAction repeatAction:blink count:2];
//    [self.gameScene addScoreLabel];
    [self runAction: blinkTwice];
}







@end
