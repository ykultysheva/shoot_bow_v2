//
//  Obstacle.m
//  ArcheryPhysics
//
//  Created by Yana Kultysheva on 2016-07-27.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "Obstacle.h"
#import "GameScene.h"


@implementation Obstacle


-(instancetype)init {
    self = [super initWithColor:[SKColor blueColor] size:CGSizeMake(40, 40)];
    if (self) {
    }
    return self;
}

- (void)setUpObst {
    
    self.position = CGPointMake(self.sceneFrame.size.width/4*3, self.sceneFrame.size.height/2);
}

-(void)startUpDown {

//  set  up and down movements
    
    int minYobst = (self.size.height / 2) + 20;
    int maxYobst = (self.sceneFrame.size.height - self.size.height / 2);
    int durationObst = 1.5;
    SKAction * actionMoveUpObst = [SKAction moveTo:CGPointMake((self.sceneFrame.size.width/4*3), maxYobst) duration:durationObst];
    SKAction * actionMoveDownObst = [SKAction moveTo:CGPointMake((self.sceneFrame.size.width/4*3), minYobst) duration:durationObst];
    SKAction *updownObst = [SKAction sequence:@[actionMoveDownObst, actionMoveUpObst]];
    SKAction *updownForeverObst = [SKAction repeatActionForever:updownObst];
    [self runAction: updownForeverObst];
    
//    set up physics body for collision
    
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.dynamic = YES;
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = obstacleCategory;
    self.physicsBody.contactTestBitMask = projectileCategory;
    self.physicsBody.collisionBitMask = 0;
}



- (void)projectile:(SKSpriteNode *)projectile didCollideWithObst:(SKSpriteNode *)obsticle {
    NSLog(@"Hit obsticle");
    [projectile removeFromParent];
    SKAction *zoomInOut = [SKAction sequence:@[[SKAction scaleTo:0.5 duration:0.1],
                                               [SKAction scaleTo: 1.0 duration:0.1]]];
    [self runAction: zoomInOut];
  
//    substruct scoer
    self.gameScene.score --;
    SKLabelNode *score = (SKLabelNode*)[self.gameScene childNodeWithName:@"score"];
    score.text = [NSString stringWithFormat:@"Score: %i", self.gameScene.score];
}





@end
