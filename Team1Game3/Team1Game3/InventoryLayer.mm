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

/* createMenu:
 * creates all the buttons in InventoryLayer
 */
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
        [_target performSelector:_selector1];
        // stick a ball on the screen at starting position;
	}];
    
    // Reset Button: Gets rid of all non-default items in level
    // for now, just selects nothing so you can click freely
    CCMenuItemLabel *resetButton = [CCMenuItemFont itemWithString:@"Reset" block:^(id sender){
		NSLog(@"Reset button pressed.");
        // reset level; currently just redraw everything
        [_target performSelector:_selector2];
	}];
    
    CCMenu *gameMenu = [CCMenu menuWithItems: playButton, resetButton, nil];
    [gameMenu alignItemsHorizontallyWithPadding:25];
    [gameMenu setPosition:ccp(size.width/8, size.height*3/4)];
    [self addChild: gameMenu z:-1];
    
    /* Inventory Menu:
     * The menu of inventory items.
     * ---------------------------------------------------------------------- */

    // Makes a ramp when you click
    CCMenuItemLabel *selectRampButton = [CCMenuItemFont itemWithString:@"Add a ramp!" block:^(id sender){
		NSLog(@"Add a ramp! button pressed.");
        selectedObject = @"RampObject";
	}];
    //selects nothing so you can click freely
    CCMenuItemLabel *unSelectButton = [CCMenuItemFont itemWithString:@"Rearrange" block:^(id sender){
		NSLog(@"Rearrange button pressed.");
        selectedObject = @"None";
	}];
	
//    CCMenu *inventoryMenu = [CCMenu menuWithItems:selectBallButton, selectRampButton, unSelectButton, nil];	
    CCMenu *inventoryMenu = [CCMenu menuWithItems:selectRampButton, unSelectButton, nil];
	[inventoryMenu alignItemsVertically];
	[inventoryMenu setPosition:ccp(size.width/8, size.height/2)];
	[self addChild: inventoryMenu z:-1];
}

/* registerWithTouchDispacher:
 * Initializes touches for InventoryLayer. Makes it "swallow"
 * touches so no layer below it in the scene will feel them.
 */
-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

/* ccTouchBegan:
 * guaranteed name. Deals with touch-downs within InventoryLayer.
 * Does not deal with sensing menu item button presses specifically
 */
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

/* ccTouchEnded:
 * guaranteed name. Deals with touch-ups within InventoryLayer.
 * Does not deal with sensing menu item button presses specifically
 */
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Inventory touch ended");
    [_target performSelector:_selector1]; //selector one is playPhysicsLevel
}

/* dealloc:
 * deallocates everything in InventoryLayer
 */
-(void) dealloc
{
    
	[super dealloc];
}

// public functions, documented in InventoryLayer.h

-(NSString*) getSelectedObject {
    return selectedObject;
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    } else {
        _selector2 = action;
    }
}

@end

