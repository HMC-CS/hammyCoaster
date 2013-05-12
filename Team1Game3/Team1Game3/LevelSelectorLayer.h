//
//  LevelSelectorLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/30/13.
//  Copyright 2013 CS121:Team 1 Physics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "AppController.h"
#import "GameManager.h"

#import "CCScrollLayer.h"

@interface LevelSelectorLayer : CCLayer {

    CCScrollLayer* _scroller;
    
    GameManager* _gameManager;
    
}


/* scene:
 * returns a CCScene containing LevelSelectorLayer as the only child
 */
+(CCScene *) scene;

@end
