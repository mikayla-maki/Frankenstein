//
//  fraPlayer.m
//  Frankenstein
//
//  Created by Trenton Maki on 5/20/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import "fraPlayer.h"
#import "SKTUtils.h"
#import "fraPhysics.h"

@interface Player()
@property (nonatomic, assign, readonly) CGPoint GRAVITY;
@property (nonatomic, assign, readonly) CGPoint RIGHT_VELOCITY;
@property (nonatomic, assign, readonly) CGPoint LEFT_VELOCITY;
@property (nonatomic) BOOL moveRightB;
@property (nonatomic) BOOL moveLeftB;
@property (nonatomic) SKSpriteNode* box;
@property (nonatomic, assign) NSInteger CHANGE_IN_BOUNDING_BOX_X;//Changes the bounding
@property (nonatomic, assign) NSInteger CHANGE_IN_BOUNDING_BOX_Y;//box by this number of points
@end                                                             //(on both sides)

@implementation Player

+(id)createPlayerWithNode:(SKSpriteNode *)node {
    return [[self alloc] initPlayerWithBox:node];
}

+(id)createPlayer{
    return [[self alloc] initPlayer];
}

-(CGPoint)GRAVITY {
    return CGPointMake(0, -450);
}

-(CGPoint)LEFT_VELOCITY {
    return CGPointMake(9000, 0);
}

-(CGPoint)RIGHT_VELOCITY {
    return CGPointMake(-9000, 0);
}
-(void)stop {
    self.moveLeftB = NO;
    self.moveRightB = NO;
}
-(void) moveLeft {
    self.moveLeftB = YES;
    self.moveRightB = NO;
}

-(void) moveRight {
    self.moveLeftB = NO;
    self.moveRightB = YES;
}

-(id)initPlayer
{
    self = [super initWithImageNamed:@"character_normal.png"];
    if (self) {
        self.velocity = CGPointMake(0.0, 0.0);
        self.CHANGE_IN_BOUNDING_BOX_X = 0;
        self.CHANGE_IN_BOUNDING_BOX_Y = 0;
    }
    return self;
}

-(id)initPlayerWithBox:(SKSpriteNode*)node
{
    self = [super initWithImageNamed:@"character_normal.png"];
    if (self) {
        self.velocity = CGPointMake(0.0, 0.0);
        self.CHANGE_IN_BOUNDING_BOX_X = 0;
        self.CHANGE_IN_BOUNDING_BOX_Y = 0;
        self.box = node;
        [self collisionBoundingBox];
    }
    return self;
}




-(long)putInRangeForVal:(long)val withMin:(long)min withMax:(long)max {
    if (val > max) {
        return max;
    } else if(val < min) {
        return min;
    } else {
        return val;
    }
}

- (void)update:(NSTimeInterval)delta withPhysics:(Physics*)physics {
    CGPoint gravityStep = CGPointMultiplyScalar(physics.GRAVITY, delta);
    
    CGPoint movementStep;
    if(self.moveRightB){
        movementStep = CGPointMultiplyScalar(self.RIGHT_VELOCITY, delta);
    } else if(self.moveLeftB){
        movementStep = CGPointMultiplyScalar(self.LEFT_VELOCITY, delta);
    } else {
        movementStep = CGPointMake(0, 0);
    }
    
    movementStep = CGPointMultiplyScalar(movementStep, delta);

    //Velocity = ((Velocity + gravity step) + movement step) * friction
    self.velocity = CGPointAdd(self.velocity, gravityStep);
    self.velocity = CGPointAdd(self.velocity, movementStep);
    self.velocity = CGPointMultiplyScalar(self.velocity, [[physics getFrictionForNode:self] floatValue]);
    
    self.velocity = CGPointMake(Clamp(self.velocity.x, -physics.X_LIMIT, physics.X_LIMIT), Clamp(self.velocity.y, -physics.Y_LIMIT, physics.Y_LIMIT)); //Clamping the x and y to a limit
        
    self.desiredPosition = CGPointAdd(self.position, self.velocity);
    self.box.position = CGPointAdd(self.position, self.velocity);

}



- (CGRect)collisionBoundingBox {

    CGRect boundingBox = CGRectInset(self.frame, self.CHANGE_IN_BOUNDING_BOX_X, self.CHANGE_IN_BOUNDING_BOX_Y);
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    CGRect final = CGRectOffset(boundingBox, diff.x, diff.y);
    self.box.size = CGSizeMake(final.size.width, final.size.height);
    return final;
}

@end
