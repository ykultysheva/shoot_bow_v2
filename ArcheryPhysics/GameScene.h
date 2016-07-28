//
//  GameScene.h
//  ArcheryPhysics
//

//  Copyright (c) 2016 JOSE PILAPIL. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

static const uint32_t projectileCategory     =  0x1 << 0;
static const uint32_t targetCategory        =  0x1 << 1;
static const uint32_t headCategory        =  0x1 << 2;
static const uint32_t obstacleCategory        =  0x1 << 3;

@interface GameScene : SKScene
@property int score;
-(void)addScoreLabel;
-(void)startUpDownSpawned;
@end
