//
//  TKPeoplePickerNavigationController.m
//  AssignToContact
//
//  Created by Jongtae Ahn on 12. 9. 20..
//  Copyright (c) 2012년 Jongtae Ahn. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "TKPeoplePickerNavigationController.h"

@interface TKPeoplePickerNavigationController ()

@end

@implementation TKPeoplePickerNavigationController
@synthesize personUpdateImage = _personUpdateImage;

- (void)dealloc
{
    [_personUpdateImage release];
    [super dealloc];
}

@end
