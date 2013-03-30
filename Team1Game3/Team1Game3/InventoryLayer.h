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
    
    NSString* selectedObject;

// TODO: comment back in if need be
//    id _target;
//    SEL _selector1; // play
//    SEL _selector2; // reset
}

/* getSelectedObject:
 * returns NSString* of the selected object type
 */
-(NSString*) getSelectedObject;

// TODO: comment back in if need be
///* setTarget: atAction:
// * guaranteed name for function to initialize selectors and target
// */
//-(void) setTarget:(id) sender atAction:(SEL)action;

@end
