//
//  fraPlayer.h
//  Frankenstein
//
//  Created by Trenton Maki on 5/20/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface fraPlayer : SKSpriteNode
@property (nonatomic, assign) CGPoint desiredPosition;
//The velocity in the x and the y directions
@property (nonatomic, assign) CGPoint velocity;

@end
