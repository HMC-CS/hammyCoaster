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
	CGSize size = [[CCDirector sharedDirector] winSize];
    
	// Default font size will be 22 points.
	[CCMenuItemFont setFontSize:22];
    
    /*
     * Game Menu:
     * The menu with the "action" type buttons, as opposed to inventory items.
     * -------------------------------------------------------------------------
     */
    
     // Play Button: drops ball
    CCMenuItemLabel *playButton = [CCMenuItemFont itemWithString:@"Get the Ball Rolling!" block:^(id sender){
		NSLog(@"Play button pressed.");
        // stick a ball on the screen at starting position;
	}];
    
    // Reset Button: Gets rid of all non-default items in level
    // for now, just selects nothing so you can click freely
    CCMenuItemLabel *resetButton = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		NSLog(@"Reset button pressed.");
        // delete all non-default objects;
        [_target performSelector:_selector2];
	}];
    
    CCMenu *gameMenu = [CCMenu menuWithItems: playButton, resetButton, nil];
    [gameMenu alignItemsHorizontallyWithPadding:25];
    [gameMenu setPosition:ccp(size.width/8, size.height*3/4)];
    [self addChild: gameMenu z:-1];
    
    /*
     * Inventory Menu:
     * The menu of inventory items.
     * -------------------------------------------------------------------------
     */
    
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
    CCMenuItemLabel *unSelectButton = [CCMenuItemFont itemWithString:@"Un-Select Button" block:^(id sender){
		NSLog(@"Un-Select button pressed.");
        selectedObject = @"None";
	}];
	
    CCMenu *inventoryMenu = [CCMenu menuWithItems:selectBallButton, selectRampButton, unSelectButton, nil];	
	[inventoryMenu alignItemsVertically];
	[inventoryMenu setPosition:ccp(size.width/8, size.height/2)];
	[self addChild: inventoryMenu z:-1];
}

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Inventory touch began");
    
    CGPoint location = [touch locationInView:[touch view]];
    
    if (CGRectContainsPoint(self.boundingBox, location))
    {
        return YES;
    }
    
    return NO;
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Inventory touch ended");
    [_target performSelector:_selector1];
}

-(NSString*) getSelectedObject {
    return selectedObject;
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else {
        _selector2 = action;
    }
}

@end

