//
//  SoundManager.mm
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 4/22/13.
//
//

#import "SoundManager.h"

@implementation SoundManager

- (id) init
{
    if (self = [super init]) {
        _soundEffects = YES;
    }
    return self;
}


+ (id) sharedSoundManager
{
    static SoundManager *sharedSoundManager = nil;
    
    // Make sure a class can't make two sound managers.
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
        return;
        //[self playBackgroundMusic:@"Background music.m4a"];
}


- (void) toggleSoundEffects
{
    _soundEffects = !_soundEffects;
}


- (void) playEffectOfType:(NSString *)type
{
    // Sound effect "type.mp3" should exist.  However, if it does not,
    // no sound will play (and the program will not crash).
    if (_soundEffects)
        [self playEffect: [NSString stringWithFormat: @"%@.mp3", type]];
}


- (CCMenu*) createSoundMenu
{
    // Music on/off toggle button
    CCMenuItemImage* musicOnButton = [CCMenuItemImage itemWithNormalImage:@"Music on.png" selectedImage:@"Music on.png"];
    CCMenuItemImage* musicOffButton = [CCMenuItemImage itemWithNormalImage:@"Music off.png" selectedImage:@"Music off.png"];
    
    // Menu button changes based on status of background music
    NSArray* musicButtonArray;
    if ([self isBackgroundMusicPlaying]) {
        musicButtonArray = [NSArray arrayWithObjects: musicOnButton, musicOffButton, nil];
    } else {
        musicButtonArray = [NSArray arrayWithObjects: musicOffButton, musicOnButton, nil];
    }
    CCMenuItemToggle* musicToggle = [CCMenuItemToggle itemWithItems: musicButtonArray block:^(id sender) {
        [self toggleBackgroundMusic];
    }];
    
    
    // Sound on/off toggle button
    CCMenuItemImage* soundOnButton = [CCMenuItemImage itemWithNormalImage:@"Sound on.png" selectedImage:@"Sound on.png"];
    CCMenuItemImage* soundOffButton = [CCMenuItemImage itemWithNormalImage:@"Sound off.png" selectedImage:@"Sound off.png"];
    
    // Menu button changes based on status of sound effects
    NSArray* soundButtonArray;
    if (_soundEffects) {
        soundButtonArray = [NSArray arrayWithObjects: soundOnButton, soundOffButton, nil];
    } else {
        soundButtonArray = [NSArray arrayWithObjects: soundOffButton, soundOnButton, nil];
    }
    CCMenuItemToggle* soundToggle = [CCMenuItemToggle itemWithItems:soundButtonArray block:^(id sender) {
            [self toggleSoundEffects];
        }];
    
    
    // Combine background and sound effects buttons into a menu
    CCMenu* menu = [CCMenu menuWithItems: musicToggle, soundToggle, nil];
    [menu alignItemsHorizontally];
    menu.position=ccp([[CCDirector sharedDirector] winSize].width - 75, 730);
    
    
    return menu;
}

@end