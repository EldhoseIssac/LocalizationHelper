//
//  LHAppDelegate.h
//  LocalisationHelper
//
//  Created by Eldhose on 24/07/13.
//  Copyright (c) 2013 Islet Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LHAppDelegate : NSObject <NSApplicationDelegate,NSComboBoxDataSource,NSComboBoxDelegate>{
    NSMutableArray * theEnglishLineList;
    NSMutableArray * theOtherLangLineList;
    NSString * theFileString;
    NSTask *task;
    NSPipe * pipe;
    NSArray *languageList;
    __weak NSProgressIndicator *_waitIndicator;
    NSString * loadedFileExtension;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *theFileLocation;
@property (unsafe_unretained) IBOutlet NSTextView *theEnglishStringList;
@property (unsafe_unretained) IBOutlet NSTextView *otheLangStringList;
@property (weak) IBOutlet NSComboBox *folderComboBox;

- (IBAction)fileSelector:(id)sender;
- (IBAction)loadEnglishStringsClick:(id)sender;
- (IBAction)replaceStringClick:(id)sender;

@property (weak) IBOutlet NSProgressIndicator *waitIndicator;
@end
