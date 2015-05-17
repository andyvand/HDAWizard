//
//  HDA_WizardAppDelegate.m
//  HDA Wizard
//
//  Created by Janek on 26.08.2011.
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

#import "HDA_WizardAppDelegate.h"

@implementation HDA_WizardAppDelegate

@synthesize window;
@synthesize layoutpath;
@synthesize platformpath;
@synthesize browseLayout;
@synthesize browsePlatform;
@synthesize checkLayout;
@synthesize checkPlatforms;
@synthesize checkBinpatch;
@synthesize binpatchSelect;
@synthesize customBinpatch;
@synthesize patchButton;
@synthesize restoreButton;
@synthesize checkBackup;
@synthesize circle;
@synthesize CustomBinpatchData;
@synthesize infopath;
@synthesize browseInfo;
@synthesize checkInfo;
@synthesize menu_newver;

#define _donate_link        @"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=YYVRWXRJN65P8&lc=BE&item_name=AnV%20Software&currency_code=EUR&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted"
#define _patches_link       @"https://raw.githubusercontent.com/andyvand/HDAWizard/master/patches.plist"
#define _versioninfo_link   @"https://raw.githubusercontent.com/andyvand/HDAWizard/master/versioninfo.plist"

- (void)applicationDidFinishLaunching:(__unused NSNotification *)aNotification
{
    
    void (^checkBlock)(void);
    checkBlock = ^{
        NSDictionary *updateinfo = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:_versioninfo_link]];
        if (updateinfo != nil)
        {
            if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] isNotEqualTo: [updateinfo objectForKey:@"Version"]])
            {
                [menu_newver setTitle:[@"New version: " stringByAppendingString:[updateinfo objectForKey:@"Version"]]];
                [menu_newver setHidden:NO];
                link= [[updateinfo objectForKey:@"Link" ]copy];
            }
        }
        
    };
    
    if ([[[NSBundle mainBundle] objectForInfoDictionaryKey:@"AppUpdates"] boolValue])
    {
        dispatch_queue_t queue = dispatch_get_global_queue(0,0);
        dispatch_async(queue,checkBlock);
        dispatch_release(queue);
    }
    
    [binpatchSelect removeAllItems];

    patches = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"patches" ofType:@"plist"]];

    for (NSUInteger i=0; i<[patches count]; i++)
        [binpatchSelect addItemWithTitle: [(NSDictionary *)[patches objectAtIndex:i] objectForKey:@"CodecName"]];
}


- (IBAction)SelectLayout:(__unused id)sender
{
    NSOpenPanel *openplayout = [NSOpenPanel openPanel];

    [openplayout setAllowedFileTypes:[NSArray arrayWithObject:@"zlib"]];
    [openplayout beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton)
            return;

        [layoutpath setStringValue:[[openplayout URL] path]];
        [checkLayout setState:1];
    }];
}

- (IBAction)SelectPlatforms:(__unused id)sender
{
    NSOpenPanel *openplatform = [NSOpenPanel openPanel];
    
    [openplatform setAllowedFileTypes:[NSArray arrayWithObject:@"zlib"]];
    [openplatform beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton)
            return;
        
        [platformpath setStringValue:[[openplatform URL] path]];
        [checkPlatforms setState:1];
    }];
}

- (IBAction)SelectInfo:(__unused id)sender
{
    NSOpenPanel *openinfoplist = [NSOpenPanel openPanel];
    
    [openinfoplist setAllowedFileTypes:[NSArray arrayWithObject:@"plist"]];
    [openinfoplist beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton)
            return;
        
        [infopath setStringValue:[[openinfoplist URL] path]];
        [checkInfo setState:1];
    }];
}

