//
//  GameplayLayer.h
//  Team1Game3
//
//  Created by jarthur on 4/8/13.
//
//

#import "CCLayer.h"

#import "cocos2d.h"

@interface GameplayLayer : CCLayer {
    
    id _target;
    SEL _selector1; //getSelectedObject
    SEL _selector2; //gameWon
    
    int _starCount;
    CCLabelTTF* _starLabel;
    
}

-(void) setTarget:(id) sender atAction:(SEL)action;

-(void) updateStarCount;

-(void) resetStarCount;

@end
