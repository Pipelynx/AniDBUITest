//
//  LoginViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 24.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "LoginViewController.h"
#import "MWLogging.h"
#import "BaseTableViewController.h"
#import "AnimeTableViewController.h"

@interface LoginViewController ()

@end

static BOOL ignoreLogin = NO;

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"];
    
    [self.username setText:username];
    [self.password setText:password];
    
    if ([self.anidb hasSession]) {
        self.loggedOut = NO;
        [self.anidb logout];
        [self.activityIndicator startAnimating];
        [self.activity setText:@"Establishing connection..."];
    }
    else {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginValid"] && !self.loggedOut)
            [self login:self];
        else {
            [self.activityIndicator stopAnimating];
            [self.activity setText:@"Please log in"];
            [self.loginButton setEnabled:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)login:(id)sender {
    if (ignoreLogin) {
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(segueWithTimer:) userInfo:nil repeats:NO];
        return;
    }
    if ([self.username.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Insufficient input" message:@"Please type in a username." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if ([self.password.text isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"Insufficient input" message:@"Please type in a password." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    [[NSUserDefaults standardUserDefaults] setValue:username forKey:@"username_preference"];
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password_preference"];
    
    [self.activityIndicator startAnimating];
    [self.username setEnabled:NO];
    [self.password setEnabled:NO];
    [self.activity setText:@"Login sent..."];
    [self.anidb loginWithUsername:username andPassword:password];
}

- (void)connection:(ADBConnection *)connection didReceiveResponse:(NSDictionary *)response {
    [self.activityIndicator stopAnimating];
    switch ([response[@"responseType"] intValue]) {
        case ADBResponseCodeLoginAccepted:
            [self.activity setText:@"Login successful"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginValid"];
            [[NSUserDefaults standardUserDefaults] setURL:self.anidb.imageServerURL forKey:@"imageServer"];
            if (self.isViewLoaded && self.view.window)
                [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
            //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(logoutWithTimer:) userInfo:nil repeats:NO];
            break;
            
        case ADBResponseCodeLoginAcceptedNewVersion:
            [self.activity setText:@"Login successful, new version available, please update"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginValid"];
            [[NSUserDefaults standardUserDefaults] setURL:self.anidb.imageServerURL forKey:@"imageServer"];
            if (self.isViewLoaded && self.view.window)
                [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
            //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(logoutWithTimer:) userInfo:nil repeats:NO];
            break;
            
        case ADBResponseCodeLoginFailed:
            [self.activity setText:@"Login failed, please enter a correct username and password and try again"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loginValid"];
            [self.username setEnabled:YES];
            [self.password setEnabled:YES];
            break;
        
        case ADBResponseCodePong:
        case ADBResponseCodeLoggedOut:
        case ADBResponseCodeLoginFirst:
            [self.activity setText:@"Connection established, please log in"];
            [self.loginButton setEnabled:YES];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginValid"] && !self.loggedOut)
                [self login:self];
            break;
            
        default:
            MWLogInfo(@"%@", response);
            if (self.isViewLoaded && self.view.window)
                [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
            break;
    }
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    MWLogInfo(@"%@", response);
    [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
}

- (void)logoutWithTimer:(NSTimer *)timer {
    [self.anidb logout];
}

- (void)segueWithTimer:(NSTimer *)timer {
    if (self.isViewLoaded && self.view.window)
        [self performSegueWithIdentifier:@"LoginSuccessful" sender:timer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginSuccessful"]) {
        [self.anidb removeDelegate:self];
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:AnimeEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"romajiName" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"fetched > 0"]];
        
        [(BaseTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController] setContentController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil]];
        
        fetchRequest = [NSFetchRequest fetchRequestWithEntityName:AnimeEntityIdentifier];
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"romajiName" ascending:YES]]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"fetched > 0"]];
        [(AnimeTableViewController *)[(UINavigationController *)segue.destinationViewController topViewController] setSearchResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.anidb.managedObjectContext sectionNameKeyPath:nil cacheName:nil]];
    }
}

@end
