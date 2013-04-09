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
    
    
    CCLabelTTF* _starLabel;
    
}

@property (readonly) int starCount;

/* setTarget: atAction:
 * guaranteed name for function to initialize selectors and target
 */
-(void) setTarget:(id) sender atAction:(SEL)action;

/* updateStarCount:
 * increments the star counter when the ball hits a star
 */
-(void) updateStarCount;

@end
