//
//  GameScene.m
//  ArcheryPhysics
//
//  Created by JOSE PILAPIL on 2016-07-26.
//  Copyright (c) 2016 JOSE PILAPIL. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "GameScene.h"
#import "Obstacle.h"
#import "Target.h"
#import "Head.h"
#import "GameOverScene.h"
#import "Castle.h"
#import "GameData.h"

@interface GameScene() <SKPhysicsContactDelegate>
@property BOOL castleActive;
@property NSTimer *powerBarTimer;
@property NSDate *StartDate;
@property (nonatomic) Target * target;
@property (nonatomic) Obstacle * obstacle;
@property (nonatomic) Head * head;
@property int testNum;
@property Obstacle* spawnedObstacle;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic) int counter;


@end

//set up categories for collision
SKLabelNode* _score;
SKLabelNode* _highScore;

@implementation GameScene




static inline CGPoint rwAdd(CGPoint a, CGPoint b) {
    return CGPointMake(a.x + b.x, a.y + b.y);
}

static inline CGPoint rwSub(CGPoint a, CGPoint b) {
    return CGPointMake(a.x - b.x, a.y - b.y);
}

static inline CGPoint rwMult(CGPoint a, float b) {
    return CGPointMake(a.x * b, a.y * b);
}

static inline float rwLength(CGPoint a) {
    return sqrtf(a.x * a.x + a.y * a.y);
}

// Makes a vector have a length of 1
static inline CGPoint rwNormalize(CGPoint a) {
    float length = rwLength(a);
    return CGPointMake(a.x / length, a.y / length);
}

-(void)didMoveToView:(SKView *)view {    _score.text = @"0 pt";
    

    [self setupLabels];
//    [self addScoreLabel];
//    [self shotsFiredLabel];
    /* Setup your scene here */
    self.castleActive = NO;
    SKSpriteNode *groundNode = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(view.frame.size.width+200, 20)];
    groundNode.position = CGPointMake(view.center.x, view.center.y /10);
    groundNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:groundNode.size];
    groundNode.physicsBody.dynamic = NO;
    groundNode.name = @"ground";
    
    SKSpriteNode *archerNode = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(30, 30)];
    archerNode.name= @"Archer";
    archerNode.position= CGPointMake(view.center.x/5, view.center.y +100);
    archerNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:archerNode.size];
    NSLog(@"CenterX:%f Center:y %f",view.center.x, view.center.y);
 
   
    [self addChild:groundNode];
    [self addChild:archerNode];
    
//    set up physics for collision
    self.physicsWorld.contactDelegate = self;
    
    self.testNum = 1;
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchBegan");
    SKSpriteNode *archer = (SKSpriteNode*)[self childNodeWithName:@"Archer"];
    SKSpriteNode *powerBar = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(10, 10)];
    
    powerBar.position = CGPointMake(archer.position.x, archer.position.y + 40);
    powerBar.name = @"Powerbar";
    powerBar.anchorPoint = CGPointMake(0.5, 0.0);
    [self addChild:powerBar];
    self.powerBarTimer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(handlePowerUp:) userInfo:nil repeats:NO];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/kazoo.wav", [[NSBundle mainBundle] resourcePath]]];
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    self.audioPlayer.numberOfLoops = 0;
    
    if (!self.audioPlayer)
        NSLog(@"%@",[error localizedDescription]);
    else
        [self.audioPlayer play];
    self.StartDate = [NSDate date];
}

