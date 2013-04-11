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
//        
//        NSString* buttonLabel = [[NSString alloc] initWithFormat:@"%@Icon.png", label];
//        NSString* selectedButtonLabel = [[NSString alloc] initWithFormat:@"%@IconSelected.png", label];
        NSString* buttonLabel = [[NSString alloc] initWithFormat:@"%@Icon.png", type];
//        NSString* selectedButtonLabel = [[NSString alloc] initWithFormat:@"%@IconSelected.png", type];
       CCSprite *normal = [CCSprite spriteWithFile:buttonLabel];
        CCSprite *selected = [CCSprite spriteWithFile:buttonLabel];
        selected.color = ccc3(125,125,125);
        // and/or:
        //selected.scale = 1.2;
        
//        CCMenuItemImage* inventoryButton = [CCMenuItemImage itemWithNormalImage:[[NSString alloc] initWithFormat:@"%@Icon.png", type] selectedImage:[[NSString alloc] initWithFormat:@"%@IconSelected.png", type] target:self selector:@selector(buttonPressed:)];
        
        //CCMenuItemImage* inventoryButton = [CCMenuItemImage itemWithNormalImage:[[NSString alloc] initWithFormat:@"%@Icon.png", type] selectedImage:[[NSString alloc] initWithFormat:@"%@IconSelected.png", type] disabledImage:[[NSString alloc] initWithFormat:@"%@IconSelected.png", type] block:^(id sender) {
                //_selectedObject = type;
        //}];
        
        CCMenuItemImage *inventoryButton = [CCMenuItemImage itemFromNormalSprite:normal selectedSprite:selected block:^(id sender) { //selector:@selector(buttonPressed:)];
//
//            __selectedObject = type;

        //CCMenuItemImage *inventoryButton = [CCMenuItemImage itemFromNormalImage:buttonLabel selectedImage:selectedButtonLabel disabledImage:buttonLabel block:^(id sender)
        //{
            //CCMenuItemImage *button = (CCMenuItemImage *)sender;
        
        //CCMenuItemLabel *inventoryButton = [CCMenuItemFont itemWithString:buttonLabel //block:^(id sender){
//            if ([(NSNumber*) inventoryButton.userData intValue] == 0)
//            {
//              _selectedObject = [[NSString alloc] initWithFormat:@"None"];
//                NSLog(@"No More Objects %@ is the User Data", inventoryButton.userData);
//           }
//            else
//           {
             _selectedObject = type;
            //inventoryButton.userData = [NSNumber numberWithInt:([(NSNumber*) inventoryButton.userData intValue] - 1)];
//               inventoryButton.tag = inventoryButton.tag-1;
//                NSLog(@"Button Pressed %@ is the User Data", inventoryButton.userData);
//            }
        
}];
        inventoryButton.tag = [numItems intValue];
        inventoryButton.userData = type;
        [buttonArray addObject:inventoryButton];
        //NSString* tagVar = type;
        //inventoryButton.tag = [tagVar intValue];
        NSLog(@"%@ is User Data", numItems);
        
        CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", inventoryButton.tag] fontName:@"Marker Felt" fontSize:inventoryButton.contentSize.width*.4];
        [numLabel setColor:ccWHITE];
        [numLabel setPosition:ccp(inventoryButton.contentSize.width/2, inventoryButton.contentSize.height/2)];
        [inventoryButton addChild:numLabel z:1 tag:NSIntegerMin];
        
        [inventoryMenu addChild:inventoryButton];
    }
    
    CCMenuItemLabel *deleteButton = [CCMenuItemFont itemWithString:@"Delete object" block:^(id sender)
        {
        _selectedObject = @"Delete";
    }];
    [inventoryMenu addChild:deleteButton];
    
    [inventoryMenu alignItemsVertically];
    [inventoryMenu setPosition:ccp(size.width/8, size.height/2)];
    [self addChild: inventoryMenu z:-1];
}

//        for (NSArray* item in _items) {
//            NSString* type = [item objectAtIndex:0];
//            //NSNumber* numItems = [item objectAtIndex:2];
//        CCMenuItemLabel* inventoryButton = sender;
//            //inventoryButton.userData = numItems;
//        if ([(NSNumber*) inventoryButton.userData intValue] == 0)
//         {
//             _selectedObject = [[NSString alloc] initWithFormat:@"None"];
//             NSLog(@"No More Objects");
//         }
//        else
//        {
//            _selectedObject = type;
//            inventoryButton.userData = [NSNumber numberWithInt:([(NSNumber*) inventoryButton.userData intValue] - 1)];
//            NSLog(@"is the user data");
//            [inventoryButton  setColor: ccc3(125,125,125)];
//       }
//        }
//    }

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
        NSString* buttonLabel = [[NSString alloc] initWithFormat:@"%@Icon.png", button.userData];
        CCSprite *normal = [CCSprite spriteWithFile:buttonLabel];
        CCSprite *selected = [CCSprite spriteWithFile:buttonLabel];
        selected.color = ccc3(125,125,125);
        if ([_selectedObject isEqualToString:objectType])
        {
        NSLog(@"%d is button tag", button.tag);
        if (button.tag == 0)
        {
            NSLog(@"No More! %d is the User Data", button.tag);
            return @"None";
        }
        else
        {
             NSLog(@"Button Pressed %d is the User Data", button.tag);
            button.tag = button.tag -1;
            [button  setNormalImage:selected];
            
            // remove old label
            [button removeChildByTag:NSIntegerMin cleanup:YES];
            
            // add new label
            CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", button.tag] fontName:@"Marker Felt" fontSize:button.contentSize.width*.4];
            [numLabel setColor:ccWHITE];
            [numLabel setPosition:ccp(button.contentSize.width/2, button.contentSize.height/2)];
            [button addChild:numLabel z:1 tag:NSIntegerMin];
            
            //_selectedObject = objectType;
            return _selectedObject;
        }
        }else {
            [button  setNormalImage:normal];
        }
    }
    return _selectedObject;
    
}


-(bool) isDeleteSelected{
//    NSLog(@"%@ should be the object", _selectedObject);
  if (_selectedObject == @"Delete")
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
        if ([_selectedObject isEqualToString:objectType])
        {
            button.tag = button.tag+1;
            
            // remove old label
            [button removeChildByTag:NSIntegerMin cleanup:YES];
            
            // add new label
            CCLabelTTF *numLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", button.tag] fontName:@"Marker Felt" fontSize:button.contentSize.width*.4];
            [numLabel setColor:ccWHITE];
            [numLabel setPosition:ccp(button.contentSize.width/2, button.contentSize.height/2)];
            [button addChild:numLabel z:1 tag:NSIntegerMin];
        }
    }
}

@end

