//
//  SoundManager.h
//  Team1Game3
//
//  Created by mchesley on 4/22/13.
//
//

#import "cocos2d.h"
#import "SimpleAudioEngine.h"

@interface SoundManager : SimpleAudioEngine {
    
@private
    
    bool _soundEffects;
    NSString* _backgroundMusic;
}

- (id) init;

+ (id) sharedSoundManager;

- (void) toggleBackgroundMusic;

- (void) toggleSoundEffects;

@end