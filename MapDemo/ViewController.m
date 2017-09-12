//
//  ViewController.m
//  MapDemo
//
//  Created by Pawan kumar on 8/11/17.
//  Copyright © 2017 Pawan kumar. All rights reserved.
//

#import "ViewController.h"

#import <MapKit/MapKit.h>
#import "CustomerMapAnnotation.h"

@interface ViewController ()<MKMapViewDelegate>

@property (nonatomic, strong) IBOutlet MKMapView *mapView;

//When Select Customer by List or Map
@property (nonatomic) CustomerMapAnnotation *customAnnotation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"MAP";
    
    //Configuration Map
    [self mapConfiguration];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)mapConfiguration{
    
    [self.mapView setDelegate:self];

}

-(IBAction)addMarkerOnMapButtonAction:(id)sender{

    //Remove Agent Annotation before adding
    for (id annotationAgent in self.mapView.annotations) {
        
        if ([annotationAgent isKindOfClass:[CustomerMapAnnotation class]])
        {
            [self.mapView removeAnnotation:(CustomerMapAnnotation*)annotationAgent];
        }
    }
    
    //User Annotation
    if (self.customAnnotation == nil) {
        
        self.customAnnotation = [[CustomerMapAnnotation alloc] init];
    }
    
    self.customAnnotation.title = @"Name";
    self.customAnnotation.subtitle = [NSString stringWithFormat:@"Lat(%f) Lng(%f)",40.690549,-73.966133];
    self.customAnnotation.coordinate = CLLocationCoordinate2DMake(40.690549,-73.966133);
   
    [self.mapView addAnnotation:self.customAnnotation];
    
    //Default showing Callout
    [self.mapView selectAnnotation:self.customAnnotation animated:TRUE];
    
    //Center Map Zoom Location
    [self zoomToCurrentLocation:self.customAnnotation.coordinate];
}

#pragma mark Zoom

- (void)zoomToCurrentLocation:(CLLocationCoordinate2D)coordinate{
    
    float spanX = 0.0125;
    float spanY = 0.0125;
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = spanX;
    region.span.longitudeDelta = spanY;
    [self.mapView setRegion:region animated:YES];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[CustomerMapAnnotation class]])
    {
        NSString *customerAnnotationIdentifier = @"Custome";
        
        CustomerMapAnnotation *customerAnnotation = (CustomerMapAnnotation*)annotation;
        NSLog(@"CustomerMapAnnotation Annotation:- %@",customerAnnotation.title);
        
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customerAnnotationIdentifier];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customerAnnotationIdentifier];
            pinView.canShowCallout = YES;
            pinView.calloutOffset = CGPointMake(0, 0);//Manage Callout Top Posstion
            
        } else {
            
            pinView.annotation = annotation;
        }
        
        UIImage *markerIcon = [UIImage imageNamed:@"marker.png"];
        
        pinView.image = markerIcon;
        
        // Add a detail disclosure button to the callout.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        
        return pinView;
    }
    
    return nil;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        NSLog(@"Clicked Default Annotation");
    }
    
    if ([annotation isKindOfClass:[CustomerMapAnnotation class]])
    {
        NSLog(@"Clicked Customer Annotation");
        
        CustomerMapAnnotation *customerAnnotation = (CustomerMapAnnotation*)annotation;
   
        NSLog(@"CustomerMapAnnotation Annotation Title:- %@",customerAnnotation.title);
    }
}



@end
