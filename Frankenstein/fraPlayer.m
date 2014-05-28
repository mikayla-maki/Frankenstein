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
@property (nonatomic, assign) NSInteger CHANGE_IN_BOUNDING_BOX_X;//Changes the bounding
@property (nonatomic, assign) NSInteger CHANGE_IN_BOUNDING_BOX_Y;//box by this number of points
@end                                                             //(on both sides)

@implementation Player
+(id)createPlayer{
    return [[self alloc] initPlayer];
}

-(CGPoint)GRAVITY {
    return CGPointMake(0, -450);
}

-(CGPoint)LEFT_VELOCITY {
    return CGPointMake(500, 0);
}

-(CGPoint)RIGHT_VELOCITY {
    return CGPointMake(450, 0);
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
    self = [super initWithImageNamed:@"mouse_1.png"];
    if (self) {
        self.velocity = CGPointMake(0.0, 0.0);
        self.CHANGE_IN_BOUNDING_BOX_X = 0;
        self.CHANGE_IN_BOUNDING_BOX_Y = 0;
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
    
    self.velocity = CGPointAdd(CGPointAdd(self.velocity, gravityStep), movementStep);

    CGPoint velocityStep = CGPointMultiplyScalar(CGPointMultiplyScalar(self.velocity, delta), [physics getFrictionForNode:self]); //Keeping it in line + friction
    
    velocityStep.x = Clamp(velocityStep.x, -physics.X_LIMIT, physics.X_LIMIT);
    velocityStep.y = Clamp(velocityStep.y, -physics.Y_LIMIT, physics.Y_LIMIT);
    
    self.desiredPosition = CGPointAdd(self.position, velocityStep);
}



- (CGRect)collisionBoundingBox {
    CGRect boundingBox = CGRectInset(self.frame, self.CHANGE_IN_BOUNDING_BOX_X, self.CHANGE_IN_BOUNDING_BOX_Y);
    CGPoint diff = CGPointSubtract(self.desiredPosition, self.position);
    return CGRectOffset(boundingBox, diff.x, diff.y);
}

@end
