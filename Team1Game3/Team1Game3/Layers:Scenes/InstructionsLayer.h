//
//  InstructionsLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley on 4/15/13.
//
//

#ifndef INSTRUCTIONS_LAYER_INCLUDED
#define INSTRUCTIONS_LAYER_INCLUDED 1

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "CCLayer.h"
#import "CCScrollLayer.h"


@interface InstructionsLayer : CCLayer {
    
    CCScrollLayer* _scroller;
}

/* scene:
 * returns a CCScene that contains the MainMenuLayer as the only child
 */
+(CCScene *) scene;

@end

#endif  // INSTRUCTIONS_LAYER_INCLUDED