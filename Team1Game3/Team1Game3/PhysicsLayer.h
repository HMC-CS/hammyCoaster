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
#import "LevelGenerator.h"

@interface PhysicsLayer : CCLayer {

    b2World* world;					// strong ref
    GLESDebugDraw* m_debugDraw;		// strong ref
    ObjectFactory* _objectFactory;
    ContactListener* _contactListener;
    
    int starCount;
    CCLabelTTF* starLabel;
    
    id _target;
    SEL _selector1; //getSelectedObject
    SEL _selector2; //gameWon
    
    CGPoint ballStartingPoint;
    
    float xOffset;
    float yOffset;
    b2Body* currentMoveableBody;
    
    LevelGenerator* _levelGenerator;
    
    @public
    bool _editMode;
}

-(id) initWithLevelSet:(int) set AndIndex:(int) index;

/* playLevel:
 * Places a BallObject at ballStartingPoint
 */
-(void) playLevel;

/* setTarget: atAction:
 * guaranteed name for function to initialize selectors and target
 */
-(void) setTarget:(id) sender atAction:(SEL)action;

-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation  AsDefault:(bool)isDefault;

@end
