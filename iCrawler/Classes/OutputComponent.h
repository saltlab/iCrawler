//
//  OutputComponent.h
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLNode.h"
#import "XMLWriter.h"
#import "Globals.h"

@interface OutputComponent : NSObject

+ (void)setup;
+ (void)setupOutputGraphFile;
+ (void)setupOutputUIElementsFile;
+ (void)setupOutputStateGraphFile;
+ (void)removeOldScreenshotsDirectory;
+ (void)createScreenshotsDirectory;
+ (void)takeScreenshotOfState:(XMLNode*)node;
+ (void)outputGraphFile:(NSMutableString*)outputString;
+ (void)outputUIElementsFile:(NSMutableString*)outputString;
+ (void)outputStateGraphFile:(NSMutableString*)outputString;
+ (void)writeXMLFile;
+ (void)writeAllStatesElements;
+ (void)writeTestScripts;
+ (void)logPropertiesForState:(XMLNode*)node inTo:(XMLWriter*)xmlWriter;

@end
