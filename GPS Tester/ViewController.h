//
//  ViewController.h
//  GPS Tester
//
//  Created by Chris Bennett on 3/23/15.
//  Copyright (c) 2015 Chris Bennett. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "KML.h"
#import "AAKMLWriter.h"
#import "AAGPSPoint.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

- (IBAction)startButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIButton *startButton;




@end

