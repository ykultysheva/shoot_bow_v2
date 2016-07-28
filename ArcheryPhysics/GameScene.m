//
//  GameScene.m
//  ArcheryPhysics
//
//  Created by JOSE PILAPIL on 2016-07-26.
//  Copyright (c) 2016 JOSE PILAPIL. All rights reserved.
//

#import "GameScene.h"
#import "Obstacle.h"
#import "Target.h"
#import "Head.h"

@interface GameScene() <SKPhysicsContactDelegate>

@property NSTimer *powerBarTimer;
@property NSDate *StartDate;
@property (nonatomic) Target * target;
@property (nonatomic) Obstacle * obstacle;
@property (nonatomic) Head * head;
@property int shotsFired;
@property int testNum;

@end

//set up categories for collision



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

-(void)didMoveToView:(SKView *)view {
    [self addScoreLabel];
    [self shotsFiredLabel];
    /* Setup your scene here */
    SKSpriteNode *groundNode = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(view.frame.size.width, 20)];
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
    
    self.StartDate = [NSDate date];
}

-(void)handlePowerUp:(id)sender
{
    NSLog(@"Being handled");
    SKAction *increaseHeight = [SKAction scaleXBy:1 y:10 duration:1];
    
    SKSpriteNode *powerBar = (SKSpriteNode*)[self childNodeWithName:@"Powerbar"];
    [powerBar runAction:increaseHeight];
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKSpriteNode *powerBar = (SKSpriteNode*)[self childNodeWithName:@"Powerbar"];
    [powerBar removeFromParent];
    
    self.shotsFired ++;
    SKNode *shotsFired = [self childNodeWithName:@"shotsFire"];
    [shotsFired removeFromParent];
    [self shotsFiredLabel];
                          
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
    projectile.position = CGPointMake(archer.position.x+20, archer.position.y+5);
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
    float forceValue =  ti * 3; //Edit this value to get the desired force.
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
    /* Called before each frame is rendered */
    if (self.score >= 2 && self.testNum == 1 ) {
        [self.target startUpDownTarget];
        self.testNum = 0;
    }
    
    if (self.score >=4 && self.testNum == 0) {
        
        self.obstacle = [[Obstacle alloc ]init];
        self.obstacle.sceneFrame = self.frame;
        self.obstacle.gameScene = self;
        [self.obstacle setUpObst];
        [self.obstacle startUpDown];
        [self addChild:self.obstacle];
        self.testNum = 2;
    }

}

// YANA'S CODE:
//Creating initial position for the target
-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
//        setting up view
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
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
    {
        [self.target projectile:(SKSpriteNode *) firstBody.node didCollideWithTarget:(SKSpriteNode *) secondBody.node];
    }
    
    if (firstBody.categoryBitMask == projectileCategory &&
             secondBody.categoryBitMask == headCategory)
    {
        [self.head projectile:(SKSpriteNode *) firstBody.node didCollideWithHead:(SKSpriteNode *) secondBody.node];
    }
    
    if (firstBody.categoryBitMask == projectileCategory &&
        secondBody.categoryBitMask == obstacleCategory)
    {
        [self.obstacle projectile:(SKSpriteNode *) firstBody.node didCollideWithObst:(SKSpriteNode *) secondBody.node];
    }

}



-(void)didSimulatePhysics
{
    
    
}
-(void)shotsFiredLabel
{
    SKNode *score = [self childNodeWithName:@"score"];
    SKLabelNode *shotsFired = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Shots Fired: %d",self.shotsFired]];
    
    shotsFired.position = CGPointMake(score.position.x,score.position.y- 40);
    shotsFired.fontColor = [UIColor blueColor];
    shotsFired.name = @"shotsFire";
    [self addChild:shotsFired];
}

-(void)addScoreLabel{
    
    SKLabelNode *scoreNode = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Score: %d",self.score]];
    
    scoreNode.position = CGPointMake(self.view.center.x,self.view.center.y+ 150);
    scoreNode.fontColor = [UIColor blueColor];
    scoreNode.name = @"score";
    [self addChild:scoreNode];
}

@end
