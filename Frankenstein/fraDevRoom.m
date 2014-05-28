//
//  Frankenstein
//
//  Created by Trenton Maki on 5/15/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import "fraDevRoom.h"
#import "JSTileMap.h"
#import "fraPlayer.h"
#import "fraPhysics.h"

@interface fraMyScene()
@property (nonatomic, strong) JSTileMap *map;
@property (nonatomic, strong) Player *player;
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;
@property (nonatomic, strong) TMXLayer *walls;
@property (nonatomic, strong) Physics *physics;
@end

@implementation fraMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:.4 green:.4 blue:.95 alpha:1.0];
        self.map = [JSTileMap mapNamed:@"1.2.3.tmx"];//CONFIG!
        [self addChild:self.map];
        self.walls = [self.map layerNamed:@"map_stuff"];//CONFIG!
        
        self.physics = [Physics createPhysicsWithMap:self.map];
        
        self.player = [Player createPlayer];
        self.player.position = CGPointMake(100,100);//Start coordinates need to be saved somewhere
        self.player.zPosition = 20; //Make a heirarchy of constants to abstract this (FOREGROUND, BACKGROUND, etc.)
        
        [self.map addChild:self.player];
        
        
        
    }
    return self;
}

-(void)update:(CFTimeInterval)currentTime {
    //2
    NSTimeInterval delta = currentTime - self.previousUpdateTime;
    //3
    if (delta > 0.02) {
        delta = 0.02;
    }
    //4
    self.previousUpdateTime = currentTime;
    //5
    [self.player update:delta withPhysics:self.physics];
    //[self.enemies update:delta player:self.player];
    [self.physics resolveCollisionsWithLayer:self.walls withPlayer:self.player];
}

- (void)movePlayer:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInNode:self];
    if (touchLocation.x > self.size.width / 2.0) {
        [self.player moveLeft];
    } else {
        [self.player moveRight];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [self movePlayer:touch];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        [self movePlayer:touch];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.player stop];
}

@end