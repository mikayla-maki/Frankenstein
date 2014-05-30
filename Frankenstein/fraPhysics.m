//
//  fraPhysics.m
//  Frankenstein
//
//  Created by Trenton Maki on 5/21/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import "fraPhysics.h"

@interface Physics ()
@property(strong, nonatomic) JSTileMap *map;
@end

@implementation Physics

//Returns a value between 1 and 0 representing the friction coefficient
- (NSNumber *)getFrictionForNode:(SKNode *)node {
    return @0.9;
}

- (CGPoint)GRAVITY {
    return CGPointMake(0.0, -450); //in points per second
};

- (NSInteger)X_LIMIT {
    return 9000; //in points per second
};

- (NSInteger)Y_LIMIT {
    return 9000; //in points per second
};


+ (id)createPhysicsWithMap:(JSTileMap *)map {
    return [[self alloc] initWithMap:map];
}

- (id)initWithMap:(JSTileMap *)map {
    self = [super init];
    if (self != nil) {
        self.map = map;
    }
    return self;
}

+ (Physics *)createPhysicsWithMap:(JSTileMap *)map andArr:(NSArray *)arr {
    return [[self alloc] initWithMap:map];
}

- (CGRect)tileRectFromTileCoords:(CGPoint)tileCoords {
    float levelHeightInPixels = self.map.mapSize.height * self.map.tileSize.height;
    CGPoint origin = CGPointMake(tileCoords.x * self.map.tileSize.width, levelHeightInPixels - ((tileCoords.y + 1) * self.map.tileSize.height));
    return CGRectMake(origin.x, origin.y, self.map.tileSize.width, self.map.tileSize.height);
}

- (NSInteger)tileGIDAtTileCoord:(CGPoint)coord forLayer:(TMXLayer *)layer {

    TMXLayerInfo *layerInfo = layer.layerInfo;

    //	int idx = coord.x + coord.y * _layerGridSize.width;

//    NSAssert(idx < (_layerGridSize.width * _layerGridSize.height), @"index out of bounds!");
    /*
  NSLog(@"Coord.x: %f", coord.x);
  NSLog(@"Coord.y: %f", coord.y);

  NSLog(@"Layer height: %f",[[layer layerInfo] layerGridSize].height);
  NSLog(@"Layer width: %f", [[layer layerInfo] layerGridSize].width);

  NSLog(@"gidSize: %f < %f x %f (%f) = %@", coord.x + coord.y * layerInfo.layerGridSize.width,
          layerInfo.layerGridSize.width,
          layerInfo.layerGridSize.height, layerInfo.layerGridSize.width * layerInfo.layerGridSize.height,
          coord.x + coord.y * layerInfo.layerGridSize.width < layerInfo.layerGridSize.width * layerInfo.layerGridSize.height ? @"YES" : @"NO");
          */
    return [layerInfo tileGidAtCoord:coord];
}


/*
 This method is terrible. It manually manages collisions. I need to modify it to send out events involving the two
 types of collidees. Then I can ask them how to proceed
 */

