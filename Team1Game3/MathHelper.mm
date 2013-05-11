//
//  MathHelper.c
//  Team1Game3
//
//  Created by Michelle Chesley, Priya Donti, Claire Murphy, and Carson Ramsden on 5/9/13.
//
//

#include "MathHelper.h"

#import "Box2D.h"  // For M_PI

float GetAngle(float x1, float y1, float x2, float y2) {
    
    float dx, dy, res;
    
    dx = x1 - x2;
    dy = y1 - y2;
    
    if ( fabs(dx) < 0.0000001f && fabs(dy) < 0.0000001f ) {
        return 0;
    }
    
    if ( dx == 0 && y1 > y2 ) {   return 0;   }
    if ( dy == 0 && x1 < x2 ) {   return (0.5 * M_PI);  }
    if ( dx == 0 && y1 < y2 ) {   return M_PI; }
    if ( dy == 0 && x1 > x2 ) {   return (M_PI + (0.5 * M_PI)); }
    
    res = atanf( dy / dx );

    if ( res < 0 ) {
        res = (0.5 * M_PI) + res;
    }
    
    if ( x1 > x2  && y1 < y2 ) {            // 2nd quadrant
        res += 0.5 * M_PI;
    } else if ( x1 > x2 && y1 > y2 ) { 		// 3rd quadrant
        res += M_PI;
    } else if ( x1 < x2 && y1 > y2 ) {		// 4th quadrant
        res += M_PI + (0.5 * M_PI);
    }

    return res;
}