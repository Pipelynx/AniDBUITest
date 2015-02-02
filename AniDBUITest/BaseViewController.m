//
//  BaseViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIImage *backgroundImage;

@end

@implementation BaseViewController

@synthesize anidb;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    [self.anidb addDelegate:self];
    
    [self.anidb fetch:self.representedObject];
    
    [self reloadData];
}

- (void)reloadData {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setBackgroundImage:(UIImage *)image {
    if (_backgroundImage != image) {
        _backgroundImage = image;
        if (_backgroundImage) {
            UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, YES, 2.0f);
            CGContextRef c = UIGraphicsGetCurrentContext();
            CGContextSetFillColorWithColor(c, [UIColor whiteColor].CGColor);
            CGContextFillRect(c, self.view.bounds);
            [_backgroundImage drawAtPoint:CGPointMake(0, 0)];
            CGGradientRef gradient;
            CGFloat locations[3] = { 0.0, 0.4, 0.5 };
            NSArray *colors = @[(id)[self.view.backgroundColor colorWithAlphaComponent:0.1].CGColor,
                                (id)[self.view.backgroundColor colorWithAlphaComponent:0.7].CGColor,
                                (id)self.view.backgroundColor.CGColor];
            gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), (CFArrayRef)colors, locations);
            CGContextDrawLinearGradient(c, gradient, self.view.bounds.origin, CGPointMake(self.view.bounds.size.width, self.view.bounds.size.height), 0);
            [self.view setBackgroundColor:[UIColor colorWithPatternImage:UIGraphicsGetImageFromCurrentImageContext()]];
            UIGraphicsEndImageContext();
        }
    }
}

- (void)saveAnidb {
    NSError *error = nil;
    [anidb save:&error];
    if (error)
        NSLog(@"%@", error);
}

#pragma mark - Anidb delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    if ([response[@"responseType"] intValue] != ADBResponseCodeLoggedOut)
        [self reloadData];
    [self saveAnidb];
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [self reloadData];
    [self saveAnidb];
}

@end
