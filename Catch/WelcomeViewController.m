//
//  WelcomeViewController.m
//  Catch
//
//  Created by Ian Fox on 8/7/14.
//  Copyright (c) 2014 Catch Labs. All rights reserved.
//
#import <Parse/Parse.h>
#import "WelcomeViewController.h"
#import "CircleButton.h"
#import "Utils.h"
#import "HomeViewController.h"
#import "TransitionHomeManager.h"
#import "AppNavigationController.h"

@interface WelcomeViewController ()


@property (strong, nonatomic) IBOutlet CircleButton *infoButton;
@property TransitionHomeManager *transitionHomeDelegate;



@end

@implementation WelcomeViewController
@synthesize loginButton;
@synthesize transitionHomeDelegate;
@synthesize infoButton;
            
- (void)viewDidLoad {
    [super viewDidLoad];


    self.transitionHomeDelegate = [[TransitionHomeManager alloc] init];
    // Do any additional setup after loading the view, typically from a nib.

}
- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Splash - viewDidAppear");
    self.loginButton.layer.cornerRadius = 5;
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {

        //if user is already signed in, segue to homeView
        AppNavigationController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"AppNavigationController"];
////        HomeViewController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
//        homeView.modalPresentationStyle = UIModalPresentationNone;
//        [self presentViewController:homeView animated:NO completion:^{}];
        
    } else {
       
    }

    //[self checkStatus];
}
- (IBAction)loginButtonTouchHandler:(UIButton *)sender {
    NSArray *permissionsArray = @[ @"user_friends", @"public_profile"];
    
    // Login PFUser using facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"Uh oh. The user cancelled the Facebook login." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:[error description] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
                [alert show];
            }
        } else if (user.isNew) {
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *name = userData[@"name"];
                    user.username = name;
                    [user saveInBackground];
                    
                }
            }];
            NSLog(@"User with facebook signed up and logged in!");

        } else {
            NSLog(@"User with facebook logged in!");
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if (!error) {
                    NSDictionary *userData = (NSDictionary *)result;
                    NSString *name = userData[@"name"];
                    user.username = name;
                    [user saveInBackground];;
                    
                }
            }];
            AppNavigationController *homeView = [self.storyboard instantiateViewControllerWithIdentifier:@"AppNavigationController"];
//            homeView.transitioningDelegate = self.transitionHomeDelegate;
            homeView.modalPresentationStyle = UIModalPresentationNone;
            [self presentViewController:homeView animated:NO completion:^{}];

        }
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
