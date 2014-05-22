//
//  Frankenstein
//
//  Created by Trenton Maki on 5/15/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import "fraDevRoom.h"
#import "JSTileMap.h"
#import "fraPlayer.h"

@interface fraMyScene()
@property (nonatomic, strong) JSTileMap *map;
@property (nonatomic, strong) Player *player;
@property (nonatomic, assign) NSTimeInterval previousUpdateTime;
@end

@implementation fraMyScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.map = [JSTileMap mapNamed:@"devRoom.tmx"];
        [self addChild:self.map];
        
        self.player = [[Player alloc] initPlayer];
        self.player.position = CGPointMake(100, 50);//Start coordinates need to be saved somewhere
        self.player.zPosition = 15; //Make a heirarchy of constants to abstract this (FOREGROUND, BACKGROUND, etc.)
        
        [self.map addChild:self.player];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
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
    [self.player update:delta];
    //[self.enemies update:delta player:self.player];
}

-(CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
    float levelHeightInPixels = self.map.mapSize.height * self.map.tileSize.height;
    CGPoint origin = CGPointMake(tileCoords.x * self.map.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * self.map.tileSize.height));
    return CGRectMake(origin.x, origin.y, self.map.tileSize.width, self.map.tileSize.height);
}

- (NSInteger)tileGIDAtTileCoord:(CGPoint)coord forLayer:(TMXLayer *)layer {
    TMXLayerInfo *layerInfo = layer.layerInfo;
    return [layerInfo tileGidAtCoord:coord];
}

- (void)checkForAndResolveCollisionsForPlayer:(Player *)player forLayer:(TMXLayer *)layer {
    NSArray *indices = @[@13, @14, @1, @2, @4, @8, @7, @11, @0, @3, @12, @15]; //Order of collision resolution
    
    for (NSInteger *tileIndex in indices) {
        
        //2
        CGRect playerRect = [player collisionBoundingBox];
        //3
        CGPoint playerCoord = [layer coordForPoint:player.position];
        //4
        NSInteger tileColumn = tileIndex % 3;
        NSInteger tileRow = tileIndex / 3;
        CGPoint tileCoord = CGPointMake(playerCoord.x + (tileColumn - 1), playerCoord.y + (tileRow - 1));
        //5
        NSInteger gid = [self tileGIDAtTileCoord:tileCoord forLayer:layer];
        //6
        if (gid) {
            //7
            CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
            //8
            NSLog(@"GID %ld, Tile Coord %@, Tile Rect %@, player rect %@", (long)gid, NSStringFromCGPoint(tileCoord), NSStringFromCGRect(tileRect), NSStringFromCGRect(playerRect));
            //collision resolution goes here
        }
        
    }
}

@end
