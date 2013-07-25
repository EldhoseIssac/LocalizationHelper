//
//  LHAppDelegate.m
//  LocalisationHelper
//
//  Created by Eldhose on 24/07/13.
//  Copyright (c) 2013 Islet Systems. All rights reserved.
//

#import "LHAppDelegate.h"
#define GenerateStrinFileCmd @"ibtool --generate-strings-file \"%@.strings\" \"%@.storyboard\""
#define ExportToStoryBoardcmd @"ibtool --strings-file \"%@.strings\" --write \"%@.storyboard\"  \"%@.storyboard\""

@implementation LHAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)fileSelector:(id)sender {
    
    NSOpenPanel *savePanel=[[NSOpenPanel alloc] init];
    [savePanel setCanCreateDirectories:NO];
    [savePanel setCanChooseDirectories:NO];
    [savePanel setCanChooseFiles:YES];
    [savePanel setAllowsMultipleSelection:NO];
    [savePanel setAllowedFileTypes:@[@"storyboard"]];
    if ( [savePanel runModal] == NSOKButton )
    {
        [self.waitIndicator startAnimation:@"Hello"];
        self.theFileLocation.stringValue=savePanel.URL.path;
        __block NSString * theFile = [self.theFileLocation.stringValue lastPathComponent];
        theFile = [theFile stringByDeletingPathExtension];
        __block NSString * fldrPath = [self.theFileLocation.stringValue stringByDeletingLastPathComponent];
        NSString * theFolder = [ fldrPath lastPathComponent];
        fldrPath = [fldrPath stringByDeletingLastPathComponent];
    
        
        
        NSMutableArray * tmapArr = [@[] mutableCopy];
        
        NSError *error = nil;
        
        NSArray *directoryFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fldrPath error:&error];
        
        if(directoryFiles == nil){
            NSLog(@"%@", [error localizedDescription]);
            return ;
        }
        for (NSString * path in directoryFiles) {
            if (([path rangeOfString:@".lproj"].location != NSNotFound) && (![path isEqualToString:theFolder])) {
                [tmapArr addObject:path];
            }
        }
        languageList = [NSArray arrayWithArray:tmapArr];
        [self.folderComboBox reloadData];
        if (languageList.count>0) {
            [self.folderComboBox selectItemAtIndex:0];
        }
        
        
        

        
        fldrPath = [fldrPath stringByAppendingPathComponent:theFolder];
        theFile = [self.theFileLocation.stringValue stringByDeletingPathExtension];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString * theGenarateCmd = [NSString stringWithFormat:GenerateStrinFileCmd,theFile,theFile];
            NSLog(@"%@",theGenarateCmd);
            runCommand(theGenarateCmd);
            [self performSelectorOnMainThread:@selector(loadEnglishStringsClick:) withObject:nil waitUntilDone:NO];
        });
        
    }

  
    //[self runCmd:@"/Users/isletsys/Documents" withArgs:@[@"pwd"]];

}
#define $UTF8(A) ((NSString*)[NSString stringWithUTF8String:A])
NSString * runCommand(NSString* c) {
    
    NSString* outP; FILE *read_fp;  char buffer[BUFSIZ + 1];
    int chars_read; memset(buffer, '\0', sizeof(buffer));
    read_fp = popen(c.UTF8String, "r");
    if (read_fp != NULL) {
        chars_read = (char) fread(buffer, sizeof(char), BUFSIZ, read_fp);
        if (chars_read > 0) outP = $UTF8(buffer);
        pclose(read_fp);
    }
    return outP;
}
- (IBAction)loadEnglishStringsClick:(id)sender {
    NSString * theFilePath = [[self.theFileLocation.stringValue stringByDeletingPathExtension] stringByAppendingPathExtension:@"strings"];
   
    theFileString = [NSString stringWithContentsOfFile:theFilePath encoding:NSUTF16StringEncoding error:nil];
    if (!theFileString) {
        [self.waitIndicator stopAnimation:@"Hello"];
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Cannot read String File Something Went Wrong!!"];
        [alert runModal];
        return;
    }
    NSScanner * aScanner = [NSScanner scannerWithString:theFileString];
    NSString * aEnglishString;
    self.theEnglishStringList.string = @"";
    theEnglishLineList = [@[] mutableCopy];
    while ([aScanner isAtEnd] == NO) {
        [aScanner scanUpToString:@"*/" intoString:nil];
        [aScanner scanUpToString:@"=" intoString:nil];
        [aScanner scanUpToString:@"\"" intoString:nil];
        if ([aScanner isAtEnd] == YES) {
            break;
        }
        [aScanner setScanLocation:[aScanner scanLocation]+1];
        [aScanner scanUpToString:@"\"" intoString:&aEnglishString];
        [theEnglishLineList addObject:aEnglishString];
        self.theEnglishStringList.string = [self.theEnglishStringList.string stringByAppendingFormat:@"%@\n",aEnglishString];
      
    }
    [self.waitIndicator stopAnimation:@"Hello"];
    
}

