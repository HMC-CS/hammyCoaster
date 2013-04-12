//
//  InventoryLayer.h
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "CCLayer.h"
#import "Cocos2d.h"

@interface InventoryLayer : CCLayer {
    
    NSString* _selectedObject;
    
    NSMutableArray* buttonArray;
    
    NSArray* _items;
}

/* initWithItems:
 * Initializes an inventory layer of level Set-Index
 */
-(id) initWithItems:(NSArray*) items;

/* getSelectedObject:
 * returns NSString* of the selected object type
 */
-(NSString*) getSelectedObject;
-(bool) isDeleteSelected;
- (void) increaseInventoryForType:(NSString*) type;
///* resetInventory:
// * resets inventory for the level
// */
//-(void) resetInventory;


@end
