//
//  MagnetObject.m
//  Team1Game3
//
//  Created by jarthur on 4/16/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MagnetObject.h"


@implementation MagnetObject

- (b2Body *)createBody:(CGPoint)location {
    
//    _bodyDef.type = b2_dynamicBody;
//    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
//    b2Body *body = self->_world->CreateBody(&_bodyDef);
//    
//    b2CircleShape circle;
//    circle.m_radius = 26.0/PTM_RATIO;
//    
//    _fixtureDef.shape = &circle;
//    _fixtureDef.density = 1.0f;
//    _fixtureDef.friction = 0.4f;
//    _fixtureDef.restitution = 0.3f;
//    
//    body->CreateFixture(&_fixtureDef);
//    body->SetUserData(self);
//    
//    return body;
//    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = self->_world->CreateBody(&_bodyDef);
    
    // TODO: magnet with north and south poles
    NSLog(@"trying to get sprite bounding box");
    
    CCSprite* sprite = [_sprites objectAtIndex:0];
    
    float objectWidth = sprite.contentSize.width;
    float objectHeight = sprite.contentSize.height;
    
    NSLog(@"starting north shape");
    b2PolygonShape northShape;
    b2Vec2 northCenter = b2Vec2(objectWidth/PTM_RATIO/4, 0);
    northShape.SetAsBox(objectWidth/PTM_RATIO/4, objectHeight/PTM_RATIO/2, northCenter, 0);
    _fixtureDef.shape = &northShape;
    _fixtureDef.density = 1.0f;
    _fixtureDef.friction = 0.4f;
    _fixtureDef.restitution = 0.3f;
    _fixtureDef.userData = @"NORTH";
    body->CreateFixture(&_fixtureDef);
    
    NSLog(@"starting south shape");
    b2PolygonShape southShape;
    b2Vec2 southCenter = b2Vec2(-1.0 * objectWidth/PTM_RATIO/4, 0);
    southShape.SetAsBox(objectWidth/PTM_RATIO/4, objectHeight/PTM_RATIO/2, southCenter, 0);
    _fixtureDef.shape = &southShape;
    _fixtureDef.density = 1.0f;
    _fixtureDef.friction = 0.4f;
    _fixtureDef.restitution = 0.3f;
    _fixtureDef.userData = @"SOUTH";
    body->CreateFixture(&_fixtureDef);
    
//    b2CircleShape circle;
//    circle.m_radius = 26.0/PTM_RATIO;
//    
//    _fixtureDef.shape = &circle;
//    _fixtureDef.density = 1.0f;
//    _fixtureDef.friction = 0.4f;
//    _fixtureDef.restitution = 0.3f;
//    
//    body->CreateFixture(&_fixtureDef);
    
    body->SetUserData(self);
    
    return body;
}

@end
