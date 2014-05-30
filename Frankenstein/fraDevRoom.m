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
#import "SKTUtils.h"

@interface fraMyScene ()
@property(nonatomic, strong) JSTileMap *map;
@property(nonatomic, strong) Player *player;
@property(nonatomic, assign) NSTimeInterval previousUpdateTime;
@property(nonatomic, strong) TMXLayer *walls;
@property(nonatomic, strong) Physics *physics;
@end

@implementation fraMyScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.userInteractionEnabled = YES;
        /* Setup your scene here */
        SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"Bg.png"];
        bg.zPosition = -1000;
        bg.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:bg];
        self.map = [JSTileMap mapNamed:@"1.2.3.tmx"];//CONFIG!
        [self addChild:self.map];
        self.walls = [self.map layerNamed:@"map_stuff"];//CONFIG!

        SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(0.1, 0.2)];
/*
0  1  2   3
4  5p 6p  7
8  9p 10p 11
12 13 14  15
*/
       /* NSArray *arr = @[
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(32, 32)],//1
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(32, 32)],//2
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(32, 32)],//3
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(32, 32)],//4
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(32, 32)],//5
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(32, 32)],//6
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(32, 32)],//7
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(32, 32)],//8
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(32, 32)],//9
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(32, 32)],//10
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:CGSizeMake(32, 32)],//11
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(32, 32)],//12
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(32, 32)],//13
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(32, 32)],//14
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(32, 32)],//15
                (id) [SKSpriteNode spriteNodeWithColor:[UIColor orangeColor] size:CGSizeMake(32, 32)]];//16
        for (SKSpriteNode *node in arr) {
            [self.map addChild:node];
        }
        */

        self.physics = [Physics createPhysicsWithMap:self.map];

        self.player = [Player createPlayerWithNode:node];
        [self.map addChild:node];
        self.player.position = CGPointMake(400, 400);//Start coordinates need to be saved somewhere
        self.player.zPosition = 20; //Make a heirarchy of constants to abstract this (FOREGROUND, BACKGROUND, etc.)

        [self.map addChild:self.player];


    }
    return self;
}

- (void)update:(CFTimeInterval)currentTime {
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
    [self setViewpointCenter:self.player.position];
}

- (void)movePlayer:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInNode:self];
    if (touchLocation.x > self.size.width / 2.0) {
        [self.player moveLeft];
    } else {
        [self.player moveRight];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
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

- (void)setViewpointCenter:(CGPoint)position {
    NSInteger x = (NSInteger) MAX(position.x, self.size.width / 2);
    NSInteger y = (NSInteger) MAX(position.y, self.size.height / 2);
    x = (NSInteger) MIN(x, (self.map.mapSize.width * self.map.tileSize.width) - self.size.width / 2);
    y = (NSInteger) MIN(y, (self.map.mapSize.height * self.map.tileSize.height) - self.size.height / 2);
    CGPoint actualPosition = CGPointMake(x, y);
    CGPoint centerOfView = CGPointMake(self.size.width / 2, self.size.height / 2);
    CGPoint viewPoint = CGPointSubtract(centerOfView, actualPosition);
    self.map.position = viewPoint;
}

@end