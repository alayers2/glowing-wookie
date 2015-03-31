//
//  AAGPSPoint.m
//  GPS Tester
//
//  Created by Chris Bennett on 3/31/15.
//  Copyright (c) 2015 Chris Bennett. All rights reserved.
//

#import "AAGPSPoint.h"

@implementation AAGPSPoint

-(id)initWithTimestamp:(NSDate *)date
          andLongitude:(float)longitude
           andLatitude:(float)latitude
           andAltitude:(float)altitude
              andSpeed:(float)speed
           andAccuracy:(float)accuracy
{
    
    self = [super init];
    if (self) {
        self.timestamp = date;
        self.latitude = latitude;
        self.longitude = longitude;
        self.altitude = altitude;
        self.speed = speed;
        self.accuracy = accuracy;
    }
    
    return self;
}


@end
