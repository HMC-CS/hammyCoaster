//
//  QueryCallback.h
//  Team1Game3
//
//  Created by mchesley on 3/24/13.
//
//

#import "cocos2d.h"
#import "Box2D.h"

class QueryCallback : public b2QueryCallback
{
public:
    QueryCallback(const b2Vec2& point);
    b2AABB getAABB(float boxSize);
    b2Body* getm_object();
    
private:
    bool ReportFixture(b2Fixture* fixture);
    b2Vec2  m_point;
    b2Body* m_object;
};