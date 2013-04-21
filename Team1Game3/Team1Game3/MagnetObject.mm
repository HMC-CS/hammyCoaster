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
    
    _bodyDef.type = b2_staticBody;
    _bodyDef.position.Set(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = self->_world->CreateBody(&_bodyDef);
    
    // TODO: magnet with north and south poles
//    NSLog(@"trying to get sprite bounding box");
//    
//    float objectWidth = _sprite.boundingBox.size.width;
//    float objectHeight = _sprite.boundingBox.size.height;
//    
//    NSLog(@"starting north shape");
//    b2PolygonShape northShape;
//    b2Vec2 northCenter = b2Vec2(location.x/PTM_RATIO + objectWidth/2, objectHeight);
//    northShape.SetAsBox(objectWidth/2, objectHeight, northCenter, 0);
//    _fixtureDef.shape = &northShape;
//    _fixtureDef.density = 1.0f;
//    _fixtureDef.friction = 0.4f;
//    _fixtureDef.restitution = 0.3f;
//    body->CreateFixture(&_fixtureDef);
//    
//    NSLog(@"starting south shape");
//    b2PolygonShape southShape;
//    b2Vec2 southCenter = b2Vec2(location.x/PTM_RATIO - objectWidth/2, objectHeight);
//    southShape.SetAsBox(objectWidth/2, objectHeight, southCenter, 0);
//    _fixtureDef.shape = &southShape;
//    _fixtureDef.density = 1.0f;
//    _fixtureDef.friction = 0.4f;
//    _fixtureDef.restitution = 0.3f;
//    body->CreateFixture(&_fixtureDef);
    
    b2CircleShape circle;
    circle.m_radius = 26.0/PTM_RATIO;
    
    _fixtureDef.shape = &circle;
    _fixtureDef.density = 1.0f;
    _fixtureDef.friction = 0.4f;
    _fixtureDef.restitution = 0.3f;
    
    body->CreateFixture(&_fixtureDef);
    body->SetUserData(self);
    
    return body;
}

@end
