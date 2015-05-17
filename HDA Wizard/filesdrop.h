//
//  filedrop.h
//  DropZoneTest
//
//  Created by Janek on 11-06-16.
//  Copyright 2011 janek202. All rights reserved.
//
/*
 This file is part of HDA Wizard.
 
 HDA Wizard is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 HDA Wizard is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with Foobar; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */

#ifndef _FILESDROP_H_
#define _FILESDROP_H_

#import <Cocoa/Cocoa.h>

#import "HDA_WizardAppDelegate.h"

@class DropZoneTestAppDelegate;

@interface filesdrop : NSView {
@private
	NSArray *filenames;
}

@property (copy,atomic) NSArray *filenames;
@end

#endif
