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
    
    id _target;
    SEL _selector;
}

-(NSString*) getSelectedObject;

-(void) setTarget:(id) sender atAction:(SEL)action;

@end
