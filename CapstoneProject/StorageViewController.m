//
//  StorageViewController.m
//  CapstoneProject
//
//  Created by Vikas Joshi on 2016-10-20.
//  Copyright © 2016 Student. All rights reserved.
//

#import "StorageViewController.h"
#import <DropboxSDK/DropboxSDK.h>

@interface StorageViewController ()
@end

@implementation StorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    DBSession* dbSession = [[DBSession alloc]
                            initWithAppKey:@"ilv0svdi94bj6t7"
                            appSecret:@"rqmjsigftwgsqx2"
                            root:@"dropbox"];
    [DBSession setSharedSession:dbSession];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dropBoxLink:(id)sender {
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
    
}






/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
