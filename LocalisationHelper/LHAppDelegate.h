//
//  LHAppDelegate.h
//  LocalisationHelper
//
//  Created by Eldhose on 24/07/13.
//  Copyright (c) 2013 Islet Systems. All rights reserved.
//

#import <Cocoa/Cocoa.h>
typedef enum {
    ModeNone=0,
    ModeStoryBoard,
    ModeMFiles,
    ModeStringFile
}ModeOfOperation;
@interface LHAppDelegate : NSObject <NSApplicationDelegate,NSComboBoxDataSource,NSComboBoxDelegate>{
    NSMutableArray * theEnglishLineList;
    NSMutableArray * theOtherLangLineList;
    NSString * theFileString;
    NSTask *task;
    NSPipe * pipe;
    NSArray *languageList;
    __weak NSProgressIndicator *_waitIndicator;
    NSMutableSet * createdFileList;
    ModeOfOperation crntMode;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *theFileLocation;
@property (unsafe_unretained) IBOutlet NSTextView *theEnglishStringList;
@property (unsafe_unretained) IBOutlet NSTextView *otheLangStringList;
@property (weak) IBOutlet NSComboBox *folderComboBox;


- (IBAction)loadEnglishStringsClick:(id)sender;
- (IBAction)replaceStringClick:(id)sender;
- (IBAction)clickedClearFiles:(id)sender;
- (IBAction)loadFromSBClick:(NSButton *)sender;
- (IBAction)loadFromFolderClick:(NSButton *)sender;
- (IBAction)loadFromStringFileClick:(NSButton *)sender;

@property (weak) IBOutlet NSProgressIndicator *waitIndicator;
@end
