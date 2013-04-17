//
//  GameManager.m
//  Team1Game3
//
//  Created by jarthur on 4/12/13.
//
//

#import "GameManager.h"

#import "OverallWinLayer.h"

@implementation GameManager

-(id) init
{
    if (self = [super init]) {
        _numLevelSets = 1;
        _numLevelIndices = 12;
        
        _numLevelsCompleted = 0;
        _levelCompletionStatuses = [[NSMutableArray alloc] init];
        for (int i = 0; i < _numLevelSets * _numLevelIndices; ++i)
        {
            [_levelCompletionStatuses addObject:@"false"];
            [_levelHighScores addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    return self;
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
    }
    
    if ([[_levelCompletionStatuses objectAtIndex:(set-1)*_numLevelIndices + (index-1)] isEqualToString:@"false"]) {
        [_levelCompletionStatuses setObject:@"true" atIndexedSubscript:(set-1)*_numLevelIndices + (index-1)];
        ++_numLevelsCompleted;
        if (_numLevelsCompleted == _numLevelSets * _numLevelIndices) {
            ++_numLevelsCompleted; // so this step happens only once
            [[CCDirector sharedDirector] pushScene: [OverallWinLayer scene]];
        }
    }
    
}

-(int) highScoreAtLevelSet:(int)set AndIndex:(int)index
{
    return [[_levelHighScores objectAtIndex:(set-1)*_numLevelIndices + (index-1)] intValue];
}

@end
