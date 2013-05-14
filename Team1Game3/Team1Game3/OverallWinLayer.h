//
//  OverallWinLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/11/13.
//
//

#ifndef OVERALL_WIN_LAYER_INCLUDED
#define OVERALL_WIN_LAYER_INCLUDED 1

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "CCLayer.h"

@interface OverallWinLayer : CCLayer



/* scene:
 * returns a CCScene containing LevelSelectorLayer as the only child
 */
+(CCScene *) scene;

@end

#endif  // OVERALL_WIN_LAYER_INCLUDED