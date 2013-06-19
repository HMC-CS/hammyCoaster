//
//  PhysicsLayer.m
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 3/8/13.
//
//


// NOTES:
// CCTouchEnded: make sure to do bounds checking here so ball is not added in inventory

#import "PhysicsLayer.h"
#import "InventoryLayer.h"

#import "PhysicsSprite.h"
#import "QueryCallback.h"

#import "MathHelper.h"

@implementation PhysicsLayer

@synthesize ballStartingPoint = _ballStartingPoint;
@synthesize safe_to_play = _safe_to_play;
@synthesize bodyArray = _bodyArray;


-(id) initWithObjects:(NSArray *)objects
{
    NSAssert1(objects, @"Objects array %@ given to PhysicsLayer is null.", objects);
    
	if (self = [super init]) {
		
        _createdObjects = [NSMutableArray array];
        
           _bodyArray = [[NSMutableArray alloc] init];
        
		self.isTouchEnabled = YES;
        
        _movedOverlap = true;
        
        _safe_to_play = true;
        
        // The layer is the right-hand 3/4 of the screen
		CGSize superSize = [CCDirector sharedDirector].winSize;
        [self setContentSize:CGSizeMake(superSize.width*(.87), superSize.height)];
        [self setPosition:ccp(superSize.width*(.13), 0)];
        
        // Create world manager and initialize world
        [self initPhysics];
        
        // Create initial objects on level screen
		_objectFactory = [ObjectFactory sharedObjectFactory];
        _initialObjects = objects;
        [self addInitialObjects];
        
        // For dragging and adding objects
        _editMode = YES;
        _trash = NULL;
        _moveableDynamicStatus = [[NSMutableArray alloc] init];
	}
    
	return self;
}


-(void) setTarget:(id) sender AtAction:(SEL)action
{
    NSAssert1(sender, @"Sender %@ for PhysicsLayer setTarget is null.", sender);
    NSAssert(action, @"Selector for PhysicsLayer setTarget is null.");
    
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    } else if (!_selector2) {
        _selector2 = action;
    } else if (!_selector3) {
        _selector3 = action;
    } else if (!_selector4) {
        _selector4 = action;
    } else if (!_selector5){
        _selector5 = action;
    }else
    {
        _selector6 = action;
    }
}



-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation AsDefault:(bool)isDefault;
{
    // If no object to add
    if ([type isEqualToString:@"None"]) {
        return;
    }
    
    // Otherwise, check if a valid class and continue
    NSAssert1(NSClassFromString(type), @"Type %@ given to addNewSpriteOfType in PhysicsLayer is not a valid object type", type);
    
    // Create sprites for the object
    // MULTI: add an if statement if there are multiple bodies in your object
    NSArray *spriteArray = [NSArray array];
    if ([type isEqualToString:@"SeesawObject"])
    {
        PhysicsSprite* sprite1 = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@Bottom.png", type]];
        PhysicsSprite* sprite2 = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@Top.png", type]];
        spriteArray = @[sprite1, sprite2];
    }else if ([type isEqualToString:@"RedPortalObject"])
    {
        p = ccp(p.x, p.y+368);
        PhysicsSprite* sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
        spriteArray = @[sprite];
    } else {
        PhysicsSprite* sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
        spriteArray = @[sprite];
    }
    
    // Create the object and its body/bodies
    AbstractGameObject *createdObj = [_objectFactory objectFromString:type ForWorld:_world AsDefault:isDefault WithSprites:[spriteArray mutableCopy]];
    [_createdObjects addObject:createdObj];
    std::vector<b2Body*> bodies = [createdObj createBodyAtLocation:p];
    
    
    // Connect the sprites and bodies, add the sprites to the layer
    int j = 0;
    for (std::vector<b2Body*>::iterator b = bodies.begin(); b != bodies.end(); ++b) {
        PhysicsSprite* s = [spriteArray objectAtIndex:j];
        b2Body* body = *b;
        [self addChild:s];
        [s setPhysicsBody:body];
        [s setPosition: ccp(body->GetPosition().x, body->GetPosition().y)];
        body->SetTransform(b2Vec2(p.x/PTM_RATIO,p.y/PTM_RATIO), rotation);
        ++j;
    }
}