- (void)resolveCollisionsWithLayer:(TMXLayer *)layer withPlayer:(Player *)player {
    //NSInteger gid = [self tileGIDAtTileCoord:CGPointMake(99, 19) forLayer:layer];
    int DOWN_A = 13;
    int DOWN_B = 14;
    int UP_A = 1;
    int UP_B = 2;
    int LEFT_A = 4;
    int LEFT_B = 8;
    int RIGHT_A = 7;
    int RIGHT_B = 11;
    int UP_LEFT = 0;
    int UP_RIGHT = 3;
    int DOWN_LEFT = 12;
    int DOWN_RIGHT = 15;
    int indiceLength = 12;
    //The indices array specifies an order to consider tiles. The tiles themselves are determined by the following coordinate system:
    /*
    0  1  2   3
    4  5p 6p  7
    8  9p 10p 11
    12 13 14  15
    The tiles with p are assumed to be the players coordinates
     */
    int indices[12] = {DOWN_A, DOWN_B, UP_A, UP_B, LEFT_A, LEFT_B, RIGHT_A, RIGHT_B, UP_LEFT, UP_RIGHT, DOWN_LEFT, DOWN_RIGHT}; //Order of collision resolution


    //This whole thing is a mess. I probably need to write my own don't I?
    /*
    player.onGround = NO;  ////Here
    for (NSUInteger i = 0; i < 12; i++) {
        NSInteger tileIndex = indices[i];

        CGRect playerRect = [player collisionBoundingBox];
        CGPoint playerCoord = [layer coordForPoint:player.desiredPosition];

        NSInteger tileColumn = tileIndex % 3;
        NSInteger tileRow = tileIndex / 3;
        CGPoint tileCoord = CGPointMake(playerCoord.x + (tileColumn - 1), playerCoord.y + (tileRow - 1));

        NSInteger gid = [self tileGIDAtTileCoord:tileCoord forLayer:layer];
        if (gid != 0) {
            CGRect tileRect = [self tileRectFromTileCoords:tileCoord];
            //NSLog(@"GID %ld, Tile Coord %@, Tile Rect %@, player rect %@", (long)gid, NSStringFromCGPoint(tileCoord), NSStringFromCGRect(tileRect), NSStringFromCGRect(playerRect));
            //1
            if (CGRectIntersectsRect(playerRect, tileRect)) {
                CGRect intersection = CGRectIntersection(playerRect, tileRect);
                //2
                if (tileIndex == DOWN_A || tileIndex == DOWN_B) {
                    //tile is directly below Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y + intersection.size.height);
                    player.velocity = CGPointMake(player.velocity.x, 0.0); ////Here
                    player.onGround = YES; ////Here
                } else if (tileIndex == UP_A || tileIndex == UP_B) {
                    //tile is directly above Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y - intersection.size.height);
                } else if (tileIndex == LEFT_A || tileIndex == LEFT_B) {
                    //tile is left of Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x + intersection.size.width, player.desiredPosition.y);
                    NSLog(@"HERE Left");
                    player.velocity = CGPointMake(0, player.velocity.y); ////Here
                } else if (tileIndex == RIGHT_A || tileIndex == RIGHT_B) {
                    //tile is right of Koala
                    player.desiredPosition = CGPointMake(player.desiredPosition.x - intersection.size.width, player.desiredPosition.y);
                    NSLog(@"HERE right");
                    player.velocity = CGPointMake(0, player.velocity.y); ////Here
                    //3
                } else {
                    if (intersection.size.width > intersection.size.height) {
                        //tile is diagonal, but resolving collision vertically
                        //4
                        player.velocity = CGPointMake(player.velocity.x, 0.0); ////Here
                        float intersectionHeight;
                        if (tileIndex > RIGHT_B - 1 || tileIndex == RIGHT_A) { //Tile is under/right player
                            intersectionHeight = intersection.size.height;
                            player.onGround = YES; ////Here
                        } else {
                            intersectionHeight = -intersection.size.height;
                        }
                        player.desiredPosition = CGPointMake(player.desiredPosition.x, player.desiredPosition.y + intersectionHeight);
                        NSLog(@"Here diagonal, down");
                    } else {
                        //tile is diagonal, but resolving horizontally
                        float intersectionWidth;
                        if (tileIndex == UP_LEFT || tileIndex == DOWN_LEFT) {
                            intersectionWidth = intersection.size.width;
                        } else {
                            intersectionWidth = -intersection.size.width;
                        }
                        NSLog(@"Here diagonal left, Up and down");
                        //5
                        player.desiredPosition = CGPointMake(player.desiredPosition.x + intersectionWidth, player.desiredPosition.y);
                    }
                }
            }
        }
    }
    //6
    player.position = player.desiredPosition;
}           */
}

@end
