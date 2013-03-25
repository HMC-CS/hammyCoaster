//
//  QueryCallback.mm
//  Team1Game3
//
//  Created by mchesley on 3/24/13.
//
//

#include "QueryCallback.h"

QueryCallback::QueryCallback(const b2Vec2& point)
{
    m_point = point;
    m_object = nil;
}
    
bool QueryCallback::ReportFixture(b2Fixture* fixture)
{
    if (fixture->IsSensor()) return true; //ignore sensors
    
    bool inside = fixture->TestPoint(m_point);
    if (inside)
    {
        // We are done, terminate the query.
        m_object = fixture->GetBody();
        return false;
    }
    
    // Continue the query.
    return true;
}