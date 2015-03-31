//
//  ViewController.m
//  GPS Tester
//
//  Created by Chris Bennett on 3/23/15.
//  Copyright (c) 2015 Chris Bennett. All rights reserved.
//

#import "ViewController.h"

#define V_MAX 25.0
#define V_MIN 1.0

@interface ViewController ()

@property CLLocationManager *locationManager;

@property NSMutableArray *locationArray;
@property NSMutableDictionary *velocityDictionary;
@property CLLocation *lastLocation;

@property float maxSpeed;

@property BOOL isRecording;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSString *string = [AAKMLWriter startKMLFile];
    NSLog(@"%@",string);
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.map.delegate = self;
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 5; // meters
    // Do any additional setup after loading the view, typically from a nib.
    self.isRecording = false;
    self.maxSpeed = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startButtonPressed:(id)sender {
    
    self.isRecording = !self.isRecording;
    
    if (self.isRecording) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        [self.startButton setTitle:@"Stop Updates" forState:UIControlStateNormal];
    }
    else{
        [self.locationManager stopUpdatingLocation];
        [self.startButton setTitle:@"Start Updates" forState:UIControlStateNormal];
    }
        
    

}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        if (!self.locationArray) {
            self.locationArray = [NSMutableArray array];
            self.velocityDictionary = [NSMutableDictionary dictionary];
            CLLocationCoordinate2D  startpoint = location.coordinate;
            MKPointAnnotation *addAnnotation = [[MKPointAnnotation alloc] init];
            [addAnnotation setCoordinate:startpoint];
            [self.map addAnnotation:addAnnotation];
            MKMapPoint annotationPoint = MKMapPointForCoordinate(startpoint);
            MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.0, 0.0);
            [self.map setVisibleMapRect:zoomRect animated:YES];


            
            [self.locationArray addObject:location];
        }
        else if(self.lastLocation){
            [self.locationArray addObject:location];
            
            CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D)* 2);
            coords[1]=location.coordinate;
            coords[0]=self.lastLocation.coordinate;
            
            MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:2];
            polyline.title = (NSString *)@(location.speed);
            [self.map addOverlay:polyline];
            [self.velocityDictionary setObject:@(location.speed) forKey:[NSValue valueWithNonretainedObject:polyline]];
            free(coords);

        }
        
        self.lastLocation = location;
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        float velocity = [((NSNumber *)((MKShape *)overlay).title) floatValue];
        float normVeloctiy = MAX(MIN(V_MAX,velocity),V_MIN);
        normVeloctiy = (normVeloctiy) / (V_MAX - V_MIN);
        MKPolylineRenderer *mapOverlayView = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        mapOverlayView.strokeColor = [UIColor colorWithRed:1-normVeloctiy green:normVeloctiy blue:0 alpha:1];
        mapOverlayView.lineWidth = 4;
        return mapOverlayView;
    }
    
    return nil;
}
@end
