//
//  GameManager.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/12/13.
//
//

#import "GameManager.h"

#import "OverallWinLayer.h"

@implementation GameManager

-(id) init
{
    if (self = [super init]) {
        [self loadGame];
        
        _numLevelSets = 1;
        _numLevelIndices = 12;
        
        // the following calls will return the user's individual preferences,
        // if they've made changes. Otherwise, it will just return the values we
        // registered previously. Saves us some hassle!
        _numLevelsCompleted = [_defaults integerForKey:@"levels_complete"];
        //_numLevelsCompleted = 0;
        
        _levelCompletionStatuses = [[NSMutableArray alloc] init];
        _levelHighScores = [[NSMutableArray alloc] init];
        _isLevelLocked = [[NSMutableArray alloc] init];
        for (int i = 0; i < _numLevelSets * _numLevelIndices; ++i)
        {
            bool levelComplete = [_defaults boolForKey:[NSString stringWithFormat:@"level_%d_complete", i]];
            bool levelLocked = [_defaults boolForKey:[NSString stringWithFormat:@"level_%d_locked", i]];
            int levelStars = [_defaults integerForKey:[NSString stringWithFormat:@"level_%d_stars", i]];
            
            NSLog(@"Defaults: level %d complete: %d locked: %d stars:%d", i, levelComplete, levelLocked, levelStars);
            
            // if level is completed according to user settings, set completion true
            if (levelComplete)
                [_levelCompletionStatuses addObject:@"true"];
            // else set false
            else
                [_levelCompletionStatuses addObject:@"false"];
            
            [_levelHighScores addObject:[NSNumber numberWithInt:levelStars]];
            
            if (levelLocked)
            {
                //[_isLevelLocked addObject:@"true"];
                [_isLevelLocked addObject:@"false"];
            }else{
                [_isLevelLocked addObject:@"false"];
            }
        }
    }
    
    return self;
}

-(void) loadGame
{
    // code from http://cocoadev.com/wiki/WorkingWithUserDefaults
    
    _defaults = [NSUserDefaults standardUserDefaults];
    
    [_defaults registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                                 @"0",         @"levels_complete",
                                 @"NO",         @"level_0_locked",
                                 @"NO",         @"level_1_locked",
                                 @"YES",        @"level_2_locked",
                                 @"YES",        @"level_3_locked",
                                 @"YES",        @"level_4_locked",
                                 @"YES",        @"level_5_locked",
                                 @"YES",        @"level_6_locked",
                                 @"YES",        @"level_7_locked",
                                 @"YES",        @"level_8_locked",
                                 @"YES",        @"level_9_locked",
                                 @"YES",        @"level_10_locked",
//                                 @"NO",        @"level_2_locked",
//                                 @"NO",        @"level_3_locked",
//                                 @"NO",        @"level_4_locked",
//                                 @"NO",        @"level_5_locked",
//                                 @"NO",        @"level_6_locked",
//                                 @"NO",        @"level_7_locked",
//                                 @"NO",        @"level_8_locked",
//                                 @"NO",        @"level_9_locked",
//                                 @"NO",        @"level_10_locked",
                                 @"NO",         @"level_11_locked",
                                 @"NO",         @"level_0_complete",
                                 @"NO",         @"level_1_complete",
                                 @"NO",         @"level_2_complete",
                                 @"NO",         @"level_3_complete",
                                 @"NO",         @"level_4_complete",
                                 @"NO",         @"level_5_complete",
                                 @"NO",         @"level_6_complete",
                                 @"NO",         @"level_7_complete",
                                 @"NO",         @"level_8_complete",
                                 @"NO",         @"level_9_complete",
                                 @"NO",         @"level_10_complete",
                                 @"NO",         @"level_11_complete",
                                 @"0",          @"level_0_stars",
                                 @"0",          @"level_1_stars",
                                 @"0",          @"level_2_stars",
                                 @"0",          @"level_3_stars",
                                 @"0",          @"level_4_stars",
                                 @"0",          @"level_5_stars",
                                 @"0",          @"level_6_stars",
                                 @"0",          @"level_7_stars",
                                 @"0",          @"level_8_stars",
                                 @"0",          @"level_9_stars",
                                 @"0",          @"level_10_stars",
                                 @"0",          @"level_11_stars",
                                 nil]];
  
    //[ ... ]
