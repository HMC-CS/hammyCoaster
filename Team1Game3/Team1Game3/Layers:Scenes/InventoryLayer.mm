//
//  InventoryLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import "InventoryLayer.h"
#import "SpriteResizingFunctions.h"

@implementation InventoryLayer


-(id) initWithItems:(NSArray *)items
{
    NSAssert1(items, @"Items array %@ given to InventoryLayer is null.", items);
    
	if (self = [super init]) {
		
        CGSize size = [CCDirector sharedDirector].winSize;
		
		self.isTouchEnabled = YES;
        
        // By default, no inventory object is selected.
        _selectedObject = @"None";
		
        // Inventory is in the first fourth of the screen
        [self setContentSize:CGSizeMake(size.width*0.25, size.height)];
        [self setPosition:ccp(0,0)];
        
        _items = items;
        
		// Create inventory menu buttons
		[self createMenu];
	}
	return self;
}


-(NSString*) getSelectedObject
{
    // Search for the appropriate button
    for (int i=0; i < [buttonArray count]; ++i) {
        
        CCMenuItemImage *button = buttonArray[i];
        NSString* objectType = (NSString*) button.userData;
        
        // Found the correct button
        if ([_selectedObject isEqualToString:objectType]) {
            
            // No more objects available to add
            if (button.tag == 0) {
                return @"None";
            } else {
                // Decrease object count
                button.tag = button.tag - 1;
                
                // Remove old label.  Note: cleanup removed for ARC.
                [button removeChildByTag:NSIntegerMin cleanup:NO]; 
                
                // Add new number label in fromt of button
                CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", button.tag] fontName:@"Marker Felt" fontSize:button.contentSize.width*.4];
                [numLabel setColor:ccWHITE];
                [numLabel setPosition:ccp(button.contentSize.width/2, button.contentSize.height/2)];
                [button addChild:numLabel z:0 tag:NSIntegerMin];
                
                // Let user know which object is selected
                return _selectedObject;
            }
        }
    }
    
    // If the button isn't found, return the previously selected object.
    return _selectedObject;    
}


- (void) increaseInventoryForType:(NSString*) type
{
    // Search for the appropriate button
    for (int i=0; i < [buttonArray count]; ++i) {
        
        CCMenuItemImage *button = buttonArray[i];
        NSString* objectType = (NSString*) button.userData;
        
        // Found the correct button
        if ([type isEqualToString:objectType]) {
            
            // Increase number of object available
            button.tag = button.tag + 1;
            
            // Remove old label.  Note: cleanup removed for ARC.
            [button removeChildByTag:NSIntegerMin cleanup:NO];
            
            // Add new number label in front of button.
            CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", button.tag] fontName:@"Marker Felt" fontSize:button.contentSize.width*.4];
            [numLabel setColor:ccWHITE];
            [numLabel setPosition:ccp(button.contentSize.width/2, button.contentSize.height/2)];
            [button addChild:numLabel z:1 tag:NSIntegerMin];
            
            break;
        }
    }
}


/* ////////////////////////////// Private Functions ////////////////////////////// */


/* createMenu:
 * Creates all the buttons in InventoryLayer
 */
-(void) createMenu
{
	CGSize size = [[CCDirector sharedDirector] winSize];
    
	[CCMenuItemFont setFontSize:22];

    _inventoryMenu = [CCMenu node];
    buttonArray = [[NSMutableArray alloc] init];
    
    for (NSArray* item in _items) {
        
        // Get type and number of each inventory item
        NSString* type = [item objectAtIndex:0];
        NSNumber* numItems = [item objectAtIndex:1];
        // 0 indicates active object and 1 indicates inactive object
        NSString* activeObject =[item objectAtIndex:2];
        
        // Get picture for inventory button
        NSString* buttonSprite = [[NSString alloc] initWithFormat:@"%@.png", type];
        CCSprite* normal = [CCSprite spriteWithFile:buttonSprite];
        CCSprite* selected = [CCSprite spriteWithFile:buttonSprite];
        [SpriteResizingFunctions setSpriteSize:normal InLayer:self WithSize:.7f];
        [SpriteResizingFunctions setSpriteSize:selected InLayer:self WithSize:.7f];
        selected.color = ccc3(255,255,0);
        if ([activeObject isEqualToString:@"false"])
        {
            normal.color = ccc3(84,84,84);
        }
        if ([type isEqualToString:@"MagnetObject"])
        {
            [SpriteResizingFunctions setSpriteSize:normal InLayer:self WithSize:.5f];
            [SpriteResizingFunctions setSpriteSize:selected InLayer:self WithSize:.5f];
            normal.contentSize = normal.boundingBox.size;
            
        }
        
        // Set inventory button atrributes
        CCMenuItemSprite* inventoryButton = [CCMenuItemSprite itemWithNormalSprite:normal selectedSprite:selected];
        inventoryButton.tag = [numItems intValue];
        inventoryButton.userData = (__bridge void*) type;
        [buttonArray addObject:inventoryButton];
        
        // Put a label displaying the number of items left on the button
        CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", inventoryButton.tag] fontName:@"Marker Felt" fontSize:inventoryButton.contentSize.width*.4];
        [numLabel setColor:ccWHITE];
        [numLabel setPosition:ccp(inventoryButton.contentSize.width/2, inventoryButton.contentSize.height/2)];
        [inventoryButton addChild:numLabel z:1 tag:NSIntegerMin];
        
        // Add button to menu
        [_inventoryMenu addChild:inventoryButton];
        
    }
    
    // Format the inventory menu
    [_inventoryMenu alignItemsVerticallyWithPadding:10.0f];
    [_inventoryMenu setPosition:ccp(size.width/8, size.height/2)];
    _inventoryMenu.isTouchEnabled = false;
    [self addChild: _inventoryMenu z:2];
    
}


/* ////////////////////////////// Touch Functions ////////////////////////////// */


/* registerWithTouchDispacher
 * Initializes touches for InventoryLayer. Makes it "swallow"
 * touches so no layer below it in the scene will feel them.
 */
-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:NO];
}


/* ccTouchBegan:
 * Deals with touch-downs within InventoryLayer.
 * Does not deal with sensing menu item button presses specifically
 */
-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    CGPoint location = [touch locationInView:[touch view]];
    
    // If the touch is in the inventory
    if (CGRectContainsPoint(self.boundingBox, location)) {
        
        // Convert the touch to the same coordinate system as the sprites
        location = [[CCDirector sharedDirector] convertToGL:location];
        location = [self convertToNodeSpace:location];
        location = [_inventoryMenu convertToNodeSpace:location];
        
        // For each sprite, check if the touch was in that sprite. If it was, pass it on to the physics layer.
        for (int i = 0; i < [[_inventoryMenu children] count]; i++) {
            CCMenuItemSprite* sprite = [[_inventoryMenu children] objectAtIndex:i];
            if (CGRectContainsPoint([sprite boundingBox], location)) {
                _selectedObject = static_cast<NSString*>(sprite.userData);
                return NO;
            }
        }
        
        // Otherwise, there is no selected object
        _selectedObject = @"None";
        return YES;
    }
    
    // Otherwise, there is no selected object
    _selectedObject = @"None";
    return NO;
}


/* ccTouchEnded:
 * Deals with touch-ups within InventoryLayer.
 * Does not deal with sensing menu item button presses specifically
 */
-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Nothing to be done here.
}

@end

