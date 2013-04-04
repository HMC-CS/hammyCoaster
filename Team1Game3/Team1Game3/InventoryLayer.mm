//
//  InventoryLayer.m
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "InventoryLayer.h"

@implementation InventoryLayer


-(id) initWithItems:(NSArray *)items
{
	if( (self=[super init])) {
		
		// enable events
        
        CGSize size = [CCDirector sharedDirector].winSize;
		
		self.isTouchEnabled = YES;
        
        selectedObject = [[NSString alloc] initWithFormat:@"None"];
		
        [self setContentSize:CGSizeMake(size.width*0.25, size.height)];
        [self setPosition:ccp(0,0)];
        
        _items = items;
        
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
    //CCMenu *inventoryMenu = [CCMenu menuWithItems:selectRampButton, nil];
    CCMenu *inventoryMenu = [CCMenu node];
    
    for (NSArray* item in _items) {
        NSString* type = [item objectAtIndex:0];
        NSString* label = [item objectAtIndex:1];
        // int numItems = [[item objectAtIndex:2] intValue];   // Number of inventory items, when needed
        
        NSString* buttonLabel = [[NSString alloc] initWithFormat:@"%@Icon.png", label];

        CCMenuItemImage *inventoryButton = [CCMenuItemImage itemFromNormalImage:buttonLabel selectedImage:buttonLabel disabledImage:buttonLabel block:^(id sender)
        {
            //CCMenuItemImage *button = (CCMenuItemImage *)sender;
        
        //CCMenuItemLabel *inventoryButton = [CCMenuItemFont itemWithString:buttonLabel //block:^(id sender){
            selectedObject = type;
    }];

        [inventoryMenu addChild:inventoryButton];
    }
    CCMenuItemLabel *deleteButton = [CCMenuItemFont itemWithString:@"Delete object" block:^(id sender)
        {
        selectedObject = @"Delete";
    }];
    [inventoryMenu addChild:deleteButton];
    
    [inventoryMenu alignItemsVertically];
    [inventoryMenu setPosition:ccp(size.width/8, size.height/2)];
    [self addChild: inventoryMenu z:-1];

    
    /* Inventory Menu:
     * The menu of inventory items.
     * ---------------------------------------------------------------------- */

//    // Makes a ramp when you click
//    CCMenuItemLabel *selectRampButton = [CCMenuItemFont itemWithString:@"Add a ramp!" block:^(id sender){
//		NSLog(@"Add a ramp! button pressed.");
//        selectedObject = @"RampObject";
//	}];
//    
//    // Lets you delete objects you've placed
//    CCMenuItemLabel *deleteButton = [CCMenuItemFont itemWithString:@"Delete object" block:^(id sender)
//        {
//        NSLog(@"Delete button pressed.");
//        selectedObject = @"Delete";
//    }];
	 
//    CCMenu *inventoryMenu = [CCMenu menuWithItems:selectRampButton, nil];
//	[inventoryMenu alignItemsVertically];
//	[inventoryMenu setPosition:ccp(size.width/8, size.height/2)];
//	[self addChild: inventoryMenu z:-1];
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
    //[_target performSelector:_selector1]; //selector one is playPhysicsLevel
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

// //TODO: comment back in if need be
//-(void) setTarget:(id) sender atAction:(SEL)action
//{
//    _target = sender;
//    if (!_selector1) {
//        _selector1 = action;
//    } else {
//        _selector2 = action;
//    }
//}

@end

