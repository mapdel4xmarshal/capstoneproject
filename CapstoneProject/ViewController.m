//
//  ViewController.m
//  CapstoneProject
//
//  Created by Student on 2016-10-13.
//  Copyright © 2016 Student. All rights reserved.
//

#import "ViewController.h"
#import "documentTabControllerViewController.h"


// facebook login headers
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


FBSDKLoginManager *login;

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //obscure password field
    _passwordField.secureTextEntry = YES;
    
    [self getUserDetails : ^{}];
}

-(void) getUserDetails : (void (^)(void))callbackFunction
{
    FBSDKAccessToken* access_token =[FBSDKAccessToken currentAccessToken];
    NSLog(@"Access Token, %@",access_token);
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,picture.height(800).width(800)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                 
                 
                 _facebookID = [result objectForKey:@"id"];
                 _fullName   = [result objectForKey: @"name"];
                 _emailID    = [result objectForKey: @"email"];
                 _profilePicURL = [[[result objectForKey: @"picture"] objectForKey: @"data"] objectForKey: @"url"];
                 
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setValue:_facebookID forKey:@"facebookID"];
                 [defaults setValue:_fullName forKey:@"fullName"];
                 [defaults setValue:_emailID forKey:@"emailID"];
                 [defaults setValue:_profilePicURL forKey:@"profilePicURL"];
                 [defaults setValue:@"nil" forKey:@"userID"];
                 
                 [defaults synchronize];
                 
                 NSLog(@"Result = %@",[[[result objectForKey: @"picture"] objectForKey: @"data"] objectForKey: @"url"]);
                 
                 // NSLog(@" profile pic : %@",[pic objectForKey: @"data"]);
                 callbackFunction();
             }
         }];
    }
}

- (IBAction)facebookLoginButton:(UIButton *)sender {
    
    [self loginButtonClicked];
}


// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    if (![FBSDKAccessToken currentAccessToken]) {
        login = [[FBSDKLoginManager alloc] init];
        
        [login
         logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"]
         fromViewController:self
         handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
             if (error) {
                 NSLog(@"%@",[error localizedDescription]);
                 NSLog(@"Process error");
                 [self loggedIn];
             } else if (result.isCancelled) {
                 NSLog(@"Cancelled");
             } else {
                 NSLog(@"Logged in");
                 [self loggedIn];
             }
         }];
    }
    else
    {
        [self loggedIn];
    }
}

-(void)loggedIn
{
    UITabBarController *tbc = [self.storyboard instantiateViewControllerWithIdentifier:@"tabControllers"];
    tbc.selectedIndex=0;
    [self presentViewController:tbc animated:YES completion:nil];
}

- (IBAction)login:(id)sender {
    if([_emailField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""])
    {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Validation Error" message:@"Please enter a valid username and password." delegate:self cancelButtonTitle: @"OK"otherButtonTitles: nil];
        
        [error show];
    }
    else
    {
            
        NSString *post = [NSString stringWithFormat:@"action=%@&emailAddress=%@&password=%@", @"doLogin",_emailField.text, _passwordField.text];
        
        NSString *result = [self doConnect: post];
        
        NSLog(@"result - %@",result);
        
        
        NSData* data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];  // if you are expecting  the JSON string to be in form of array else use NSDictionary instead
        
        NSLog(@"userID - %@",[values valueForKey:@"userID"]);
        if([_emailField.text isEqualToString: [values valueForKey:@"emailAddress"]])
        {
            _facebookID = [values valueForKey:@"facebookID"];
            _fullName   = [NSString stringWithFormat:@"%@ %@", [values valueForKey:@"firstName"], [values valueForKey:@"lastName"]];
            _emailID    = [values valueForKey: @"emailAddress"];
            _userID     = [values valueForKey:@"userID"];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:_facebookID forKey:@"facebookID"];
            [defaults setValue:_fullName forKey:@"fullName"];
            [defaults setValue:_emailID forKey:@"emailID"];
            [defaults setValue:_profilePicURL forKey:@"profilePicURL"];
            [defaults setValue:@"nill" forKey:@"userID"];
            
            [defaults synchronize];
            
            //show app main page
            [self loggedIn];
        }
        else
        {
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Oops! The username and password provided couldn't be validated." delegate:self cancelButtonTitle: @"OK"otherButtonTitles: nil];
            
            [error show];
        }
    }
}

-(NSString *)doConnect: (NSString *)postValues
{
    NSLog(@"Post Data : %@", postValues);
    
    NSData *postData = [postValues dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:@"http://www.bmtool.us/piktor/handlers.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    // Send a synchronous request
    NSHTTPURLResponse * response = nil;
    NSError * error = nil;
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request
                                          returningResponse:&response
                                                      error:&error];
    
    NSLog(@"Response code : %d", [response statusCode]);
    
    NSLog(@"error  = %@", error);
    
    if (error == nil)
    {
        // Parse data here
        NSString *responseData = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
       // NSLog(@"responseData = %@", responseData);
        return responseData;
    }
    
   return @"nil";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