- (IBAction)Patch:(__unused id)sender
{
    if (![[BLAuthentication sharedInstance] isAuthenticated:@"root"])
        [[BLAuthentication sharedInstance] authenticate:@"root"];
    
    if (![[BLAuthentication sharedInstance] isAuthenticated:@"root"])
        return;
    [circle startAnimation:self];
    //Backup
    if ([checkBackup state])
    [[NSFileManager defaultManager] copyItemAtPath:@"/System/Library/Extensions/AppleHDA.kext" toPath:[NSHomeDirectory() stringByAppendingString:@"/Desktop/AppleHDA.kext"] error:nil];
    
  //  return;
    
    //Layout
    if ([checkLayout state])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath: [layoutpath stringValue]])
            [[BLAuthentication sharedInstance] executeCommandSynced:_cp withArgs: [NSArray arrayWithObjects:@"-f",[layoutpath stringValue],@"/System/Library/Extensions/AppleHDA.kext/Contents/Resources", nil]];
    }
    
    //Platforms
    if ([checkPlatforms state])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath: [platformpath stringValue]])
            [[BLAuthentication sharedInstance] executeCommandSynced:_cp withArgs: [NSArray arrayWithObjects:@"-f",[platformpath stringValue],@"/System/Library/Extensions/AppleHDA.kext/Contents/Resources", nil]];
    }
    
    //Info
    if ([checkInfo state])
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath: [infopath stringValue]])
            [[BLAuthentication sharedInstance] executeCommandSynced:_cp withArgs: [NSArray arrayWithObjects:@"-f",[infopath stringValue],@"/System/Library/Extensions/AppleHDA.kext/Contents/PlugIns/AppleHDAHardwareConfigDriver.kext/Contents", nil]];
    }
    
    
    //Binpatch
    //sudo perl -pi -e 's|\x8b\x19\xd4\x11|\x88\x08\xec\x10|g' /System/Library/Extensions/AppleHDA.kext/Contents/MacOS/AppleHDA
    if ([checkBinpatch state])
    {
        NSString *path= [NSHomeDirectory() stringByAppendingString:@"/AppleHDA"];
        [[NSFileManager defaultManager] removeItemAtPath: path error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:@"/System/Library/Extensions/AppleHDA.kext/Contents/MacOS/AppleHDA" toPath: path error:nil];
        
        if (![binpatchSelect isHidden])
            system ([[NSString stringWithFormat:@"%@%@%@%@",@"perl -pi -e ",[(NSDictionary *)[patches objectAtIndex: (NSUInteger)[binpatchSelect indexOfSelectedItem]]objectForKey:@"Patch"],@" ",path] UTF8String]);
        else
            system ([[NSString stringWithFormat:@"%@%@%@%@",@"perl -pi -e ",[CustomBinpatchData stringValue],@" ",path] UTF8String]);
        
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_cp withArgs: [NSArray arrayWithObjects:@"-f",path,@"/System/Library/Extensions/AppleHDA.kext/Contents/MacOS", nil]];
        
        [[NSFileManager defaultManager] removeItemAtPath: path error:nil];
   }
    
    
    [[BLAuthentication sharedInstance] executeCommandSynced:_chown withArgs: [NSArray arrayWithObjects: @"-R", @"0:0",@"/System/Library/Extensions/AppleHDA.kext", nil]];
    
    [[BLAuthentication sharedInstance] executeCommandSynced:_chmod withArgs: [NSArray arrayWithObjects:@"-R", @"755",@"/System/Library/Extensions/AppleHDA.kext", nil]];

    [[BLAuthentication sharedInstance] executeCommandSynced:_touch withArgs: [NSArray arrayWithObject:@"/System/Library/Extensions"]];
    
    [[BLAuthentication sharedInstance] executeCommandSynced:_kextcache withArgs: [NSArray arrayWithObject:@"-system-caches"]];
        
    [[BLAuthentication sharedInstance] executeCommandSynced:_kextcache withArgs: [NSArray arrayWithObject:@"-system-prelinked-kernel"]];

    [circle stopAnimation:self];
    [[IconAlert defaultinst] ShowInfoMsg:@"AppleHDA patching finished. Please reboot your system." DestWindow:window];
}

