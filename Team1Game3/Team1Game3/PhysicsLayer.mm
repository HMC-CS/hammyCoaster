//
//  PhysicsLayer.m
//  Team1Game3
//
//  Created by jarthur on 3/8/13.
//
//


// NOTES:
// CCTouchEnded: make sure to do bounds checking here so ball is not added in inventory

#import "PhysicsLayer.h"
#import "InventoryLayer.h"

#import "PhysicsSprite.h"
#import "QueryCallback.h"

@implementation PhysicsLayer


//-----INITIALIZATION-----//

-(id) initWithObjects:(NSArray *)objects
{
    NSAssert1(objects, @"Objects array %@ given to PhysicsLayer is null.", objects);
    
	if( (self=[super init])) {
		
		// enable events
        //		_mouseJoint = NULL;
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
		CGSize superSize = [CCDirector sharedDirector].winSize;
        
        [self setContentSize:CGSizeMake(superSize.width*0.75, superSize.height)];
        [self setPosition:ccp(superSize.width*0.25, 0)];
        
		// init physics
		[self initPhysics];
        
		_objectFactory = [ObjectFactory sharedObjectFactory];
        
        _initialObjects = objects;
        
        _initialPostion = b2Vec2(0,0);
        
        _objectType = [[NSString alloc] initWithFormat:@"None"];
        
        [self addInitialObjects];
		
		[self scheduleUpdate];
        
        _editMode = YES;
	}
	return self;
}

