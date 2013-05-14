//
//  GameplayLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/8/13.
//
//

#ifndef GAMEPLAY_LAYER_INCLUDED
#define GAMEPLAY_LAYER_INCLUDED 1

#import "CCLayer.h"
#import "cocos2d.h"

@interface GameplayLayer : CCLayer {
    
    id _target;     // Level Layer
    SEL _selector1; // Play button pressed
    SEL _selector2; // Reset ball
    SEL _selector3; // Reset level
    
    CCLabelTTF* _starLabel;         // Displays number of stars user has gotten in level
    CCLabelTTF* _bestStarLabel;     // Displays high score
    int _starCount;                 // Number of stars user has gotten
    int _bestStars;                 // High score
    
    CGPoint _startButtonLocation;   // Location for start portal (and ball starting point)
    
    CCMenuItemToggle* _playResetToggle;     // Toggle for button on start portal
}


@property (readonly) int starCount;
@property (readonly) CCMenuItemToggle* playResetToggle;


/* initWithHighScore:
 * initializes Gameplay Layer with level high score
 */
-(id) initWithHighScore:(int) stars AndStartButtonLocation:(CGPoint) startButtonPoint;


/* setTarget:AtAction:
 * guaranteed name for function to initialize selectors and target
 */
-(void) setTarget:(id) sender AtAction:(SEL)action;


/* updateStarCount
 * increments the star counter when the ball hits a star
 */
-(void) updateStarCount;

@end

#endif  // GAMEPLAYER_LAYER_INCLUDED
