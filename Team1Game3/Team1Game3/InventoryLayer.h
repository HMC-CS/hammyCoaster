//
//  InventoryLayer.h
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "CCLayer.h"
#import "Cocos2d.h"

#import "LevelGenerator.h"

@interface InventoryLayer : CCLayer {
    
    NSString* selectedObject;
    
    LevelGenerator* _levelGenerator;
    
    int _levelSet;
    int _levelIndex;

// TODO: comment back in if need be
//    id _target;
//    SEL _selector1; // play
//    SEL _selector2; // reset
}

/* initWithLevelSet:AndIndex:
 * Initializes a physics layer of level Set-Index
 */
-(id) initWithLevelSet:(int) set AndIndex:(int) index;

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
