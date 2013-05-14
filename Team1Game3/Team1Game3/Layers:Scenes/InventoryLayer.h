//
//  InventoryLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#ifndef INVENTORY_LAYER_INCLUDED
#define INVENTORY_LAYER_INCLUDED 1

#import "CCLayer.h"
#import "Cocos2d.h"

@interface InventoryLayer : CCLayer {
    
    NSString* _selectedObject;      // Object selected for addition into physics layer
    NSMutableArray* buttonArray;    // Array of objects available
    NSArray* _items;                // Initial items in inventory (with counts)
    CCMenu* _inventoryMenu;         // Displayed buttons
   
}

/* initWithItems:
 * Initializes an inventory layer of level Set-Index
 */
-(id) initWithItems:(NSArray*) items;


/* getSelectedObject
 * Returns NSString* of the selected object type
 * Also decreases the amount of available items of type "type" by 1
 */
-(NSString*) getSelectedObject;


/* increaseInventoryForType:
 * Increases the amount of available items of type "type" by 1
 */
- (void) increaseInventoryForType:(NSString*) type;

@end

#endif  // INVENTORY_LAYER_INCLUDED
