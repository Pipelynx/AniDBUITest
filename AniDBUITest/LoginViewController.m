//
//  LoginViewController.m
//  AniDBUITest
//
//  Created by Martin Fellner on 24.01.15.
//  Copyright (c) 2015 Pipelynx. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseTableViewController.h"
#import "AnimeTableViewController.h"

@interface LoginViewController ()

@end

static BOOL ignoreLogin = YES;

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"username_preference"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password_preference"];
    
    [self.username setText:username];
    [self.password setText:password];
    [self.activity setText:@""];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"loginValid"]) {
        [self login:self];
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
            [[NSUserDefaults standardUserDefaults] setURL:[self.anidb getImageServer] forKey:@"imageServer"];
            [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
            //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(logoutWithTimer:) userInfo:nil repeats:NO];
            break;
            
        case ADBResponseCodeLoginAcceptedNewVersion:
            [self.activity setText:@"Login successful, new version available, please update"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"loginValid"];
            [[NSUserDefaults standardUserDefaults] setURL:[self.anidb getImageServer] forKey:@"imageServer"];
            [self performSegueWithIdentifier:@"LoginSuccessful" sender:self];
            //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(logoutWithTimer:) userInfo:nil repeats:NO];
            break;
            
        case ADBResponseCodeLoginFailed:
            [self.activity setText:@"Login failed, please enter a correct username and password and try again"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"loginValid"];
            [self.username setEnabled:YES];
            [self.password setEnabled:YES];
            break;
            
        default:
            break;
    }
}

- (void)persistentConnection:(ADBPersistentConnection *)connection didReceiveResponse:(NSManagedObject *)response {
    
}

- (void)logoutWithTimer:(NSTimer *)timer {
    [self.anidb logout];
}

- (void)segueWithTimer:(NSTimer *)timer {
    [self performSegueWithIdentifier:@"LoginSuccessful" sender:timer];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"LoginSuccessful"]) {
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