-(void) initPhysics
{
	
	CGSize size = [self contentSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f);
	world = new b2World(gravity);
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(true);
	
	world->SetContinuousPhysics(true);
    
    // For collision callbacks
    _contactListener = new ContactListener();
    world->SetContactListener(_contactListener);
	
	m_debugDraw = new GLESDebugDraw( PTM_RATIO );
    
    // NOTE: comment this line out to disable debug draw
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	m_debugDraw->SetFlags(flags);
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,size.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(size.width/PTM_RATIO,size.height/PTM_RATIO), b2Vec2(size.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
    
    
    /* hacked default ramps
     * ---------------------------------------------------------------------- */
    
    // Starting ramp
    b2BodyDef rampBodyDef;
    rampBodyDef.position.Set(0/PTM_RATIO,100/PTM_RATIO);
    
    b2Body *rampBody = world->CreateBody(&rampBodyDef);
    b2EdgeShape rampEdge;
    b2FixtureDef rampShapeDef;
    rampShapeDef.shape = &rampEdge;
    
    // ramp definitions
    rampEdge.Set(b2Vec2(0/PTM_RATIO,450/PTM_RATIO), b2Vec2(size.width/(5*PTM_RATIO), 410/PTM_RATIO));
    rampBody->CreateFixture(&rampShapeDef);
    
}

- (void) addInitialObjects
{
    for (NSArray* item in _initialObjects) {
        NSString* type = [item objectAtIndex:0];
        CGFloat px = [[item objectAtIndex:1] floatValue];
        CGFloat py = [[item objectAtIndex:2] floatValue];
        CGFloat rotation = [[item objectAtIndex:3] floatValue];
        [self addNewSpriteOfType:type AtPosition:ccp(px,py) WithRotation:rotation AsDefault:YES];
        if ([type isEqual: @"RedPortalObject"])
            ballStartingPoint = CGPointMake(px,py);
    }
    
    //		// Code kept around for later
    //        #if 1
    //        		// Use batch node. Faster
    //        		CCSpriteBatchNode *parent = [CCSpriteBatchNode batchNodeWithFile:@"blocks.png" capacity:100];
    //        		spriteTexture_ = [parent texture];
    //        #else
    //        		// doesn't use batch node. Slower
    //        		spriteTexture_ = [[CCTextureCache sharedTextureCache] addImage:@"blocks.png"];
    //        		CCNode *parent = [CCNode node];
    //        #endif
    //        		[self addChild:parent z:0 tag:kTagParentNode];
    //
    //		[self addNewSpriteOfType:@"BallObject" AtPosition:ccp(size.width/2, size.height/2)];
    //
    //		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tap screen" fontName:@"Marker Felt" fontSize:32];
    //		[self addChild:label z:0];
    //		[label setColor:ccc3(0,0,255)];
    //		label.position = ccp( size.width/2, size.height-50);
}


//-----GAME METHODS-----//

-(void) addNewSpriteOfType: (NSString*) type AtPosition:(CGPoint)p WithRotation: (CGFloat) rotation AsDefault:(bool)isDefault;
{
    if([type isEqualToString:@"MagnetObject"])
        NSLog(@"MagnetObject");
    NSAssert1(NSClassFromString(type), @"Type %@ given to addNewSpriteOfType in PhysicsLayer is not a valid object type", type);
    
	PhysicsSprite *sprite = [PhysicsSprite spriteWithFile:[NSString stringWithFormat:@"%@.png",type]];
    
    //TODO:
    //read from the file to see how many objects should be added
    //Check how many sprites have been added
    //getBodylist() then loop through and for each body apperance you are looking for count 1 and if count
    // = the count in the file return
    
    b2Body *body = [[_objectFactory objectFromString:type forWorld:world asDefault:isDefault withSprite:sprite] createBody:p];
    
    body->SetTransform(b2Vec2(p.x/PTM_RATIO,p.y/PTM_RATIO), rotation);
    
    if (![static_cast<AbstractGameObject*>(body->GetUserData())._tag isEqualToString:@"BallObject"]) {
        
        b2Fixture* f = body->GetFixtureList();
        b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
        int count = polygonShape->GetVertexCount();
        
        CGFloat offset = self.boundingBox.origin.x;
        
        for(int i = 0; i < count; i++)
        {
            CGFloat xCoordinate =(CGFloat) (&polygonShape->GetVertex(i))->x;
            CGFloat yCoordinate = (CGFloat) (&polygonShape->GetVertex(i))->y;
            CGPoint point = ccpMult(CGPointMake(xCoordinate, yCoordinate), PTM_RATIO);
            CGPoint boundPoint = CGPointMake(point.x + p.x + offset, point.y + p.y);
            boundPoint = [[CCDirector sharedDirector] convertToGL: boundPoint];
            
            if ( !CGRectContainsPoint(self.boundingBox, boundPoint))
            {
                //                NSString* type = static_cast<AbstractGameObject*>(body->GetUserData())._tag;
                //                [self objectDeletedOfType:type];
                //                world->DestroyBody(body);
                [self deleteObjectWithBody:body];
                NSLog(@"Body destroy");
                return;
            }
        }
    }
    
    [self addChild:sprite];
	[sprite setPhysicsBody:body];
    [sprite setPosition: ccp(p.x,p.y)];
    //_initialPostion = b2Vec2(p.x/PTM_RATIO,p.y/PTM_RATIO);
}


-(void)playLevel
{
    // NSLog(@"Physics PlayLevel");
    if (_editMode) { // So you can only do it once before resetting.
        _editMode = NO;
        [self addNewSpriteOfType:@"BallObject" AtPosition:ballStartingPoint WithRotation:0 AsDefault:NO];
    }
}

-(void) resetBall
{
    // Delete Ball and Stars
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext()){
        if ([static_cast<AbstractGameObject*>(b->GetUserData())._tag isEqualToString:@"BallObject"])
        {
            AbstractGameObject* a = static_cast<AbstractGameObject*>(b->GetUserData());
            CCSprite* sprite = [a getSprite];
            [self removeChild: sprite cleanup:YES];
            [self deleteObjectWithBody:b];
        }
        
        if ([static_cast<AbstractGameObject*>(b->GetUserData())._tag isEqualToString:@"StarObject"])
        {
            AbstractGameObject* a = static_cast<AbstractGameObject*>(b->GetUserData());
            CCSprite* sprite = [a getSprite];
            [self removeChild: sprite cleanup:YES];
            [self deleteObjectWithBody:b];
        }
    }
    // put back all the stars from the JSON file
    for (NSArray* item in _initialObjects) {
        NSString* type = [item objectAtIndex:0];
        if ([type isEqualToString: @"StarObject"])
        {
            CGFloat px = [[item objectAtIndex:1] floatValue];
            CGFloat py = [[item objectAtIndex:2] floatValue];
            CGFloat rotation = [[item objectAtIndex:3] floatValue];
            [self addNewSpriteOfType:type AtPosition:ccp(px,py) WithRotation:rotation AsDefault:YES];
        }
    }
    // make level editable again
    _editMode = YES;
    
}


/* hitStar:
 * removes star from screen when it is hit
 */
