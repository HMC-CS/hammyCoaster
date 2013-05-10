//
//  LevelSelectorLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/30/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameManager.h"

// TODO: comment back in if multiple level sets added
//#import "CCScrollLayer.h"

@interface LevelSelectorLayer : CCLayer {

//    CCScrollLayer* _scroller;   // TODO: comment back in if multiple level sets added
    
    GameManager* _gameManager;
    
}

/* scene:
 * returns a CCScene containing LevelSelectorLayer as the only child
 */
+(CCScene *) scene;

@end