-(void)playLevel
{
    _safe_to_play = true;
    
    for (AbstractGameObject *obj in _createdObjects){
        NSMutableArray* objectSprites = obj.sprites;
        for (CCSprite *sp in objectSprites) {
            if ((sp.color.r == 84 && sp.color.g == 84 && sp.color.b == 84) ||
                (sp.color.r == 255 && sp.color.g == 0 && sp.color.b == 0)) {
                NSLog(@"This cannot happen");
                _safe_to_play = false;
                break;
            }
        }
    }
    // You can only create one ball before resetting
    if (!_safe_to_play)
    {
        NSLog(@"overlapped item");
        [self togglePlayMode];
        id action1 = [CCCallFunc actionWithTarget:self selector:@selector(flashColor)];
        id delay = [CCDelayTime actionWithDuration:0.2];
        id action2 = [CCCallFunc actionWithTarget:self selector:@selector(resetColor)];
        id sequence = [CCSequence actions:action1,delay,action2, nil];
        [self runAction:sequence];
        }
    else if (_editMode && _safe_to_play) {
        _editMode = NO;
        [self addNewSpriteOfType:@"BallObject" AtPosition:_ballStartingPoint WithRotation:0 AsDefault:NO];
}
}

-(void) resetColor
{
for (AbstractGameObject *obj in _createdObjects){
    NSMutableArray* objectSprites = obj.sprites;
    for (CCSprite *sp in objectSprites) {
        if (sp.color.r == 255 && sp.color.g == 0 && sp.color.b == 0) {
            sp.color =ccc3(84,84,84);
        }
    }
}
}
-(void) flashColor
{
    for (AbstractGameObject *obj in _createdObjects){
    NSMutableArray* objectSprites = obj.sprites;
    for (CCSprite *sp in objectSprites) {
        if (sp.color.r == 84 && sp.color.g == 84 && sp.color.b == 84) {
            sp.color =ccc3(255,0,0);
        }
    }
}
}



-(void) resetBall
{
    // Delete Ball and Stars
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()){
        if ([((__bridge AbstractGameObject*)(b->GetUserData())).type isEqualToString:@"BallObject"]) {
            AbstractGameObject* a = (__bridge AbstractGameObject*)(b->GetUserData());
            CFBridgingRetain(a);
            CCSprite* sprite = [a.sprites objectAtIndex:0];
            [self removeChild: sprite cleanup:NO]; // cleanup removed
            [self deleteObjectWithBody:b];
        } else if ([((__bridge AbstractGameObject*)(b->GetUserData())).type isEqualToString:@"StarObject"]) {
            AbstractGameObject* a = (__bridge AbstractGameObject*)(b->GetUserData());
            CFBridgingRetain(a);
            CCSprite* sprite = [a.sprites objectAtIndex:0];
            [self removeChild: sprite cleanup:NO]; // cleanup removed
            [self deleteObjectWithBody:b];
        }
    }
    
    // Make level editable.
    // Make sure to call this before putting the stars back.
    _editMode = YES;
    
    // Put back all the stars from the JSON file
    for (NSArray* item in _initialObjects) {
        NSString* type = [item objectAtIndex:0];
        if ([type isEqualToString: @"StarObject"]) {
            CGFloat px = [[item objectAtIndex:1] floatValue];
            CGFloat py = [[item objectAtIndex:2] floatValue];
            CGFloat rotation = [[item objectAtIndex:3] floatValue];
            NSLog(@"adding star");
            [self addNewSpriteOfType:type AtPosition:ccp(px,py) WithRotation:rotation AsDefault:YES];
        }
    }
    
    NSLog(@"resetseeSaw called");
    [_worldManager resetSeesaw];
}


/* ////////////////////////////// Private Functions ////////////////////////////// */


/* initPhysics
 * Sets up the world, contact listener, and world manager
 */
