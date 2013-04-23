//
//  SoundManager.mm
//  Team1Game3
//
//  Created by mchesley on 4/22/13.
//
//

#import "SoundManager.h"

@implementation SoundManager

- (id) init
{
    self = [super init];
    
    _backgroundMusic = @"Background music.m4a";
    
    return self;
}

+ (id) sharedSoundManager
{
    static SoundManager *sharedSoundManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSoundManager = [[self alloc] init];
    });
    return sharedSoundManager;
}

- (void) toggleBackgroundMusic
{
    if ([self isBackgroundMusicPlaying])
        [self pauseBackgroundMusic];
    else
        [self playBackgroundMusic:@"Background music.m4a"];
}

- (void) toggleSoundEffects
{
    _soundEffects = !_soundEffects;
}

@end