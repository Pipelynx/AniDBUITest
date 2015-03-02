//
//  BaseViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "BaseViewController.h"
#import "MWLogging.h"

@interface BaseViewController ()

@property (strong, nonatomic) UIImage *backgroundImage;
@property (strong, nonatomic) UIImage *originalImage;

@end

@implementation BaseViewController

@synthesize anidb;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    
    [self.anidb fetch:self.representedObject];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.anidb addDelegate:self];
    [self reloadData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.anidb removeDelegate:self];
}

- (void)reloadData {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self drawBackground];
}

- (void)drawBackground {
    if (_backgroundImage)
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:_backgroundImage]];
}

- (void)setBackgroundImage:(UIImage *)image {
    if (_originalImage != image) {
        _originalImage = image;
        _backgroundImage = [self backgroundFromImage:_originalImage];
    }
    [self drawBackground];
}

- (void)setBackgroundImageWithURL:(NSURL *)imageURL {
    [[SDWebImageManager sharedManager] downloadImageWithURL:imageURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //MWLogInfo(@"%li/%li", (long)receivedSize, (long)expectedSize);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (finished)
            [self setBackgroundImage:image];
        else
            MWLogError(@"%@", error);
    }];
}

- (UIImage *)backgroundFromImage:(UIImage *)image {
    CGFloat side = MAX(self.view.bounds.size.height, self.view.bounds.size.width);
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(side, side), YES, 2.0f);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, self.view.backgroundColor.CGColor);
    CGContextFillRect(c, self.view.bounds);
    [image drawAtPoint:CGPointMake(0, 0)];
    CGGradientRef gradient;
    CGFloat locations[3] = { 0.0, 0.4, 0.5 };
    NSArray *colors = @[(id)[self.view.backgroundColor colorWithAlphaComponent:0.1].CGColor,
                        (id)[self.view.backgroundColor colorWithAlphaComponent:0.7].CGColor,
                        (id)self.view.backgroundColor.CGColor];
    gradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(), (CFArrayRef)colors, locations);
    CGContextDrawLinearGradient(c, gradient, self.view.bounds.origin, CGPointMake(side, side), 0);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (void)saveAnidb {
    NSError *error = nil;
    [anidb save:&error];
    if (error)
        MWLogError(@"%@", error);
}

#pragma mark - Anidb delegate

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    if (![response hasResponseCode:ADBResponseCodeLoggedOut])
        [self reloadData];
    [self saveAnidb];
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    [self reloadData];
    [self saveAnidb];
}

@end
