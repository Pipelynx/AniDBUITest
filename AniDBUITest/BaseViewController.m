//
//  BaseViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

@synthesize anidb;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    [self.anidb addDelegate:self];
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
}

- (void)setBackgroundImage:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 2.0f);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
    CGContextFillRect(c, self.view.bounds);
    [image drawAtPoint:CGPointMake(0, 0)];
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    CGFloat locations[3] = { 0.0, 0.4, 0.5 };
    
    NSArray *colors = @[(id)[self.view.backgroundColor colorWithAlphaComponent:0.1].CGColor,
                        (id)[self.view.backgroundColor colorWithAlphaComponent:0.7].CGColor,
                        (id)self.view.backgroundColor.CGColor];
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);
    
    CGContextDrawLinearGradient(c, gradient, self.view.bounds.origin, CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height), 0);
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()]];
    UIGraphicsEndImageContext();
}

- (void)saveAnidb {
    NSError *error = nil;
    [anidb save:&error];
    if (error)
        NSLog(@"%@", error);
}

#pragma mark - Anidb delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    [self reloadData];
    [self saveAnidb];
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [self reloadData];
    [self saveAnidb];
}

@end