- (IBAction)Restore:(__unused id)sender
{
    NSOpenPanel *openhda = [NSOpenPanel openPanel];
    
    [openhda setAllowedFileTypes:[NSArray arrayWithObject:@"zlib"]];
    [openhda beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result != NSFileHandlingPanelOKButton)
            return;

        if ([[[[openhda URL] path] lastPathComponent] isNotEqualTo:@"AppleHDA.kext"])
            return;

        if (![[BLAuthentication sharedInstance] isAuthenticated:@"root"])
            [[BLAuthentication sharedInstance] authenticate:@"root"];
        
        if (![[BLAuthentication sharedInstance] isAuthenticated:@"root"])
            return;
        [circle startAnimation:self];
        if ([[NSFileManager defaultManager] fileExistsAtPath: @"/System/Library/Extensions/AppleHDA.kext"])
        {
            [[BLAuthentication sharedInstance] executeCommandSynced:_rm withArgs:([NSArray arrayWithObjects:@"-Rf", @"/System/Library/Extensions/AppleHDA.kext", nil])];
        }
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_cp withArgs:([NSArray arrayWithObjects:@"-R",[[openhda URL] path],@"/System/Library/Extensions", nil])];
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_chown withArgs: [NSArray arrayWithObjects: @"-R", @"0:0",@"/System/Library/Extensions/AppleHDA.kext", nil]];
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_chmod withArgs: [NSArray arrayWithObjects:@"-R", @"755",@"/System/Library/Extensions/AppleHDA.kext", nil]];
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_touch withArgs: [NSArray arrayWithObject:@"/System/Library/Extensions"]];
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_kextcache withArgs: [NSArray arrayWithObject:@"-system-caches"]];
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_kextcache withArgs: [NSArray arrayWithObject:@"-system-prelinked-kernel"]];
        
        
        // update system kext caches for osx 10.10 :
        
        [[BLAuthentication sharedInstance] executeCommandSynced:_kextcache withArgs: [NSArray arrayWithObject:@"-prelinked-kernel"]];
        
        
        [circle stopAnimation:self];
        [[IconAlert defaultinst] ShowInfoMsg:@"AppleHDA kext patched and restored. Please reboot your system." DestWindow:nil];
    }];
}

- (IBAction)SetCustomBinpath:(__unused id)sender
{
    if ([binpatchSelect isHidden])
    {
        [binpatchSelect setHidden:NO];
        [CustomBinpatchData setHidden: YES];
        [customBinpatch setTitle:@"Custom"];
    }
    else
    {
        [binpatchSelect setHidden:YES];
        [CustomBinpatchData setHidden: NO];
        [customBinpatch setTitle:@"Defaults"];
    }

}

//// Drop plikow

- (void)filesDragged:(filesdrop *)sender
{
    NSMutableArray * Strings = [[NSMutableArray alloc] initWithArray:[sender filenames]];

    if (Strings != nil)
    {
        for (NSUInteger i=0; i<[Strings count]; i++)
        {
            if ([[Strings objectAtIndex:i] rangeOfString:@"layout" options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [layoutpath setStringValue:[Strings objectAtIndex:i]];
                [checkLayout setState:1];
            }
            
            if ([[Strings objectAtIndex:i] rangeOfString:@"Info" options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [infopath setStringValue:[Strings objectAtIndex:i]];
                [checkInfo setState:1];
            }
            
            if ([[Strings objectAtIndex:i] rangeOfString:@"Platforms.xml.zlib" options:NSCaseInsensitiveSearch].location != NSNotFound)
            {
                [platformpath setStringValue:[Strings objectAtIndex:i]];
                [checkPlatforms setState:1];
            }
        }
        
        [Strings release];
    }
}


- (IBAction)binpatchListUpdate:(__unused id)sender
{
    [circle startAnimation:self];
    NSArray *downloaded = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:_patches_link]];
    if (downloaded==nil)
    {
        [[IconAlert defaultinst] ShowErrorMsg:@"Couldn't download file.\nCheck your internet connection, and try again later." DestWindow:window];
        [circle stopAnimation:self];
        return;
    }
    [binpatchSelect removeAllItems];
    [patches removeAllObjects];
    [patches addObjectsFromArray: downloaded];
    for (NSUInteger i=0; i<[patches count]; i++)
        [binpatchSelect addItemWithTitle: [(NSDictionary *)[patches objectAtIndex:i] objectForKey:@"CodecName"]] ;
    
    [patches writeToFile: [[NSBundle mainBundle] pathForResource:@"patches" ofType:@"plist"] atomically:YES];
    [circle stopAnimation:self];
}


- (IBAction)MakeDonation:(__unused __unused id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: _donate_link]];
}

- (IBAction)DownloadNewVersion:(__unused id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: link]];
}


- (IBAction)BinpatchSelected:(__unused id)sender
{
    [checkBinpatch setState:1];
}


- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(__unused NSApplication *)theApplication
{
    return YES;
}

@end
