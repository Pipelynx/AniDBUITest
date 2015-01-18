//
//  TabBarController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 17.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "TabBarController.h"

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[ADBPersistentConnection sharedConnection] connect];
}

@end