-(void)handlePowerUp:(id)sender
{
    NSLog(@"Being handled");
    SKAction *increaseHeight = [SKAction scaleXBy:1 y:10 duration:1.5];
    
    SKSpriteNode *powerBar = (SKSpriteNode*)[self childNodeWithName:@"Powerbar"];
    [powerBar runAction:increaseHeight];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.audioPlayer stop];
    [self removeActionForKey:@"action"];
    SKSpriteNode *powerBar = (SKSpriteNode*)[self childNodeWithName:@"Powerbar"];
    [powerBar removeFromParent];
    
   // self.shotsFired ++;
    SKNode *shotsFired = [self childNodeWithName:@"shotsFire"];
    [shotsFired removeFromParent];
    //[self shotsFiredLabel];
                          
    NSTimeInterval ti = [[NSDate date] timeIntervalSinceDate:self.StartDate];
    NSLog(@"Time: %f", ti);
    if (ti > 1.5){
        ti = 1.5;
    }
    // 1 - Choose one of the touches to work with
    UITouch * touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    // 2 - Position the projectile
    SKNode *archer = [self childNodeWithName:@"Archer"];
    SKSpriteNode *projectile = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    projectile.position = CGPointMake(archer.position.x+30, archer.position.y+10);
    // 3 determine projectile offset to position
    CGPoint offset = rwSub(location, projectile.position);
    projectile.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:projectile.size.width/2];
    projectile.physicsBody.dynamic = YES;
    projectile.physicsBody.restitution = .5;
    projectile.name = @"Arrow";
    
    // 4 - Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // 5 - OK to add now - we've double checked position
    [self addChild:projectile];
    
    // 6 - Get the direction of where to shoot
    CGPoint direction = rwNormalize(offset);
    
    // 7 - Make it shoot far enough to be guaranteed off screen
    float forceValue =  ti * 2.66; //Edit this value to get the desired force.
    CGPoint shootAmount = rwMult(direction, forceValue);
    
    //8 - Convert the point to a vector
    CGVector impulseVector = CGVectorMake(shootAmount.x, shootAmount.y);
    //This vector is the impulse you are looking for.
    
    //9 - Apply impulse to node.
    [projectile.physicsBody applyImpulse:impulseVector];
    
//    set up collision for projectile
    projectile.physicsBody.categoryBitMask = projectileCategory;
    projectile.physicsBody.contactTestBitMask = headCategory | targetCategory | obstacleCategory;
    projectile.physicsBody.collisionBitMask = 0;
    projectile.physicsBody.usesPreciseCollisionDetection = YES;
    
}

-(void)shoot
{
    SKNode *archer = [self childNodeWithName:@"Archer"];
    SKSpriteNode *arrow = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(10, 10)];
    arrow.position = CGPointMake(archer.position.x+5,archer.position.y+5);
}


-(void)update:(CFTimeInterval)currentTime {
    if ([GameData sharedGameData].score > [GameData sharedGameData].highScore)
    {   [GameData sharedGameData].highScore = [GameData sharedGameData].score;
        _highScore.text = [NSString stringWithFormat:@"High:%@", _score.text];
    }
    
    if (self.counter < 0){
        self.counter = 0;
    }
    
    if (self.counter > 4){
        SKScene * scene = [GameOverScene sceneWithSize:self.frame.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [GameData sharedGameData].highScore = MAX([GameData sharedGameData].score,
                                                  [GameData sharedGameData].highScore);
        [[GameData sharedGameData]save];
        [[GameData sharedGameData]reset];
        // Present the scene.
        [self.view presentScene:scene];
    }
    
    /* Called before each frame is rendered */
    if ([GameData sharedGameData].score >= 2 && self.testNum == 1 ) {
        [self.target startUpDownTarget];
        self.testNum = 0;
    }
    
    if ([GameData sharedGameData].score >=4 && self.testNum == 0) {
        
        self.obstacle = [[Obstacle alloc ]init];
        self.obstacle.sceneFrame = self.frame;
        self.obstacle.gameScene = self;
        [self.obstacle setUpObst];
        [self.obstacle startUpDown];
        [self addChild:self.obstacle];
        self.testNum = 2;
    }
    
    if ([GameData sharedGameData].score >=10 && self.testNum == 2){
        
        Obstacle *newObstacle = [[Obstacle alloc]init];
        newObstacle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:newObstacle];
        SKAction *moveLeft = [SKAction moveByX:-50 y:0 duration:1];
        SKAction *moveRight = [SKAction moveByX:100 y:0 duration:2];
        SKAction *actionSequence = [SKAction sequence:@[moveLeft,moveRight,moveLeft]];
        SKAction *repeatAction = [SKAction repeatActionForever:actionSequence];
        [newObstacle runAction:repeatAction];
        self.testNum = 3;
    }
    
    if ([GameData sharedGameData].score< 0){
        SKScene * scene = [GameOverScene sceneWithSize:self.frame.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [[GameData sharedGameData]reset];
        // Present the scene.
        [self.view presentScene:scene];
    }
    if ([GameData sharedGameData].score>= 20 && !self.castleActive){
        SKSpriteNode *archer = (SKSpriteNode*)[self childNodeWithName:@"Archer"];
        Castle *castle = [[Castle alloc]init];
        castle.position = CGPointMake(archer.position.x-9, archer.position.y-5);
        castle.name = @"Castle";
        castle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:castle.size];
        castle.physicsBody.density = 500;
      
        [self addChild:castle];
        SKAction *increaseCastleHeight = [SKAction scaleXBy:1 y:5 duration:1];
        
        self.castleActive = YES;
        [castle runAction:increaseCastleHeight];
        
    };

}