-(void) initPhysics
{
	// Set up the world
    b2Vec2 gravity;
    gravity.Set(0.0f, -10.0f);
    _world = new b2World(gravity);
    _world->SetAllowSleeping(true);
    _world->SetContinuousPhysics(true);
    
    // For collision callbacks
    _contactListener = new ContactListener();
    _world->SetContactListener(_contactListener);
    
    _worldManager = [[WorldManager alloc] initWithWorld:_world];
    [_worldManager setBoundariesForLayer:self];
    [self scheduleUpdate];      // So update is called
}


/* addInitialObjects
 * Adds the objects to the level screen
 * Note: RedPortalObject should always be created first
 * (be first in jwon file) or it will look super weird
 */
- (void) addInitialObjects
{
    for (NSArray* item in _initialObjects) {
        
        NSString* type = [item objectAtIndex:0];
        CGFloat px = [[item objectAtIndex:1] floatValue];
        CGFloat py = [[item objectAtIndex:2] floatValue];
        CGFloat rotation = [[item objectAtIndex:3] floatValue];
        [self addNewSpriteOfType:type AtPosition:ccp(px,py) WithRotation:rotation AsDefault:YES];
        
        // The ball starts where the red portal starts
        if ([type isEqual: @"RedPortalObject"]){
            _ballStartingPoint = CGPointMake(px,py);
        }
    }
}


/* hitStar:
 * Removes star from screen when it is hit
 */
-(void) hitStar:(b2Body*) starBody
{
    NSAssert(starBody, @"Star body in hitStar in Physics Layer is null.");
    
    // The "if" check is to ensure that if reset ball is pressed while the ball is
    // on top of a star, then the star will still appear after the reset.
    // This is an issue because of our "buffered" deletion of bodies (deleted in update).
    if (!_editMode) {
        [self deleteObjectWithBody:starBody];
        [self updateStarCount];
    }
}

/* catPaw Interaction:
 * 
 */

-(BOOL) catPawCollision
{
    

   if (!_editMode)
   {
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()){
    AbstractGameObject* object = (__bridge AbstractGameObject*)(b->GetUserData());
 
    if ([object.type isEqualToString:@"BallObject"])
    {

       NSMutableArray* objectSprites = object.sprites;
       for(CCSprite* sp in objectSprites)
       {
           CGRect ballBox = sp.boundingBox;
           int catPawsYVal = 2*self.contentSize.height/32;
           if (ballBox.origin.y*3 < catPawsYVal)
           {
               [self resetStarCount];
               [self resetBall];
               [self togglePlayMode];

               return true;
           }
       }
        
       }
        
       
   }
   }

    return false;
}


/* deleteObjectWithBody:
 * Deletes a physics body from the physics layer
 */
-(void) deleteObjectWithBody: (b2Body*) body
{
    // Get object and all its bodies
    AbstractGameObject* object = (__bridge AbstractGameObject*)(body->GetUserData());
    CFBridgingRetain(object);
    NSString* objectType = object.type;
    [self objectDeletedOfType:objectType];
    std::vector<b2Body*> bodies = object.bodies;
    NSMutableArray* objectSprites = object.sprites;
    
    int j = 0;
    for (std::vector<b2Body*>::iterator b = bodies.begin(); b != bodies.end(); ++b) {
        PhysicsSprite* s = [objectSprites objectAtIndex:j];
        b2Body* body = *b;
        [self removeChild:s cleanup:NO]; //cleanup removed
        [_worldManager destroyBody:body];
        ++j;
    }
}



/* ///////////////////////// Target-Selector Functions ///////////////////////// */


/* getObjectType
 * Gets type of object to be added to screen
 */
- (NSString*) getObjectType
{
    return [_target performSelector:_selector1];
}

/* gameWon
 * Indicates the game is won when the ball hits the portal
 */
-(void) gameWon
{
    [_target performSelector:_selector2];
}

/* updateStarCount:
 * Causes star count to be updated when a star is hit
 */
-(void) updateStarCount
{
    [_target performSelector:_selector3];
}

/* objectDeletedOfType:
 * Signals when an object is deleted so inventory count can be increased
 */
-(void) objectDeletedOfType: (NSString*) type
{
    [_target performSelector:_selector4 withObject:type];
}

