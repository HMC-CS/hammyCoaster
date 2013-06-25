//
//  MyRayCastCallback.cpp
//  Team1Game3
//
//  Created by Jean Sung on 6/25/13.
//
//

#include "MyRayCastCallback.h"


class MyRayCastCallback : public b2RayCastCallback

{
    
public:
    
    MyRayCastCallback()
    
    {
        
        m_fixture = NULL;
        
    }
    
    
    
    float32 ReportFixture(b2Fixture* fixture, const b2Vec2& point,
                          
                          const b2Vec2& normal, float32 fraction)
    
    {
        
        m_fixture = fixture;
        
        m_point = point;
        
        m_normal = normal;
        
        m_fraction = fraction;
        
        return fraction;
        
    }
    
    
    
    b2Fixture* m_fixture;
    
    b2Vec2 m_point;
    
    b2Vec2 m_normal;
    
    float32 m_fraction;
    
};



MyRayCastCallback callback;

b2Vec2 point1(-1.0f, 0.0f);

b2Vec2 point2(3.0f, 1.0f);

//_->RayCast(&callback, point1, point2);