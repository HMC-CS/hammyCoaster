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
    
    bool _soundEffects;       // Should we play sound effects or not?
}


/* sharedSoundManager
 * Code to implement Sound Manager as a singleton
 */
+ (id) sharedSoundManager;


/* toggleBackgroundMusic
 * Toggles background music (on or off)
 */
- (void) toggleBackgroundMusic;


/* toggleSoundEffects
 * Toggles sound effects (on or off)
 */
- (void) toggleSoundEffects;


/* playEffectOfType
 * Plays a sound effect based on the object with which the ball collides
 */
- (void) playEffectOfType: (NSString*) type;


/* createSoundMenu
 * Creates the sound menu on a given screen
 */
- (CCMenu*) createSoundMenu;

@end