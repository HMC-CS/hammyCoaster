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
    b2Body* m_object;
    QueryCallback(const b2Vec2& point);
    
private:
    bool ReportFixture(b2Fixture* fixture);
    b2Vec2  m_point;
};