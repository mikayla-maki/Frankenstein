//
//  fraPlayer.h
//  Frankenstein
//
//  Created by Trenton Maki on 5/20/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class Physics;

@interface Player : SKSpriteNode
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) CGPoint velocity;
-(void)moveLeft;
-(void)moveRight;
-(void)stop;
-(id)initPlayer;
-(void)update:(NSTimeInterval)delta withPhysics:(Physics*)physics;
-(CGRect)collisionBoundingBox;
+(instancetype)createPlayer;
@end