//  
//    int levels_unlocked;
//    int level_1_stars;
//    int level_2_stars;
//    int level_3_stars;
//    int level_4_stars;
//    int level_5_stars;
//    int level_6_stars;
//    int level_7_stars;
//    int level_8_stars;
//    int level_9_stars;
//    int level_10_stars;
//    int level_11_stars;
//    int level_12_stars;
    
    

}

-(void) resetUserData
{
    NSLog(@"resetUserData");
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self loadGame];
    
    //[NSUserDefaults resetStandardUserDefaults];
    //_defaults = [NSUserDefaults standardUserDefaults];
    //[[NSUserDefaults standardUserDefaults] setObject:apikey forKey:@"apiKey"];
    
    
    // haxxx
    //... that also crashes. Yay! TODO: fix it
    
     for (int i = 0; i < _numLevelSets * _numLevelIndices; ++i)
    {
       // NSLog(@"index: %d", i);
//        bool levelComplete = [_defaults boolForKey:@"level_4_complete"];//[_defaults boolForKey:[NSString stringWithFormat:@"level_%d_complete", i]];
//        NSLog(@"got past levelComplete");
//        bool levelLocked = [_defaults boolForKey:[NSString stringWithFormat:@"level_%d_locked", i]];
//        int levelStars = [_defaults integerForKey:[NSString stringWithFormat:@"level_%d_stars", i]];
            
      
      //  [self highScoreAtLevelSet:levelStars AndIndex:i];
    }
    
// end hax
    
}

-(bool) isLevelCompletedAtLevelSet:(int)set AndIndex:(int)index
{
    NSAssert1(set > 0 && set <= _numLevelSets, @"Invalid set index %d given in AppController.", set);
    NSAssert1(index > 0 && index <= _numLevelIndices, @"Invalid level index %d given in AppController.", index);
    
    if ([[_levelCompletionStatuses objectAtIndex:(set-1)*_numLevelIndices + (index-1)] isEqualToString:@"true"]) {
        return YES;
    } else {
        return NO;
    }
}

-(void) registerCompletedLevelWithLevelSet:(int)set AndIndex:(int)index AndStarCount:(int)stars
{
    NSAssert1(set > 0 && set <= _numLevelSets, @"Invalid set index %d given in AppController.", set);
    NSAssert1(index > 0 && index <= _numLevelIndices, @"Invalid level index %d given in AppController.", index);
    
    if (stars > [[_levelHighScores objectAtIndex:(set-1)*_numLevelIndices + (index-1)] intValue]) {
        [_levelHighScores setObject:[NSNumber numberWithInt:stars] atIndexedSubscript:(set-1)*_numLevelIndices + (index-1)];
        
        //update user data
        [_defaults setInteger:stars forKey:[NSString stringWithFormat:@"level_%d_stars", index]];
    }
    
    
    //update user data
         [_defaults setBool:YES forKey:[NSString stringWithFormat:@"level_%d_complete", index]];
    if ([[_levelCompletionStatuses objectAtIndex:(set-1)*_numLevelIndices + (index-1)] isEqualToString:@"false"]) {
        [_levelCompletionStatuses setObject:@"true" atIndexedSubscript:(set-1)*_numLevelIndices + (index-1)];
        ++_numLevelsCompleted;
        if (_numLevelsCompleted == _numLevelSets * _numLevelIndices) {
            ++_numLevelsCompleted; // so this step happens only once
            [[CCDirector sharedDirector] pushScene: [OverallWinLayer scene]];
        }
        for ( int i = (set-1)*_numLevelIndices + (index-1); i < _numLevelSets * _numLevelIndices; i++ )
        {
            if ([[_isLevelLocked objectAtIndex:i] isEqualToString: @"true"])
            {
                [_isLevelLocked setObject:@"false" atIndexedSubscript:i];
                //update user data
                [_defaults setBool:NO forKey:[NSString stringWithFormat:@"level_%d_locked", i]];
                return;
            }
        }
    }


}

-(int) highScoreAtLevelSet:(int)set AndIndex:(int)index
{
    return [[_levelHighScores objectAtIndex:(set-1)*_numLevelIndices + (index-1)] intValue];
}

-(bool) isLevelLockedAtSet:(int)set AndIndex:(int)index
{
    if ([[_isLevelLocked objectAtIndex:(set-1)*_numLevelIndices + (index-1)] isEqualToString: @"true"])
        {
            return YES;
        }else{
            return NO;
        }
}

@end
