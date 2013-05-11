//
//  InventoryLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#import "CCLayer.h"
#import "Cocos2d.h"

@interface InventoryLayer : CCLayer {
    
    NSString* _selectedObject;
    
    NSMutableArray* buttonArray;
    
    NSArray* _items;
    
    CCMenu* _inventoryMenu;
   
}

/* initWithItems:
 * Initializes an inventory layer of level Set-Index
 */
-(id) initWithItems:(NSArray*) items;

/* getSelectedObject:
 * returns NSString* of the selected object type
 */
-(NSString*) getSelectedObjectForAddingNewObject:(bool) isAddingNewObject;

-(bool) isDeleteSelected;



- (void) increaseInventoryForType:(NSString*) type;

@end
