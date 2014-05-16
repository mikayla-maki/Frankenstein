//
//  fraMyScene.m
//  Frankenstein2
//
//  Created by Trenton Maki on 5/14/14.
//  Copyright (c) 2014 Trenton Maki. All rights reserved.
//

#import "fraMyScene.h"
#import "JSTileMap.h"

@interface fraMyScene ()
- (void)loadMap;
@end



@implementation fraMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {

        // put anchor point in center of scene
		self.anchorPoint = CGPointMake(0.5,0.5);
        
		// create a world Node to allow for easy panning & zooming
		SKNode* worldNode = [[SKNode alloc] init];
		[self addChild:worldNode];

        
		// load initial map
		[self loadMap];

    }
    
    /*
     self.tiledMap = [JSTileMap mapNamed:tileMap];
     if (self.tiledMap)
     {
     // center map on scene's anchor point
     CGRect mapBounds = [self.tiledMap calculateAccumulatedFrame];
     self.tiledMap.position = CGPointMake(-mapBounds.size.width/2.0, -mapBounds.size.height/2.0);
     [self.worldNode addChild:self.tiledMap];
     
     // display name of map for testing
     if(!self.mapNameLabel)
     {
     SKLabelNode* mapLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
     mapLabel.xScale = .5;
     mapLabel.yScale = .5;
     mapLabel.text = tileMap;
     mapLabel.zPosition = -100;
     [self addChild:mapLabel];
     self.mapNameLabel = mapLabel;
     }
     else
     self.mapNameLabel.text = tileMap;
     self.mapNameLabel.position = CGPointMake(0, -self.size.height/2.0 + 30);
     
     // test spade for zOrdering.  Some test maps will make this more useful (as a test) than others.
     SKSpriteNode* spade = [SKSpriteNode spriteNodeWithImageNamed:@"black-spade-md.png"];
     spade.position = CGPointMake(spade.frame.size.width/2.5, spade.frame.size.height/2.5);
     spade.zPosition = self.tiledMap.minZPositioning / 2.0;
     #ifdef DEBUG
     NSLog(@"SPADE has zPosition %f", spade.zPosition);
     #endif
     [self.tiledMap addChild:spade];
     }
     else
     {
     NSLog(@"Uh Oh....");
     }

     */
    
    
    return self;
}

-(void)loadMap:() {
    
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
