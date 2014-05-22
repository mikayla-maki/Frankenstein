//
//  fraPhysics.h
//  Frankenstein
//
//  Created by Trenton Maki on 5/21/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSTileMap.h"
#import "fraPlayer.h"

@interface Physics : NSObject
+(instancetype)createPhysicsWithMap:(JSTileMap*)map;
-(void)resolveCollisionsWithLayer:(TMXLayer*)layer withPlayer:(Player*)player;
@end
