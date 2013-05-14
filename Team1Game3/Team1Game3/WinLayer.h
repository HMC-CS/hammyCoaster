//
//  WinLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/30/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#ifndef WIN_LAYER_INCLUDED
#define WIN_LAYER_INCLUDED 1

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "AppController.h"
#import "GameManager.h"


@interface WinLayer : CCLayer {
    
    int _stars;                     // Number of stars obtained in level
    int _levelSet;                  // The level set
    int _levelIndex;                // The level index
    
    GameManager* _gameManager;      // GameManager (holds game data)
}


/* sceneWithLevelSet:AndIndex:AndStarCount:
 * Returns a CCScene containing LevelSelectorLayer as the only child
 */
+(CCScene *) sceneWithLevelSet: (int) levelSet AndIndex: (int) levelIndex AndStarCount: (int) stars;


/* initWithLevelSet:AndIndex:AndStarCount:
 * Constructor for WinLayer
 */
-(id) initWithLevelSet: (int) levelSet AndIndex: (int) levelIndex AndStarCount: (int) stars;

@end

#endif  // WIN_LAYER_INCLUDED