/* togglePlayMode
 * Signals when level is in play vs. edit mode
 */
-(void) togglePlayMode
{
    [_target performSelector:_selector5];
}

-(void) resetStarCount
{
    [_target performSelector:_selector6];
}

/* ///////////////////////// Box2D Functions ///////////////////////// */

// DEBUG_DRAW - remove this method before publishing.
-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommended to disable it
	//
	[super draw];
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	_world->DrawDebugData();
	kmGLPopMatrix();
}


/* update:
 * simulates a time step in the physics world
 */
-(void) update: (ccTime) dt
{
    // TODO: make a decision about this
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	_world->Step(dt, velocityIterations, positionIterations);
    

    
    // If ball intersects blue portal, you win the level!
    if (_contactListener->IsLevelWon()) {
        _contactListener->SetLevelWonStatus(false);
        [self gameWon];
    }
    if ([self catPawCollision])
    {
        NSLog(@"In the update");
    }
    
    // If the ball hits a star, erase it.
    b2Body* contactStar = _contactListener->GetContactStar();
    if (contactStar) {
        [self hitStar:contactStar];
        _contactListener->EraseContactStar();
        
    }
    
    
    // Update other things in the world
    [_worldManager update];
}


/* ////////////////////////////// Touch Functions ////////////////////////////// */

/* registerWithTouchDispacher
 * Initializes touches for PhysicsLayer.
 */
-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

/* ccTouchBegan:
 * Deals with touch-downs within PhysicsLayer.
 */
-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_firstTouch == NULL) {
        
        _firstTouch = touch;
        
        // Get tap location and convert to cocos2d-box2d coordinates
        CGPoint touchLocation = [self getTouchLocation:touch];
        _initialTouchPosition = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
        
        // If the touch is in the inventory, add an object where the touch is
        if (touchLocation.x < 0) {
            NSString* type = [self getObjectType];
            CGPoint objectLocation = touchLocation;
            
            // We need to shift curved ramps up so part of the object overlaps with the touch
            if ([type isEqualToString:@"CurvedRampObject"]) {
                objectLocation.y += 50;
            }
            
            [self addNewSpriteOfType:type AtPosition:objectLocation WithRotation:0.0 AsDefault:false];
        }
        
        
        b2Body* body = [self getBodyAtLocation:_initialTouchPosition WithAABBSize:0.001f];
        
        
        // If there's a body where the touch is, set up for dragging
        if (body) {
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(body->GetUserData());
            CFBridgingRetain(bodyObject);
            
            // If the object is draggable, set up dragging for that object
            if (!bodyObject.isDefault && _editMode) {
                
                // Save the body and its location
                _initialBodyPosition = body->GetPosition();
                _currentMoveableBody = body;
                
                // Unless the touch is in the inventory, turn the inventory into the trash can
                if (![self isPointInInventory:touchLocation]) {
                    [self addTrash];
                }
                
                // Save if each object body is dynamic or static
                [self storeMoveableDynamicStatusForBodies:bodyObject.bodies];
                
                // Clicking on the ball resets the ball
            } else if ([bodyObject.type isEqualToString:@"BallObject"]) {
                [self resetBall];
                [self togglePlayMode];
            }
        }
        
        // If it's the second touch (and the first touch was on a body), set up for rotation
    } else if (_secondTouch == NULL && _currentMoveableBody != NULL) {
        NSString* currentMoveableBodyType = ((__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData())).type;
        if (![currentMoveableBodyType isEqualToString:@"SeesawObject"]) {
            _secondTouch = touch;
            _initialTouchAngle = [self calculateTouchAngle];
        }
    }
    return YES;
}


