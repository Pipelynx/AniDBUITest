//
//  LoginViewController.h
//  AniDBUITest
//
//  Created by Martin Fellner on 24.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBPersistentConnection.h"

@interface LoginViewController : UIViewController <ADBPersistentConnectionDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activity;

- (IBAction)login:(id)sender;

@end
