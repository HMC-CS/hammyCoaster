//
//  PhysicsLayer.h
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//

#ifndef PHYSICS_LAYER_INCLUDED
#define PHYSICS_LAYER_INCLUDED 1

#import "CCLayer.h"

#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>

#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ObjectFactory.h"
#import "ContactListener.h"
#import "WorldManager.h"

@interface PhysicsLayer : CCLayer {
    
    GLESDebugDraw* m_debugDraw;         // DEBUG_DRAW: Debug draw. Remove before publishing.

    b2World* _world;                    // The physics world
    ContactListener* _contactListener;  // Listens for collisions
    WorldManager* _worldManager;        // Helps with some physics world functionality
    
    ObjectFactory* _objectFactory;      // Creates objects
    NSArray* _initialObjects;           // Objects added to level by default
    NSMutableArray* _createdObjects;    // Objects created by the Object Factory
    
    id _target;     // LevelLayer
    SEL _selector1; // getInventorySelectedObject
    SEL _selector2; // gameWon
    SEL _selector3; // updateStarCount
    SEL _selector4; // objectDeletedOfType
    SEL _selector5; // togglePlayResetButton
    SEL _selector6;

    
    CGPoint _ballStartingPoint;         // Where the ball (and red portal) start
    bool _editMode;                     // Whether or not level is editable by player
    
    // For dragging and rotation
    UITouch* _firstTouch;               // Touch 1 to screen (dragging)
    UITouch* _secondTouch;              // Touch 2 to screen (rotation)
    b2Vec2 _initialTouchPosition;       // Position of first touch
    float _initialTouchAngle;           // Angle of first touch
    b2Body* _currentMoveableBody;       // Body being moved
    b2Vec2 _initialBodyPosition;        // Initial position of body being moved
    NSMutableArray* _moveableDynamicStatus;     // Whether bodies in object being
                                                // moved are dynamic or static
    CCSprite* _trash;                   // Sprite that covers trash during dragging
    
    bool _safe_to_play;                  // a boolean that needs to be true in order for the game to begin
    NSMutableArray* _bodyArray;
    bool _movedOverlap;
}

@property (readonly) CGPoint ballStartingPoint;
@property bool safe_to_play;
@property (retain,readwrite) NSMutableArray* bodyArray;

/* initWithObjects:
 * Initializes a physics layer of level Set-Index
 */
-(id) initWithObjects: (NSArray*) objects;


/* setTarget: AtAction:
 * Guaranteed name for function to initialize selectors and target
 */
-(void) setTarget:(id) sender AtAction:(SEL)action;


/* addNewSpriteOfType:AtPosition:WithRotation:AsDefault
 * Adds sprite to physics layer (with parameters).
 */
-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation  AsDefault:(bool)isDefault;




/* playLevel
 * Places a BallObject at ballStartingPoint
 */
-(void) playLevel;


/* resetBall
 * Deletes the ball, replaces stars, and resets star count.
 * Allows the level to be edited further
 */
-(void) resetBall;

-(bool) isOverlapped;
-(void) bounceBackObjectWithBody: (b2Body*) body;
-(void) finishedMovingObject: (AbstractGameObject*) moveableObject;


@end

#endif  // PHYSICS_LAYER_INCLUDED
