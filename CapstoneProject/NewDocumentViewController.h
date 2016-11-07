//
//  NewDocumentViewController.h
//  CapstoneProject
//
//  Created by Vikas Joshi on 2016-11-07.
//  Copyright © 2016 Student. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewDocumentViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *documentImageView;


@end
