//
//  HDA_WizardAppDelegate.h
//  HDA Wizard
//
//  Created by Janek on 26.08.2011.
//  Copyright 2011 janek202. All rights reserved.
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

#ifndef _HDAWIZAPP_H_
#define _HDAWIZAPP_H_ 1

#import <Cocoa/Cocoa.h>

#import "BLAuthentication.h"
#import "ClIconAlert.h"
#import "filesdrop.h"

#define _cp @"/bin/cp"
#define _rm @"/bin/rm"
#define _chmod @"/bin/chmod"
#define _chown @"/usr/sbin/chown"
#define _touch @"/usr/bin/touch"
#define _kextcache @"/usr/sbin/kextcache"
//#define _perl @"/usr/bin/perl"

@class filesdrop;

@interface HDA_WizardAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSTextField *layoutpath;
    NSTextField *platformpath;
    NSButton *browseLayout;
    NSButton *browsePlatform;
    NSButton *checkLayout;
    NSButton *checkPlatforms;
    NSButton *checkBinpatch;
    NSPopUpButton *binpatchSelect;
    NSButton *customBinpatch;
    NSButton *patchButton;
    NSButton *restoreButton;
    NSButton *checkBackup;
    NSProgressIndicator *circle;
    NSTextField *CustomBinpatchData;
    NSTextField *infopath;
    NSButton *browseInfo;
    NSButton *checkInfo;
    NSMenuItem *menu_newver;
    
    NSString *link;
    
    NSMutableArray *patches;
}

@property (assign,atomic) IBOutlet NSWindow *window;
@property (assign,atomic) IBOutlet NSTextField *layoutpath;
@property (assign,atomic) IBOutlet NSTextField *platformpath;
@property (assign,atomic) IBOutlet NSButton *browseLayout;
@property (assign,atomic) IBOutlet NSButton *browsePlatform;
@property (assign,atomic) IBOutlet NSButton *checkLayout;
@property (assign,atomic) IBOutlet NSButton *checkPlatforms;
@property (assign,atomic) IBOutlet NSButton *checkBinpatch;
@property (assign,atomic) IBOutlet NSPopUpButton *binpatchSelect;
@property (assign,atomic) IBOutlet NSButton *customBinpatch;
@property (assign,atomic) IBOutlet NSButton *patchButton;
@property (assign,atomic) IBOutlet NSButton *restoreButton;
@property (assign,atomic) IBOutlet NSButton *checkBackup;
@property (assign,atomic) IBOutlet NSProgressIndicator *circle;
@property (assign,atomic) IBOutlet NSTextField *CustomBinpatchData;
@property (assign,atomic) IBOutlet NSTextField *infopath;
@property (assign,atomic) IBOutlet NSButton *browseInfo;
@property (assign,atomic) IBOutlet NSButton *checkInfo;
@property (assign,atomic) IBOutlet NSMenuItem *menu_newver;

- (void)filesDragged:(filesdrop *)sender;
@end

#endif
