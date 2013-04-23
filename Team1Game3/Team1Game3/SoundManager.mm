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
    
    _soundEffects = true;
    
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

- (void) playEffectOfType:(NSString *)type
{
    if (_soundEffects)
        [self playEffect: [NSString stringWithFormat: @"%@.mp3", type]];
}

- (CCMenu*) createSoundMenu
{
    // Music on/off toggle
    CCMenuItemImage* musicOnButton = [CCMenuItemImage itemWithNormalImage:@"Music on.png" selectedImage:@"Music on.png"];
    CCMenuItemImage* musicOffButton = [CCMenuItemImage itemWithNormalImage:@"Music off.png" selectedImage:@"Music off.png"];
    CCMenuItemToggle* musicToggle;
    
    if ([self isBackgroundMusicPlaying])
        musicToggle = [CCMenuItemToggle itemWithItems: [NSArray arrayWithObjects: musicOnButton, musicOffButton, nil] block:^(id sender) {
            [[SoundManager sharedSoundManager] toggleBackgroundMusic];
        }];
    else
        musicToggle = [CCMenuItemToggle itemWithItems: [NSArray arrayWithObjects: musicOffButton, musicOnButton, nil] block:^(id sender) {
            [[SoundManager sharedSoundManager] toggleBackgroundMusic];
        }];
        
    
    // Sound on/off toggle
    CCMenuItemImage* soundOnButton = [CCMenuItemImage itemWithNormalImage:@"Sound on.png" selectedImage:@"Sound on.png"];
    CCMenuItemImage* soundOffButton = [CCMenuItemImage itemWithNormalImage:@"Sound off.png" selectedImage:@"Sound off.png"];
    CCMenuItemToggle* soundToggle;
    
    if (_soundEffects)
        soundToggle = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects: soundOnButton, soundOffButton, nil] block:^(id sender) {
            [[SoundManager sharedSoundManager] toggleSoundEffects];
        }];
    else
        soundToggle = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects: soundOffButton, soundOnButton, nil] block:^(id sender) {
            [[SoundManager sharedSoundManager] toggleSoundEffects];
        }];
    
    // Combine them into a menu
    CCMenu* menu = [CCMenu menuWithItems: musicToggle, soundToggle, nil];
    [menu alignItemsHorizontally];
    menu.position=ccp([[CCDirector sharedDirector] winSize].width - 75, 40);

    
    return menu;
}

@end