-(void) hitStar:(b2Body*) starBody
{
    NSAssert(starBody, @"Star body in hitStar in Physics Layer is null.");
    
    // delete the star sprite
    AbstractGameObject* starBodyObject = static_cast<AbstractGameObject*>(starBody->GetUserData());
    CCSprite* sprite = [starBodyObject getSprite];
    [self removeChild: sprite cleanup:YES];
    
    // delete the star body
    // (this doesn't actually happen 'till end of collision because
    //  hitStar is called inside the update function, but it doesn't seem to matter.)
    world->DestroyBody(starBody);
    
    [self updateStarCount];
}

/* applyMagnets:
 * helper function to apply magnet's forces to the ball
 */
-(void) applyMagnets
{
    int magnetConstant = 45;
    //find all the magnets
    for (b2Body* magnet = world->GetBodyList(); magnet; magnet = magnet->GetNext()){
        if ([static_cast<AbstractGameObject*>(magnet->GetUserData())._tag isEqualToString:@"MagnetObject"])
        {
            //get the ball's body
            for (b2Body* ball = world->GetBodyList(); ball; ball = ball->GetNext()){
                if ([static_cast<AbstractGameObject*>(ball->GetUserData())._tag isEqualToString:@"BallObject"])
                {
                    //AbstractGameObject* a = static_cast<AbstractGameObject*>(ball->GetUserData());
                    
                    double distance = ({double d1 = magnet->GetPosition().x - ball->GetPosition().x, d2 = ball->GetPosition().y - magnet->GetPosition().y; sqrt(d1 * d1 + d2 * d2); });
                    
                    b2Vec2 direction = b2Vec2(magnetConstant/(distance*distance*(magnet->GetPosition().x - ball->GetPosition().x)), magnetConstant/(distance*distance*(magnet->GetPosition().y - ball->GetPosition().y)));
                    
                    ball->ApplyForce(direction, ball->GetPosition());
                    
                }
            }
        }
    }
}

-(void) setTarget:(id) sender atAction:(SEL)action
{
    NSAssert1(sender, @"Sender %@ for PhysicsLayer setTarget is null.", sender);
    NSAssert(action, @"Selector for PhysicsLayer setTarget is null.");
    
    _target = sender;
    if (!_selector1) {
        _selector1 = action;
    }
    else if (!_selector2) {
        _selector2 = action;
    }//else{
    // _selector3 = action;
    //}
    
    
    else if (!_selector3)
    {
        _selector3 = action;
    }
    else if (!_selector4)
    {
        _selector4 = action;
    }else{
        _selector5 = action;
    }
}

/* gameWon:
 * indicates the game is won when the ball hits the portal
 */
-(void) gameWon
{
    [_target performSelector:_selector2];
}

/* updateStarCount:
 * causes star count to be updated when a star is hit
 */
-(void) updateStarCount
{
    [_target performSelector:_selector3];
}

/* getObjectType:
 * gets type of object to be added to screen
 */
- (NSString*) getObjectType
{
    return [_target performSelector:_selector1];
}
-(bool) isDeleteSelected
{
    return [_target performSelector:_selector4];
}
-(void) objectDeletedOfType: (NSString*) type
{
    [_target performSelector:_selector5 withObject:type];
}

/* deleteObjectWithBody:
 * deletes a physics body from the physics layer
 */

-(void) deleteObjectWithBody: (b2Body*) body
{
    NSLog(@"we are deleting object with body");
    NSString* objectType = static_cast<AbstractGameObject*>(body->GetUserData())._tag;
    [self objectDeletedOfType:objectType];
    world->DestroyBody(body);
}

//-----BUILT-IN/BOX 2D-----//

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
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

/* update:
 * simulates a time step in the physics world
 */
-(void) update: (ccTime) dt
{
	//It is recommended that a fixed time step is used with Box2D for stability
	//of the simulation, however, we are using a variable time step here.
	//You need to make an informed choice, the following URL is useful
	//http://gafferongames.com/game-physics/fix-your-timestep/
	
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
	
	// Instruct the world to perform a single step of simulation. It is
	// generally best to keep the time step and iterations fixed.
	world->Step(dt, velocityIterations, positionIterations);
    
    if (_contactListener->_gameWon) {
        _contactListener->_gameWon = false;
        [self gameWon];
    }
    if (_contactListener->_contactStar != NULL) {
        [self hitStar:(_contactListener->_contactStar)];
        _contactListener->_contactStar = NULL;
    }
    [self applyMagnets];
}


//-----TOUCHING WITH DRAGGING-----//

