//
//  fraPlayer.h
//  Frankenstein
//
//  Created by Trenton Maki on 5/20/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode
@property (nonatomic, assign) CGPoint desiredPosition;
@property (nonatomic, assign) BOOL onGround;
@property (nonatomic, assign) CGPoint velocity;
-(id)initPlayer;
-(void)update:(NSTimeInterval)delta;
-(CGRect)collisionBoundingBox;
+(instancetype)createPlayer;
@end
