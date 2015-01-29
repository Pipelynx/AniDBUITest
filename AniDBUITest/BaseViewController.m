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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
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