- (IBAction)replaceStringClick:(id)sender {
    
    NSArray * otherLangList = [self.otheLangStringList.string componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    if (otherLangList.count != theEnglishLineList.count) {
        NSLog(@"Count missmatch ");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Count mismatch!!"];
        [alert runModal];
        return;
    }
    
    NSScanner * aScanner = [NSScanner scannerWithString:theFileString];
    NSString * aEnglishString;
    NSString * tmpString;
    NSMutableString * theNewFile = [@"" mutableCopy];
    theEnglishLineList = [@[] mutableCopy];
    int index = 0;
    while ([aScanner isAtEnd] == NO) {
        [aScanner scanUpToString:@"*/" intoString:&tmpString];
        [theNewFile appendString:tmpString];
        if ([aScanner isAtEnd] == YES) break;
        [aScanner scanUpToString:@"=" intoString:&tmpString];
        [theNewFile appendString:tmpString];
        if ([aScanner isAtEnd] == YES) break;
        [aScanner scanUpToString:@"\"" intoString:&tmpString];
        [theNewFile appendString:tmpString];
        if ([aScanner isAtEnd] == YES) break;
        [aScanner setScanLocation:[aScanner scanLocation]+1];
        [theNewFile appendString:@"\""];
        [aScanner scanUpToString:@"\"" intoString:&aEnglishString];
        [theNewFile appendString:otherLangList[index]];
        index++;
    }
    
    self.otheLangStringList.string = theNewFile;

    [self.waitIndicator startAnimation:@"Hello"];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSString * theFilePath = [[self.theFileLocation.stringValue stringByDeletingPathExtension] stringByAppendingPathExtension:@"strings"];
        [theNewFile writeToFile:theFilePath atomically:YES encoding:NSUTF16StringEncoding error:nil];
        
        
        
        NSString * fldrPath = [self.theFileLocation.stringValue stringByDeletingLastPathComponent];
        fldrPath = [fldrPath stringByDeletingLastPathComponent];
        
        NSString * selLang = self.folderComboBox.stringValue;
        
        NSString * destFolder = [fldrPath stringByAppendingPathComponent:selLang];
        
        NSString * theFileName = [[self.theFileLocation.stringValue lastPathComponent] stringByDeletingPathExtension];
        destFolder = [destFolder stringByAppendingPathComponent:theFileName];
        NSString *source = [self.theFileLocation.stringValue stringByDeletingPathExtension];
        
        NSString * gnst =[NSString stringWithFormat:ExportToStoryBoardcmd,source,destFolder,source];
        NSLog(@"the cmd %@",gnst);
        
        runCommand(gnst);
        [[NSFileManager defaultManager] removeItemAtPath:[source stringByAppendingPathExtension:@"strings"] error:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.theFileLocation.stringValue = @"";
            self.otheLangStringList.string = @"";
            self.theEnglishStringList.string = @"";
            [self.waitIndicator stopAnimation:@"Hello"];
        });
        
        
    });
     
    
    
}

#pragma Mark
#pragma mark ComboxDelegate
// ==========================================================
// Combo box data source methods
// ==========================================================

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
        return [languageList count];
        
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)loc {
    return [languageList objectAtIndex:loc];
   
}
- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)string {
     return [languageList indexOfObject: string];
    
}

- (NSString *) firstGenreMatchingPrefix:(NSString *)prefix {
    NSString *string = nil;
    NSString *lowercasePrefix = [prefix lowercaseString];
    NSEnumerator *stringEnum = [languageList objectEnumerator];
    while ((string = [stringEnum nextObject])) {
        if ([[string lowercaseString] hasPrefix: lowercasePrefix]) return string;
    }
    return nil;
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)inputString {
    // This method is received after each character typed by the user, because we have checked the "completes" flag for genreComboBox in IB.
    // Given the inputString the user has typed, see if we can find a genre with the prefix, and return it as the suggested complete string.
    NSString *candidate = [self firstGenreMatchingPrefix: inputString];
    return (candidate ? candidate : inputString);
}


@end
