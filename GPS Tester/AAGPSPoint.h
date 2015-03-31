//
//  AAGPSPoint.h
//  GPS Tester
//
//  Created by Chris Bennett on 3/31/15.
//  Copyright (c) 2015 Chris Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAGPSPoint : NSObject

@property (nonatomic) NSDate *timestamp;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) float altitude;
@property (nonatomic) float speed;
@property (nonatomic) float accuracy;

-(id)initWithTimestamp:(NSDate *)date
          andLongitude:(float)longitude
           andLatitude:(float)latitude
           andAltitude:(float)altitude
              andSpeed:(float)speed
           andAccuracy:(float)accuracy;

@end
