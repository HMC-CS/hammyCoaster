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
        NSNumber* numItems = [item objectAtIndex:2];   // Number of inventory items, when needed
        
//        NSString* buttonLabel = [[NSString alloc] initWithFormat:@"%@Icon.png", label];
//        NSString* selectedButtonLabel = [[NSString alloc] initWithFormat:@"%@IconSelected.png", label];
        NSString* buttonLabel = [[NSString alloc] initWithFormat:@"%@Icon.png", type];
        NSString* selectedButtonLabel = [[NSString alloc] initWithFormat:@"%@IconSelected.png", type];
        CCSprite *normal = [CCSprite spriteWithFile:buttonLabel];
        CCSprite *selected = [CCSprite spriteWithFile:buttonLabel];
        selected.color = ccc3(125,125,125);
        // and/or:
        //selected.scale = 1.2;
        
        CCMenuItemImage *inventoryButton = [CCMenuItemImage itemFromNormalSprite:normal selectedSprite:selected  target:self selector:@selector(buttonPressed:)];//block:^(id sender)

        //CCMenuItemImage *inventoryButton = [CCMenuItemImage itemFromNormalImage:buttonLabel selectedImage:selectedButtonLabel disabledImage:buttonLabel block:^(id sender)
        //{
            //CCMenuItemImage *button = (CCMenuItemImage *)sender;
        
        //CCMenuItemLabel *inventoryButton = [CCMenuItemFont itemWithString:buttonLabel //block:^(id sender){
//            if ([(NSNumber*) inventoryButton.userData intValue] == 0)
//            {
//              selectedObject = [[NSString alloc] initWithFormat:@"None"];
//                NSLog(@"No More Objects");
//            }
//            else
//            {
                //selectedObject = type;
//                inventoryButton.userData = [NSNumber numberWithInt:([(NSNumber*) inventoryButton.userData intValue] - 1)];
//                NSLog(@"Button Pressed");
//            }
        
//}];
        inventoryButton.userData = numItems;
        NSLog(@"Setting User Data");
        
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
}


- (void) buttonPressed: (id) sender
    {
        for (NSArray* item in _items) {
            NSString* type = [item objectAtIndex:0];
            //NSNumber* numItems = [item objectAtIndex:2];
        CCMenuItemLabel* inventoryButton = sender;
            //inventoryButton.userData = numItems;
        if ([(NSNumber*) inventoryButton.userData intValue] == 0)
         {
             selectedObject = [[NSString alloc] initWithFormat:@"None"];
             NSLog(@"No More Objects");
         }
        else
        {
            selectedObject = type;
            inventoryButton.userData = [NSNumber numberWithInt:([(NSNumber*) inventoryButton.userData intValue] - 1)];
            NSLog(@"is the user data");
            [inventoryButton  setColor: ccc3(125,125,125)];
       }
        }
    }
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
//    target = sender;
//    selector = action;
////    _target = sender;
////    if (!_selector1) {
////        _selector1 = action;
////    } else {
////        _selector2 = action;
////    }
//}

@end

