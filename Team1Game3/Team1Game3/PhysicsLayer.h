//
//  PhysicsLayer.h
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//

#import "CCLayer.h"

#import <GameKit/GameKit.h>
#import <UIKit/UIKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "ObjectFactory.h"
#import "ContactListener.h"

@interface PhysicsLayer : CCLayer {

    b2World* world;					// strong ref
    GLESDebugDraw* m_debugDraw;		// strong ref
    ObjectFactory* _objectFactory;
    ContactListener* _contactListener;
    NSString* _objectType;
    CCSprite* _trash;
    
    
    int starCount;
    CCLabelTTF* starLabel;
    
    id _target;
    SEL _selector1; //getSelectedObject
    SEL _selector2; //gameWon
    SEL _selector3; //updateStarCount;

    SEL _selector4; //tells if an object should be deleted or dragged
    SEL _selector5;
    
    CGPoint ballStartingPoint;
    
    // For dragging and rotation
    b2Body* _currentMoveableBody;
    UITouch* _firstTouch;
    UITouch* _secondTouch;
    b2Vec2 _initialBodyPosition;
    b2Vec2 _initialTouchPosition;
    float _initialTouchAngle;
    NSMutableArray* _moveableDynamicStatus;
    
    NSArray* _initialObjects;
    
    std::vector<b2Body*> _bodiesToDestroy;
    
    @public
    bool _editMode;
}

/* initWithObjects:
 * Initializes a physics layer of level Set-Index
 */
-(id) initWithObjects: (NSArray*) objects;


/* getBallStartingPoint:
 * returns ballStartingPoint
 */
-(CGPoint) getBallStartingPoint;

/* playLevel:
 * Places a BallObject at ballStartingPoint
 */
-(void) playLevel;

/* resetBall:
 * deletes the ball, replaces stars and resets startcount
 * allows the level to be edited further
 */
-(void) resetBall;

/* setTarget: atAction:
 * guaranteed name for function to initialize selectors and target
 */
-(void) setTarget:(id) sender atAction:(SEL)action;

/* addNewSpriteOfType:AtPosition:WithRotation:AsDefault
 * Adds sprite to physics layer (with parameters).
 */
-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation  AsDefault:(bool)isDefault;

@end
