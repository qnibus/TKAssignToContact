//
//  MasterViewController.m
//  assigntocontact
//
//  Created by Jongtae Ahn on 12. 9. 19..
//  Copyright (c) 2012년 Jongtae Ahn. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

- (IBAction)presentImagePickerController:(id)sender;

@end

@implementation MasterViewController

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Assign To Contact", nil);
    }
    return self;
}

#pragma mark -
#pragma mark Management memory

- (void)dealloc
{
    [_selectedImageView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark -
#pragma mark Action

- (IBAction)presentImagePickerController:(id)sender
{
    _selectedImageView.image = nil;
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:pickerController animated:YES completion:nil];
    [pickerController release];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        // Selected image
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // Call addressbook controller
        TKPeoplePickerNavigationController* picker = [[TKPeoplePickerNavigationController alloc] init];
        picker.personUpdateImage = selectedImage; // Send image
        picker.peoplePickerDelegate = self;
        picker.editing = NO;
        [self presentModalViewController:picker animated:YES];
        [picker release];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark ABPeoplePickerNavigationControllerDelegate

- (BOOL)peoplePickerNavigationController:(TKPeoplePickerNavigationController*)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // Receive Image
    UIImage *personUpdateImage = peoplePicker.personUpdateImage;
    
    // If it was assigned photo to person, Must delete assigned photo.
    CFErrorRef error;
    if (ABPersonHasImageData(person)) {
        BOOL didRemoveImageData = ABPersonRemoveImageData(person, &error);
        if (!didRemoveImageData) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
    }
    
    // Set photo to selected person
    NSData *data = UIImageJPEGRepresentation(personUpdateImage, 1.0);
    BOOL didSetImageData = ABPersonSetImageData(person, (CFDataRef)data, &error);
    if (!didSetImageData) NSLog(@"Error: %@", [(NSError *)error localizedDescription]);
    
    // Save addressbook instance
    ABAddressBookRef addressBook = peoplePicker.addressBook;
    if (ABAddressBookSave(addressBook, NULL)) {
        // Show success message
        UIAlertView *av = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", nil) message:NSLocalizedString(@"Saved to your contact", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] autorelease];
        [av show];
        
        // Add modified or added photo to Main imageview
        _selectedImageView.image = personUpdateImage;
    }
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:(TKPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

- (void)peoplePickerNavigationControllerDidCancel:(TKPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
