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
    NSAssert1(items, @"Items array %@ given to InventoryLayer is null.", items);
    
	if( (self=[super init])) {
		
		// enable events
        
        CGSize size = [CCDirector sharedDirector].winSize;
		
		self.isTouchEnabled = YES;
        
        _selectedObject = [[NSString alloc] initWithFormat:@"None"];
		
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
    buttonArray = [[NSMutableArray alloc] init];
    
    for (NSArray* item in _items) {
        NSString* type = [item objectAtIndex:0];
        //NSString* label = [item objectAtIndex:1];
        NSNumber* numItems = [item objectAtIndex:2];   // Number of inventory items, when needed
        NSString* buttonLabel = [[NSString alloc] initWithFormat:@"%@Icon.png", type];
        CCSprite *normal = [CCSprite spriteWithFile:buttonLabel];
        CCSprite *selected = [CCSprite spriteWithFile:buttonLabel];
        selected.color = ccc3(255,255,0);
        //selected.color = ccc3(255,255,255);

        
        CCMenuItemSprite *inventoryButton = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected block:^(id sender) {
            
            for (int i= 0; i < [buttonArray count];i++)
            {
                CCMenuItemSprite *button = buttonArray[i];
                NSString* objectType = (NSString*) button.userData;
                if ([_selectedObject isEqualToString:objectType])
                {
                    [button unselected];
                }
            }

            _selectedObject = type;
            [(CCMenuItemSprite*)sender selected];
            
        }];
        
        inventoryButton.tag = [numItems intValue];
        inventoryButton.userData = type;
        [buttonArray addObject:inventoryButton];
        
        CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", inventoryButton.tag] fontName:@"Marker Felt" fontSize:inventoryButton.contentSize.width*.4];
        [numLabel setColor:ccWHITE];
        [numLabel setPosition:ccp(inventoryButton.contentSize.width/2, inventoryButton.contentSize.height/2)];
        [inventoryButton addChild:numLabel z:1 tag:NSIntegerMin];
        
        [inventoryMenu addChild:inventoryButton];
    }
    
    
    [inventoryMenu alignItemsVerticallyWithPadding:10.0f];
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
    // NSLog(@"Inventory touch began");
    
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
    // NSLog(@"Inventory touch ended");
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
    for (int i= 0; i< [buttonArray count];i++)
    {
        CCMenuItemImage *button = buttonArray[i];
        NSString* objectType = (NSString*) button.userData;
        if ([_selectedObject isEqualToString:objectType] && ![_selectedObject isEqualToString:@"Delete"])
        {
            if (button.tag == 0)
            {
                return @"None";
            }
            else
            {
                button.tag = button.tag -1;
                
                // remove old label
                [button removeChildByTag:NSIntegerMin cleanup:YES];
                
                // add new label
                CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", button.tag] fontName:@"Marker Felt" fontSize:button.contentSize.width*.4];
                [numLabel setColor:ccWHITE];
                [numLabel setPosition:ccp(button.contentSize.width/2, button.contentSize.height/2)];
                [button addChild:numLabel z:1 tag:NSIntegerMin];
            
                return _selectedObject;
            }
        }
    }
    return _selectedObject;
    
}


-(bool) isDeleteSelected
{
    //    NSLog(@"%@ should be the object", _selectedObject);
    if ([_selectedObject isEqualToString:@"Delete"])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void) increaseInventoryForType:(NSString*) type
{
    for (int i= 0; i< [buttonArray count];i++)
    {
        CCMenuItemImage *button = buttonArray[i];
        NSString* objectType = (NSString*) button.userData;

        if ([type isEqualToString:objectType])
        {
            button.tag = button.tag+1;
            NSLog(@"we actually increased object");
            
            // remove old label
            [button removeChildByTag:NSIntegerMin cleanup:YES];
            
            // add new label
            CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", button.tag] fontName:@"Marker Felt" fontSize:button.contentSize.width*.4];
            [numLabel setColor:ccWHITE];
            [numLabel setPosition:ccp(button.contentSize.width/2, button.contentSize.height/2)];
            [button addChild:numLabel z:1 tag:NSIntegerMin];
            
            break;
        }
    }
}

@end

