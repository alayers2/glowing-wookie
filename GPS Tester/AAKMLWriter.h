//
//  AAKMLWriter.h
//  GPS Tester
//
//  Created by Andrew Ayers on 3/30/15.
//  Copyright (c) 2015 Chris Bennett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLWriter.h"
#import "AAGPSPoint.h"

@interface AAKMLWriter : NSObject

-(void)openKMLWithName:(NSString *)name andAuthor:(NSString *)author andDescription:(NSString *)description;

-(void)closeKML;

-(void)writeKMLToFile:(NSString *)filepath;

-(void)addCoordsFromArray:(NSArray *)coordsArray;

-(NSArray *)generateStyleArraywithName:(NSString *)name width:(int)width color:(NSString *)color andLink:(NSString *)link;

@end