/* ccTouchMoved:
 * Deals with touches moved within PhysicsLayer.
 */
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (_currentMoveableBody != NULL) {
        
        // If there's only one touch, drag
        if (touch == _firstTouch && _secondTouch == NULL) {
            
            // Calculate touch location
            CGPoint touchLocation = [self getTouchLocation:touch];
            b2Vec2 location = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
            
            // Move each body
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            CFBridgingRetain(bodyObject);
            std::vector<b2Body*> bodies = bodyObject.bodies;
            for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
            {
                b2Body* b = *i;
                b2Vec2 newPos = b->GetPosition() + (location - _initialTouchPosition);
                b->SetTransform(newPos,b->GetAngle());
            }
            
            _initialTouchPosition = location;
        }
        
        // If there are 2 touches, rotate
        if (_secondTouch != NULL && (touch == _firstTouch || touch == _secondTouch)) {
            
            float touchAngle = [self calculateTouchAngle];
            
            // Rotate each body
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            CFBridgingRetain(bodyObject);
            std::vector<b2Body*> bodies = bodyObject.bodies;
            for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
            {
                b2Body* b = *i;
                float newAngle = b->GetAngle() + (touchAngle - _initialTouchAngle);
                b->SetTransform(b->GetPosition(),newAngle);
            }
            
            _initialTouchAngle = touchAngle;
        }
    }
}


/* ccTouchCancelled:
 * Deals with touches cancelled within PhysicsLayer.
 */
-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch == _firstTouch) {
        [self resetTouch];
    } else if (touch == _secondTouch) {
        _secondTouch = NULL;
    }
}


/* ccTouchEnded:
 * Deals with touch-ups within PhysicsLayer.
 */
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    if (touch == _firstTouch) {
        
        // If we were moving a body, maybe delete or bounce back
        if (_currentMoveableBody != NULL) {
            
            AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData());
            CFBridgingRetain(bodyObject);
            
            [self finishedMovingObject:bodyObject];
        }
        
        [self resetTouch];
    } else if (touch == _secondTouch) {
        _secondTouch = NULL;
    }
}


/* ////////////////////////// Touch Helper Functions ////////////////////////// */

/* getTouchLocation:
 * Converts touch to physics layer coordinates
 */
-(CGPoint) getTouchLocation:(UITouch *) touch
{
    // Get touch and convert to Physics Layer coordinates
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    
    return touchLocation;
}


/* getBodyAtLocation:
 * Uses QueryCallback to see if a body intersects with a given point
 */
-(b2Body*) getBodyAtLocation:(b2Vec2) location WithAABBSize:(float) boxSize
{
    QueryCallback callback(location);
    b2AABB aabb = callback.getAABB(0.001f);
    _world->QueryAABB(&callback, aabb);
    
    return callback.getm_object();
}


/* addTrash
 * Adds a trash can sprite to the scene
 */
-(void) addTrash
{
    _trash = [CCSprite spriteWithFile:@"trash2.png"];
    _trash.position = ccp(-self.boundingBox.size.width/5.9, self.boundingBox.size.height/2);
    //[self addChild:_trash z:10000];
}


/* storeMoveableDynamicStatusForBodies
 * Given a vector of bodies, keeps track of whether they're dynamic or static
 *  before setting them static for dragging.
 */
-(void) storeMoveableDynamicStatusForBodies:(std::vector<b2Body*>) bodies
{
    for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i) {
        b2Body* loopBody = *i;
        
        if (loopBody->GetType() == b2_dynamicBody) {
            [_moveableDynamicStatus addObject:@"dynamic"];
            loopBody->SetType(b2_staticBody);
        } else {
            [_moveableDynamicStatus addObject:@"static"];
        }
        
        // So the body doesn't intersect with other bodies.
        loopBody->SetActive(false);
    }
}


/* resetMoveableDynamicStatusForBodies
 * Restores the dynamic or static state of dragged bodies as stored in
 *  storeMoveableDynamicStatusForBodies
 */
-(void) resetMoveableDynamicStatusForBodies:(std::vector<b2Body*>) bodies
{
    int statusCounter = 0;
    for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
    {
        b2Body* body = *i;
        if ([[_moveableDynamicStatus objectAtIndex:statusCounter] isEqualToString:@"dynamic"]) {
            body->SetType(b2_dynamicBody);
        }
        body->SetActive(true);
        ++statusCounter;
    }
}


/* isPointInInventory:
 * Returns whether or a not a point is in the inventory (as opposed to the
 *  level screen)
 */
