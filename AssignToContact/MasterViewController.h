//
//  MasterViewController.h
//  assigntocontact
//
//  Created by Jongtae Ahn on 12. 9. 19..
//  Copyright (c) 2012년 Jongtae Ahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKPeoplePickerNavigationController.h"

@interface MasterViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *selectedImageView;

@end
