//
//  Target.h
//  ArcheryPhysics
//
//  Created by Yana Kultysheva on 2016-07-27.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class GameScene;



@interface Target : SKSpriteNode

@property (nonatomic) CGRect sceneFrame;
@property (nonatomic, weak) GameScene *gameScene;

- (void)setUpTarget;
-(void)startUpDownTarget;
- (void)projectile:(SKSpriteNode *)projectile didCollideWithTarget:(SKSpriteNode *)target;

@end
