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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.anidb = [ADBPersistentConnection sharedConnection];
    [self.anidb addDelegate:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    NSError *error = nil;
    [self.anidb save:&error];
    if (error)
        NSLog(@"%@", error);
}

@end
