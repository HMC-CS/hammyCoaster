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
    SEL _selector1; // Play Button Pressed
    SEL _selector2; // Reset Ball
    SEL _selector3; // Reset Level
    
    CCLabelTTF* _starLabel;
    CCLabelTTF* _bestStarLabel;
    
    int _bestStars;
    
}

@property (readonly) int starCount;

/* initWithHighScore:
 * initializes Gameplay Layer with level high score
 */
-(id) initWithHighScore:(int) stars;

/* setTarget: atAction:
 * guaranteed name for function to initialize selectors and target
 */
-(void) setTarget:(id) sender atAction:(SEL)action;

/* updateStarCount:
 * increments the star counter when the ball hits a star
 */
-(void) updateStarCount;

@end
