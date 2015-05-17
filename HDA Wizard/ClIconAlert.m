//
//  ClIconAlert.m
//  Kext Wizard
//
//  Created by Janek on 11-03-21.
//  Copyright 2011 janek202. All rights reserved.
//
//  To miała być prosta klasa do wyświetlania dwóch typów komunikatów. Trochę się rozrosło, nawet o pobieranie i wykonywanie komend.
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

#import "ClIconAlert.h"
#define _successicns @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertNoteIcon.icns"
#define _problemicns @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns"
#define _questionicns @"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericQuestionMarkIcon.icns"

@implementation IconAlert

+ (id)defaultinst
{
    static id _sharedTask = nil;
    if(_sharedTask == nil) {
        _sharedTask = [[IconAlert alloc] init];
    }
    return _sharedTask;
}

- (id)init 
{
    self = [super init];
    return self;
}

- (void)dealloc 
{
    [super dealloc];
}

- (void)ShowErrorMsg:(NSString *)Desc DestWindow:(NSWindow *) window
{
/*    if ([GrowlApplicationBridge isGrowlRunning])
        [GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"Error", @"error_caption") description:Desc notificationName:@"Task Failed" iconData:nil priority:0 isSticky:NO clickContext:nil];
   */ 
    NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    NSImage *problem = [[[NSImage alloc] initWithContentsOfFile:(_problemicns)] autorelease];

    [alert setIcon:(problem)];
    [alert setMessageText:NSLocalizedString(@"Error", @"error_caption")];
    [alert setInformativeText:Desc];
    [alert addButtonWithTitle:@"OK"];

    [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton)
        {
            NSLog(@"ShowErrorMsg result: %i", (int)result);
        }
    }];
}

- (void)ShowInfoMsg:(NSString *)Desc DestWindow:(NSWindow *) window
{
 /*   if ([GrowlApplicationBridge isGrowlRunning])
        [GrowlApplicationBridge notifyWithTitle:NSLocalizedString(@"Done", @"done_caption") description:Desc notificationName:@"Task Finished" iconData:nil priority:0 isSticky:NO clickContext:nil];
    else
    {   */
        NSAlert *alert = [[[NSAlert alloc] init] autorelease];
        NSImage *success = [[[NSImage alloc] initWithContentsOfFile:(_successicns)] autorelease];

        [alert setIcon:(success)];
        [alert setMessageText:NSLocalizedString(@"Done", @"done_caption")];
        [alert setInformativeText:Desc];
        [alert addButtonWithTitle:@"OK"];

        [alert beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
            NSLog(@"ShowInfoMsg result: %i", (int)result);
        }];
}

- (NSString *)ExecuteCmd:(NSString *)path WithArgs:(NSArray *) args
{
    NSTask *task = [[NSTask alloc] init];
    [task setLaunchPath: path];
    [task setArguments: args];
    NSPipe *pipe = [NSPipe pipe];
    [task setStandardOutput: pipe];
    NSFileHandle *file = [pipe fileHandleForReading];
    [task launch];
    NSData *data = [file readDataToEndOfFile];
    [task release];  
    return [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
}


@end
