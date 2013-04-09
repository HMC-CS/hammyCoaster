//
//  WinLayer.h
//  Team1Game3
//
//  Created by jarthur on 3/30/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

// TODO: comment back in if multiple level sets added
//#import "CCScrollLayer.h"

@interface WinLayer : CCLayer {
    int _stars;
    int _level;
    
}

/* scene:
 * returns a CCScene containing LevelSelectorLayer as the only child
 */
+(CCScene *) scene;

-(id) initWithLevel: (int) level AndStarCount: (int) stars;

@end
