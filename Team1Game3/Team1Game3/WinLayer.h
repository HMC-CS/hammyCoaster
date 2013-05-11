//
//  WinLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/30/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "AppDelegate.h"
#import "GameManager.h"

// TODO: comment back in if multiple level sets added
//#import "CCScrollLayer.h"

@interface WinLayer : CCLayer {
    int _stars;
    int _level;
    
    GameManager* _gameManager;
    
}

/* scene:
 * returns a CCScene containing LevelSelectorLayer as the only child
 */
+(CCScene *) sceneWithLevel: (int) level AndStarCount: (int) stars;

-(id) initWithLevel: (int) level AndStarCount: (int) stars;

@end
