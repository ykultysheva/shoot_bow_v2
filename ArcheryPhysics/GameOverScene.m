//
//  GameOverScene.m
//  ArcheryPhysics
//
//  Created by JOSE PILAPIL on 2016-07-28.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import "GameOverScene.h"
#import "GameScene.h"

@interface GameOverScene ()
@property BOOL contentCreated;
@end

@implementation GameOverScene


- (void)didMoveToView: (SKView *) view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}


- (void)createSceneContents
{   self.anchorPoint = CGPointMake(0.5,0.5);
//    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"shapes1"];
//    self.backgroundColor = [UIColor whiteColor];
//    sprite.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-100);
    self.scaleMode = SKSceneScaleModeAspectFit;
//    [self addChild: sprite];
    [self addChild: [self createMenu]];
}

- (SKLabelNode *)createMenu
{
    SKLabelNode *menuNode = [SKLabelNode labelNodeWithFontNamed:@"MarkerFelt-Wide"];
    menuNode.text = @"Game Over";
    menuNode.fontSize = 50;
    menuNode.fontColor = [UIColor greenColor];
    menuNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    menuNode.name = @"menuNode";
    return menuNode;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    SKNode *menuNode = [self childNodeWithName:@"menuNode"];
    if (menuNode != nil)
    {
        menuNode.name = nil;
        SKAction *moveUp = [SKAction moveByX: 0 y: 100.0 duration: 0.5];
        SKAction *zoom = [SKAction scaleTo: 2.0 duration: 0.25];
        SKAction *pause = [SKAction waitForDuration: 0.5];
        SKAction *fadeAway = [SKAction fadeOutWithDuration: 0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[moveUp, zoom, pause, fadeAway, remove]];
        [menuNode runAction: moveSequence completion:^{
            GameScene *gameScene  = [[GameScene alloc] initWithSize:self.size];
            SKTransition *doors = [SKTransition doorsOpenVerticalWithDuration:0.5];
            [self.view presentScene:gameScene transition:doors];
        }];
    }
    
    
}

@end