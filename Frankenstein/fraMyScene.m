//
//  fraMyScene.m
//  Frankenstein
//
//  Created by Trenton Maki on 5/15/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import "fraMyScene.h"
#import "JSTileMap.h"

@interface fraMyScene()
@property (nonatomic, strong) JSTileMap *map;
@end

@implementation fraMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.map = [JSTileMap mapNamed:@"devRoom.tmx"];
        [self addChild:self.map];
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
    /* Called before each frame is rendered */
}

@end
