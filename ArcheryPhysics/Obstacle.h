//
//  Obstacle.h
//  ArcheryPhysics
//
//  Created by Yana Kultysheva on 2016-07-27.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class GameScene;

@interface Obstacle : SKSpriteNode

- (void)setUpObst;
-(void)startUpDown;
- (void)projectile:(SKSpriteNode *)projectile didCollideWithObst:(SKSpriteNode *)obstacle;
@property (nonatomic) CGRect sceneFrame;
@property (nonatomic, weak) GameScene *gameScene;
@end