-(bool) isPointInInventory:(CGPoint) point
{
    return point.x < 0;
}


/* isPointInTrash:
 * Returns whether or not a point is in the trash sprite (for deletion)
 */
-(bool) isPointInTrash: (CGPoint) point
{
    return (point.x < self.boundingBox.origin.x &&
        point.y > self.boundingBox.size.height/5 &&
        point.y < self.boundingBox.size.height*4/5);
}


/* calculateTouchAngle
 * Returns whether or not a point is in the trash sprite (for deletion)
 */
-(float) calculateTouchAngle
{
    CGPoint point = ccpSub([_secondTouch locationInView:[_secondTouch view]], [_firstTouch locationInView:[_firstTouch view]]);
    CGPoint xaxis = CGPointMake(-1, 0);
    float touchAngle;
    if (point.y >= 0) {
        touchAngle = ccpAngle(point, xaxis);
    } else {
        point = CGPointMake(point.x, -point.y);
        touchAngle = -ccpAngle(point, xaxis);
    }
    
    return touchAngle;
}


/* resetTouch
 * Removes touches and cleans them up
 */
-(void) resetTouch
{
    _firstTouch = NULL;
    _secondTouch = NULL;
    [self removeChild:_trash cleanup:NO];
    [_moveableDynamicStatus removeAllObjects];
    _currentMoveableBody = NULL;
}


/* finishedMovingObject:
 * Deals with special cases for invalid placements of a body
 */
-(void) finishedMovingObject: (AbstractGameObject*) bodyObject
{
   
    std::vector<b2Body*> bodies = bodyObject.bodies;
    b2Body *second_body; // added this -June 18. Kanak
    
    bool deleteObject = false;
    bool bounceBackObject = false;
    

    
    // Iterate through all the bodies in the object
    for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i) {
        b2Body* body = *i;
        
        // Iterate through all the fixtures in each body
        for (b2Fixture* f = body->GetFixtureList(); f != NULL; f = f->GetNext()) {
            b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
            int count = polygonShape->GetVertexCount();
            
            // Iterate through all the vertices in each fixture
            for (int i = 0; i < count; i++) {
                
                // Get the location of the vertex
                b2Vec2 vertex = polygonShape->GetVertex(i);
                vertex = body->GetWorldPoint(vertex);
                CGPoint vertexPoint = ccpMult(ccp(vertex.x, vertex.y), PTM_RATIO);
                vertexPoint = ccpAdd(vertexPoint, self.boundingBox.origin);
                
                // Check if the point is in the inventory
                if ( !CGRectContainsPoint(self.boundingBox, vertexPoint)) {
                    if ([self isPointInTrash:vertexPoint]) {
                        deleteObject = true;
                        break;
                    } else {
                        bounceBackObject = true;
                        break;
                    }
                }
                
                // Check if the vertex is in another body
                b2Body* b = [self getBodyAtLocation:vertex WithAABBSize:10.0f];
                if (b && (b != body)) {
                    
                    AbstractGameObject* bodyObject = (__bridge AbstractGameObject*)(b->GetUserData());
                    NSString* bodyType = bodyObject.type;
                    
                    // Allow overlap with stars
                    if (![bodyType isEqualToString:@"StarObject"]) {
                        bounceBackObject = true;
                        second_body = b;
                        for (CCSprite* sp in bodyObject.sprites)
                        {
                            [_bodyArray addObject:sp];
                        }
                        NSLog(@"body array length: %d", _bodyArray.count);
                        //break;
                    }
                }
                //break;
                
            }
            
            // Break if something has been processed
            if (deleteObject || bounceBackObject) {
                break;
            }
        }
        // Break if something has been processed
        if (deleteObject || bounceBackObject) {
            break;
        }
    }
    
    
    
    if (deleteObject) {
        [self deleteObjectWithBody:_currentMoveableBody];
    } else if (bounceBackObject) {
        [self bounceBackObjectWithBody:_currentMoveableBody];
        [self bounceBackObjectWithBody:second_body];
    }
    else if (!bounceBackObject) {   // we need to check all objects that are not colliding. All of them should turn back to original colors
        std::vector<b2Body*> bodies = ((__bridge AbstractGameObject*)(_currentMoveableBody->GetUserData())).bodies;
        for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
        {
            b2Body* body = *i;
            AbstractGameObject* object = (__bridge AbstractGameObject*)(body->GetUserData());
            NSMutableArray* objectSprites = object.sprites;
            for(CCSprite* sp in objectSprites)
            {
                sp.color = ccc3(255,255, 255);  // basically displays the original colors when objects are not in contact
            }
        }
        
           NSLog(@"bodyAray 2: %d", _bodyArray.count);
            for(CCSprite* sp in _bodyArray)
            {
                NSLog(@"actually in here");
                sp.color = ccc3(255,255, 255);  // basically displays the original colors when objects are not in contact

            }



    
    }
    
    [self resetMoveableDynamicStatusForBodies:bodies];
}


