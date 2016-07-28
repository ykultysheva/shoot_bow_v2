//
//  Obstacle.m
//  ArcheryPhysics
//
//  Created by Yana Kultysheva on 2016-07-27.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "Obstacle.h"
#import "GameScene.h"

@interface Obstacle ()

@property Obstacle* spawnedObstacle;

@end


@implementation Obstacle


-(instancetype)init {
    self = [super initWithColor:[SKColor blueColor] size:CGSizeMake(40, 40)];
    if (self) {
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        self.physicsBody.dynamic = YES;
        self.physicsBody.affectedByGravity = NO;
        self.physicsBody.categoryBitMask = obstacleCategory;
        self.physicsBody.contactTestBitMask = projectileCategory;
        self.physicsBody.collisionBitMask = 0;
        
    }
    return self;
}

- (void)setUpObst {
    
    self.position = CGPointMake(self.sceneFrame.size.width/4*3, self.sceneFrame.size.height/2);
//    
//    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
//    self.physicsBody.dynamic = YES;
//    self.physicsBody.affectedByGravity = NO;
//    self.physicsBody.categoryBitMask = obstacleCategory;
//    self.physicsBody.contactTestBitMask = projectileCategory;
//    self.physicsBody.collisionBitMask = 0;

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
}


-(void)startUpDownSpawned {
    
    [self.gameScene enumerateChildNodesWithName:@"//SpawnedObstacle" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop) {
        //  set  up and down movements
        int minYobst = (node.frame.size.height / 2) + 20;
        int maxYobst = (self.sceneFrame.size.height - node.frame.size.height / 2);
        int durationObst = 1.5;
        SKAction * actionMoveUpObst = [SKAction moveTo:CGPointMake((node.frame.origin.x), maxYobst) duration:durationObst];
        SKAction * actionMoveDownObst = [SKAction moveTo:CGPointMake((node.frame.origin.x), minYobst) duration:durationObst];
        SKAction *updownObst = [SKAction sequence:@[actionMoveDownObst, actionMoveUpObst]];
        SKAction *updownForeverObst = [SKAction repeatActionForever:updownObst];
        [node runAction: updownForeverObst];
    }];
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
    
    
    self.spawnedObstacle = [[Obstacle alloc ]init];
    
    int minX = (self.sceneFrame.size.width/4);
    int maxX = (self.sceneFrame.size.width-self.spawnedObstacle.size.width);
    int rangeX = maxX - minX;
    int actualX = (arc4random() % rangeX) + minX;
    
    
    self.spawnedObstacle.position = CGPointMake(actualX, self.sceneFrame.size.height/2);
    self.spawnedObstacle.name = @"SpawnedObstacle";
    [self.gameScene addChild:self.spawnedObstacle];
    
    
    [self.spawnedObstacle startUpDownSpawned];
    
}





@end
