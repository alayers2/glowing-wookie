//
//  AAKMLWriter.m
//  GPS Tester
//
//  Created by Andrew Ayers on 3/30/15.
//  Copyright (c) 2015 Chris Bennett. All rights reserved.
//

#import "AAKMLWriter.h"

@interface AAKMLWriter()

@property (nonatomic) NSMutableArray *kmlArray;

@property (nonatomic) NSString *name;

@property (nonatomic) NSString *kmldescription;

@property (nonatomic) NSDateFormatter *formatter;

@end


@implementation AAKMLWriter

-(id)init
{
    self = [super init];
    if (self) {
        self.kmlArray = [NSMutableArray array];
        
        
        self.formatter = [[NSDateFormatter alloc] init];
        self.formatter.dateFormat = @"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'";
        
    }
    
    return self;
}

-(void)openKMLWithName:(NSString *)name andAuthor:(NSString *)author andDescription:(NSString *)description
{
    self.name = name;
    self.kmldescription = description;
    
    [self.kmlArray addObject:@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"];
    [self.kmlArray addObject:@"<kml xmlns=\"http://www.opengis.net/kml/2.2\" xmlns:gx=\"http://www.google.com/kml/ext/2.2\" xmlns:atom=\"http://www.w3.org/2005/Atom\">"];
    [self.kmlArray addObject:@"<Document>"];
    [self.kmlArray addObject:@"<open>1</open>"];
    [self.kmlArray addObject:[NSString stringWithFormat:@"<name><![CDATA[%@]]></name>",self.name]];
    [self.kmlArray addObject:[NSString stringWithFormat:@"<atom:author><atom:name><![CDATA[Created with iOS GPS Tester by %@.]]></atom:name></atom:author>",author]];
    [self.kmlArray addObject:@"<Schema id=\"schema\"></Schema>"];
    
    //Add Style Array for track
    [self.kmlArray addObjectsFromArray:[self generateStyleArraywithName:@"redtrack" width:4 color:@"7f0000ff" andLink:@"http://maps.google.com/mapfiles/kml/paddle/grn-circle.png"]];
}


-(void)closeKML
{
    [self.kmlArray addObject:@"</Document>"];
    [self.kmlArray addObject:@"</kml>"];
}

-(void)writeKMLToFile:(NSString *)filepath
{
 
    NSString *xmlString = [self.kmlArray componentsJoinedByString:@"\n"];
    
    [xmlString writeToFile:filepath atomically:TRUE encoding:NSUTF8StringEncoding error:nil];

}

-(NSArray *)generateStyleArraywithName:(NSString *)name width:(int)width color:(NSString *)color andLink:(NSString *)link
{
    NSMutableArray *styleArray = [NSMutableArray array];
    
    [styleArray addObject:[NSString stringWithFormat:@"<Style id=\"%@\">",name]];
    [styleArray addObject:@"<LineStyle>"];
    [styleArray addObject:[NSString stringWithFormat:@"<color>%@</color>",color]];
    [styleArray addObject:[NSString stringWithFormat:@"<width>%d</width>",width]];
    [styleArray addObject:@"</LineStyle>"];
    [styleArray addObject:@"<IconStyle>"];
    [styleArray addObject:@"<scale>0.5</scale>"];
    [styleArray addObject:[NSString stringWithFormat:@"<Icon><href>%@</href></Icon>",link]];
    [styleArray addObject:@"</IconStyle>"];
    [styleArray addObject:@"</Style>"];
    
    return styleArray;
    
}

-(void)addCoordsFromArray:(NSArray *)array
{
    NSMutableArray *coordsArray = [NSMutableArray array];
    
    [coordsArray addObject:@"<Placemark id=\"tour\">"];

    [coordsArray addObject:[NSString stringWithFormat:@"<name><![CDATA[%@]]></name>",self.name]];
    [coordsArray addObject:[NSString stringWithFormat:@"<description><![CDATA[%@]]></description>",self.description]];

    [coordsArray addObject:@"<visibility>1</visibility>"];
    [coordsArray addObject:[NSString stringWithFormat:@"<styleUrl>%@</styleUrl>",@"redtrack"]];
    [coordsArray addObject:@"<gx:MultiTrack>"];

    [coordsArray addObject:@"<altitudeMode>absolute</altitudeMode>"];
    [coordsArray addObject:@"<gx:interpolate>1</gx:interpolate>"];
    [coordsArray addObject:@"<gx:Track>"];

    
    for(AAGPSPoint *point in array)
    {
        NSDate *timestamp = point.timestamp;
        NSString *stringdate = [self.formatter stringFromDate:timestamp];
        
        [coordsArray addObject:[NSString stringWithFormat:@"<when>%@</when>",stringdate]];
        
        [coordsArray addObject:[NSString stringWithFormat:@"<gx:coord>%f %f %f</gx:coord>",point.longitude,point.latitude,point.altitude]];
    }
   
    [coordsArray addObject:@"<ExtendedData>"];
    [coordsArray addObject:@"\n<SchemaData schemaUrl=\"#schema\"></SchemaData>"];
    [coordsArray addObject:@"<gx:SimpleArrayData name=\"speed\">"];
    
    for (AAGPSPoint *point in array) {
        [coordsArray addObject:[NSString stringWithFormat:@"<gx:value>%f</gx:value>",point.speed]];
    }
    
    [coordsArray addObject:@"</gx:SimpleArrayData>"];
    
    [coordsArray addObject:@"<gx:SimpleArrayData name=\"bearing\">"];
    for (AAGPSPoint *point in array) {
        [coordsArray addObject:[NSString stringWithFormat:@"<gx:value>%f</gx:value>",point.bearing]];
    }
    [coordsArray addObject:@"</gx:SimpleArrayData>"];
    
    [coordsArray addObject:@"<gx:SimpleArrayData name=\"accuracy\">"];
    for (AAGPSPoint *point in array) {
        [coordsArray addObject:[NSString stringWithFormat:@"<gx:value>%f</gx:value>",point.accuracy]];
    }
    [coordsArray addObject:@"</gx:SimpleArrayData>"];

    
    [coordsArray addObject:@"</ExtendedData>"];
    [coordsArray addObject:@"</gx:Track>"];
    [coordsArray addObject:@"</gx:MultiTrack>"];
    [coordsArray addObject:@"</Placemark>"];
    
    [self.kmlArray addObjectsFromArray:coordsArray];
}


@end