-(void)registerWithTouchDispatcher
{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // NSLog(@"Physics touch began");
    //Get tap location and convert to cocos2d-box2d coordinates
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 location = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
   
    
    // Make a small box.
    b2AABB aabb;
    b2Vec2 d;
    d.Set(0.001f, 0.001f);
    aabb.lowerBound = location - d;
    aabb.upperBound = location + d;
    
    // Query the world for overlapping shapes.
    QueryCallback callback(location);
    world->QueryAABB(&callback, aabb);
    
    b2Body* body = callback.m_object;
    

    if (body) {
        AbstractGameObject* bodyObject = static_cast<AbstractGameObject*>(body->GetUserData());
        if (!bodyObject->_isDefault && _editMode) {
            bool isDelete = [self isDeleteSelected];
            //_objectType = [self getObjectType];
            // NSLog(@"%@ is the object type", _objectType);
            if (isDelete) {
                CCSprite* sprite = [bodyObject getSprite];
                [self removeChild: sprite cleanup:YES];
                [self deleteObjectWithBody:body];
                //                NSString* objectType = static_cast<AbstractGameObject*>(body->GetUserData())._tag;
                //                [self objectDeletedOfType:objectType];
                //                world->DestroyBody(body);
            } else {
                // calculate the offset between the touch and the center of the object
                b2Vec2 bodyLocation = body->GetPosition();
                xOffset = bodyLocation.x - location.x;
                yOffset = bodyLocation.y - location.y;
                 _initialPostion = b2Vec2(touchLocation.x/PTM_RATIO + xOffset,touchLocation.y/PTM_RATIO + yOffset);
                body->SetType(b2_staticBody);
                currentMoveableBody = body;
            }
        }
    }
    return YES;
}
-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // NSLog(@"Physics touch moved");
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 location = b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    
    if (currentMoveableBody != NULL) {
        b2Vec2 newPos = b2Vec2(location.x + xOffset, location.y + yOffset);
        currentMoveableBody->SetTransform(newPos,currentMoveableBody->GetAngle());
    }
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    // NSLog(@"Physics touch cancelled");
    currentMoveableBody = NULL;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // NSLog(@"Physics touch ended");
    CGPoint location = [touch locationInView: [touch view]];
    
    
    if (currentMoveableBody != NULL) {
        NSLog(@"we are in the if statement");
        location = [[CCDirector sharedDirector] convertToGL: location];
        location = [self convertToNodeSpace:location];
        
        b2Fixture* f = currentMoveableBody->GetFixtureList();
        b2PolygonShape* polygonShape = (b2PolygonShape*)f->GetShape();
        int count = polygonShape->GetVertexCount();
        
        CGFloat offset = self.boundingBox.origin.x;
        
        for(int i = 0; i < count; i++)
        {
            CGFloat xCoordinate =(CGFloat) (&polygonShape->GetVertex(i))->x;
            CGFloat yCoordinate = (CGFloat) (&polygonShape->GetVertex(i))->y;
            CGPoint point = ccpMult(CGPointMake(xCoordinate, yCoordinate), PTM_RATIO);
            CGPoint boundPoint = CGPointMake(point.x + location.x + offset, point.y + location.y);
            boundPoint = [[CCDirector sharedDirector] convertToGL: boundPoint];
            
            if ( !CGRectContainsPoint(self.boundingBox, boundPoint))
            {
                currentMoveableBody->SetTransform(_initialPostion, currentMoveableBody->GetAngle());
                NSLog(@"Body dragged into walls");
            }
        }
        currentMoveableBody = NULL;
    } else if (_editMode) {
        
        //Add a new body/atlas sprite at the touched location
        
        if (CGRectContainsPoint(self.boundingBox, location)) {
            
            location = [[CCDirector sharedDirector] convertToGL: location];
            location = [self convertToNodeSpace:location];
            
            // get object type from inventory
            _objectType = [self getObjectType];
            // NSLog(@"%@, is object type", _objectType);
            if(_objectType && ![_objectType isEqualToString:@"None"] && ![_objectType isEqualToString:@"Delete"]){
                [self addNewSpriteOfType:_objectType AtPosition:location WithRotation:0 AsDefault:NO];
            }
        }
    }
}

//-----DEALLOC-----//

-(void) dealloc
{
	delete m_debugDraw;
	m_debugDraw = NULL;
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        b->SetAwake(false);
    }
    
    for (b2Body* b = world->GetBodyList(); b; b = b->GetNext())
    {
        world->DestroyBody(b);
    }
    
    delete world;
	world = NULL;
	
	[super dealloc];
}

@end