#pragma mark -castle code

//if (self.score >= 20 && !self.castleActive){
//    SKSpriteNode *archer = (SKSpriteNode*)[self childNodeWithName:@"Archer"];
//    Castle *castle = [[Castle alloc]init];
//    castle.position = CGPointMake(archer.position.x-9, archer.position.y-5);
//    castle.name = @"Castle";
//    castle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:castle.size];
//    castle.physicsBody.density = 500;
//    
//    [self addChild:castle];
//    SKAction *increaseCastleHeight = [SKAction scaleXBy:1 y:5 duration:1];
//    
//    self.castleActive = YES;
//    [castle runAction:increaseCastleHeight];
//    
//};



// YANA'S CODE:
//Creating initial position for the target
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
//        setting up view
        NSLog(@"Size: %@", NSStringFromCGSize(size));
//        set up physics for collision
        self.physicsWorld.contactDelegate = self;
        
        

        
// target object
        
        self.target = [[Target alloc ]init];
        self.target.sceneFrame = self.frame;
        self.target.gameScene = self;
        [self.target setUpTarget];
        [self addChild:self.target];
        

        

// head object
 
        self.head = [[Head alloc] init];
        self.head.sceneFrame = self.frame;
        self.head.gameScene = self;
        [self.head setUpHead];
        [self.target addChild:self.head];

        
        
//obstacle object
        
//        self.obstacle = [[Obstacle alloc ]init];
//        self.obstacle.sceneFrame = self.frame;
//        self.obstacle.gameScene = self;
//        [self.obstacle setUpObst];
//        [self.obstacle startUpDown];
//        [self addChild:self.obstacle];
        

    }
    return self;
}






// contact delegate method

- (void)didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == projectileCategory &&
        secondBody.categoryBitMask == targetCategory)
    {   self.counter -=2;
        [GameData sharedGameData].score += 1;
        _score.text = [NSString stringWithFormat:@"%li pt", [GameData sharedGameData].score];
        [self.target projectile:(SKSpriteNode *) firstBody.node didCollideWithTarget:(SKSpriteNode *) secondBody.node];
    }
    
    if (firstBody.categoryBitMask == projectileCategory &&
             secondBody.categoryBitMask == headCategory)
    {   self.counter -=2;
        [GameData sharedGameData].score += 2;
        _score.text = [NSString stringWithFormat:@"%li pt", [GameData sharedGameData].score];
        [self.head projectile:(SKSpriteNode *) firstBody.node didCollideWithHead:(SKSpriteNode *) secondBody.node];
    }
    
    if (firstBody.categoryBitMask == projectileCategory &&
        secondBody.categoryBitMask == obstacleCategory)
    {   self.counter ++;
        [GameData sharedGameData].score -= 1;
        _score.text = [NSString stringWithFormat:@"%li pt", [GameData sharedGameData].score];
        [self.obstacle projectile:(SKSpriteNode *) firstBody.node didCollideWithObst:(SKSpriteNode *) secondBody.node];
    }

}



-(void)didSimulatePhysics
{
    
    
}

-(void)setupLabels
{
    _score = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _score.fontSize = 12.0;
    _score.position = CGPointMake(self.view.center.x, self.view.center.y+150);
    _score.fontColor = [SKColor greenColor];
    _score.text = @"0 pt";
    [self addChild:_score];
    
    _highScore = [[SKLabelNode alloc] initWithFontNamed:@"Futura-CondensedMedium"];
    _highScore.fontSize = 12.0;
    _highScore.text = [NSString stringWithFormat:@"High: %li pt", [GameData sharedGameData].highScore];
    _highScore.position = CGPointMake(_score.position.x,_score.position.y-40);
    _highScore.fontColor = [SKColor redColor];
    [self addChild:_highScore];
}
@end
