//
//  filedrop.m
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

#import "filesdrop.h"

@implementation filesdrop

@synthesize filenames;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];

    if (self) 
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(__unused NSRect)dirtyRect
{
    // Drawing code here.
}

- (NSDragOperation)draggingEntered:(__unused id)sender
{
    return NSDragOperationCopy;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];

    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) 
    {
        NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        self.filenames = files;

		HDA_WizardAppDelegate *HWDelegate = [[NSApplication sharedApplication] delegate];
		[HWDelegate filesDragged:self];
    }
    return YES;
}
	
@end
