//
//  BaseViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 28.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBPersistentConnection.h"

@interface BaseViewController : UIViewController <ADBPersistentConnectionDelegate>

@property (weak, nonatomic) ADBPersistentConnection *anidb;

@end
