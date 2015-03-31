//
//  AAKMLWriter.m
//  GPS Tester
//
//  Created by Andrew Ayers on 3/30/15.
//  Copyright (c) 2015 Chris Bennett. All rights reserved.
//

#import "AAKMLWriter.h"

@implementation AAKMLWriter

+(NSString *)startKMLFile
{
    XMLWriter* xmlWriter = [[XMLWriter alloc]init];
    
    [xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
    [xmlWriter writeStartElement:@"Root"];
    [xmlWriter writeStartElement:@"Element"];
    [xmlWriter writeCharacters:@"This is an example"];
    [xmlWriter writeEndElement];
    [xmlWriter writeEndElement];

    return [xmlWriter toString];
}

@end