/* bounceBackObjectWithBody
 * Bounces an object back to its initial position if needed
 */
-(void) bounceBackObjectWithBody: (b2Body*) body
{
    NSLog(@"body's x coordinate is %f", body->GetPosition().x);
    NSLog(@"window width is %f", self.contentSize.width);
    NSLog(@"window height is %f", self.contentSize.height);
    float max_x = 0.0;
    float max_y = 0.0;
    float min_y = 0.0;
    for (b2Fixture* f = body->GetFixtureList(); f != NULL; f = f->GetNext()) {
        
        b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
        int count = polygonShape->GetVertexCount();
        
        // Iterate through all the vertices in each fixture
        for (int i = 0; i < count; i++) {
            
            // Get the location of the vertex
            b2Vec2 vertex = polygonShape->GetVertex(i);
            vertex = body->GetWorldPoint(vertex);
            
            CGPoint vertexPoint = CGPointMake(vertex.x, vertex.y);
            if (vertexPoint.x > max_x) {
                max_x = vertexPoint.x;
            }
            if (vertexPoint.y > max_y) {
                max_y = vertexPoint.y;
            }
            if (vertexPoint.y < min_y) {
                min_y = vertexPoint.y;
            }
        }
    }
    if (_initialBodyPosition.x < 0) {
        [self deleteObjectWithBody:body];       // Delete objects in inventory
    }
    // when you are trying to place objects off screen
    // it will bounce back to its original position
    
    else if (max_x > self.contentSize.width/PTM_RATIO || max_y > self.contentSize.height/PTM_RATIO || min_y < 0)
    {
        
        b2Vec2 cmbPosition = _currentMoveableBody->GetPosition();
        std::vector<b2Body*> bodies = ((__bridge AbstractGameObject*)(body->GetUserData())).bodies;
        for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i) 
            {
            b2Body* body = *i;
            b2Vec2 bodyOffset = body->GetPosition() - cmbPosition;
            // Set each body to its original position, taking account of offsets
            body->SetTransform(_initialBodyPosition + bodyOffset, body->GetAngle());
            }
         
    }
    // when 2 or more objects intersect
    // one of them becomes grey
    else {
        std::vector<b2Body*> bodies = ((__bridge AbstractGameObject*)(body->GetUserData())).bodies;
        for (std::vector<b2Body*>::iterator i = bodies.begin(); i != bodies.end(); ++i)
        {
            b2Body* body = *i;
            AbstractGameObject* object = (__bridge AbstractGameObject*)(body->GetUserData());
            NSMutableArray* objectSprites = object.sprites;
            for(CCSprite* sp in objectSprites)
            {
                sp.color = ccc3(84,84,84);  // this is the hardcoded value of the greyish color (84,84,84)
            }
            }
        }
        
}


/* //////////////////////////////// Deallocate ///////////////////////////////// */

-(void) dealloc
{
	delete m_debugDraw;
	m_debugDraw = NULL;
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()) {
        b->SetAwake(false);
    }
    
    for (b2Body* b = _world->GetBodyList(); b; b = b->GetNext()) {
        _world->DestroyBody(b);
    }
    
    delete _world;
	_world = NULL;
}


@end
