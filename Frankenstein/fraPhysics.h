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
@property (nonatomic, assign, readonly) CGPoint GRAVITY;
@property (nonatomic, assign, readonly) NSInteger X_LIMIT;
@property (nonatomic, assign, readonly) NSInteger Y_LIMIT;
+(instancetype)createPhysicsWithMap:(JSTileMap*)map;
-(void)resolveCollisionsWithLayer:(TMXLayer*)layer withPlayer:(Player*)player;

+ (Physics *)createPhysicsWithMap:(JSTileMap *)map andArr:(NSArray *)arr;

-(NSNumber*)getFrictionForNode:(SKNode*) node;
@end
