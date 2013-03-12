//
//  InventoryLayer.m
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "InventoryLayer.h"

@implementation InventoryLayer

-(id) init
{
	if( (self=[super init])) {
		
		// enable events
        
        CGSize size = [CCDirector sharedDirector].winSize;
		
		self.isTouchEnabled = YES;
        
        selectedObject = [[NSString alloc] initWithFormat:@"None"];
		
        [self setContentSize:CGSizeMake(size.width*0.25, size.height)];
        [self setPosition:ccp(0,0)];
        
		// create menu button
		[self createMenu];
	}
	return self;
}

-(void) dealloc
{
	[super dealloc];
}

-(void) createMenu
{
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
	
	// Makes a ball when you click
	CCMenuItemLabel *selectBallButton = [CCMenuItemFont itemWithString:@"Select Ball Button" block:^(id sender){
		NSLog(@"Ball button pressed.");
        selectedObject = @"BallObject";
	}];
    // Makes a ramp when you click
    CCMenuItemLabel *selectRampButton = [CCMenuItemFont itemWithString:@"Select Ramp Button" block:^(id sender){
		NSLog(@"Select Ramp button pressed.");
        selectedObject = @"RampObject";
	}];
    //selects nothing so you can click freely
    CCMenuItemLabel *unSelectButton = [CCMenuItemFont itemWithString:@"Reset Button" block:^(id sender){
		NSLog(@"Reset button pressed.");
        selectedObject = @"None";
	}];
	
    CCMenu *menu = [CCMenu menuWithItems:selectBallButton, selectRampButton, unSelectButton, nil];
	
	[menu alignItemsVertically];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
    
	[menu setPosition:ccp(size.width/8, size.height/2)];
	
	
	[self addChild: menu z:-1];
}

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Inventory touch began");
    
    CGPoint location = [touch locationInView:[touch view]];
    // drop ball in physics layer
    
    if (CGRectContainsPoint(self.boundingBox, location))
    {
        return YES;
    }
    
    return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Inventory touch ended");
}

-(NSString*) getObjectType{
    return selectedObject;
}

@end

