//
//  GameData.h
//  ArcheryPhysics
//
//  Created by JOSE PILAPIL on 2016-07-28.
//  Copyright © 2016 JOSE PILAPIL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameData : NSObject <NSCoding>


@property (assign, nonatomic) long score;

@property (assign, nonatomic) long highScore;

+(instancetype)sharedGameData;
-(void)reset;
-(void)save;

@end
