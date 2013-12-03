//
//  OutputComponent.m
//
//  Created by Mona on 12-04-07. All rights reserved.
//

#import "OutputComponent.h"
#import "ICrawlerController.h"
#import "DCIntrospect.h"
#import "SparseGraph.h"
#import "GraphSearchBFS.h"
#import "GraphSearchDFS.h"


@implementation OutputComponent

+ (void)setup {
    [self setupOutputGraphFile];
	[self setupOutputUIElementsFile];
	[self setupOutputStateGraphFile];
	[self removeOldScreenshotsDirectory];
}


#pragma mark -
#pragma mark Setup Directory Methods
+ (void)setupOutputGraphFile {
	//Grab and empty a reference to the output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logGraphPath.txt"]];
	[@"" writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

+ (void)setupOutputUIElementsFile {
	//Grab and empty a reference to the output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logUIElements.txt"]];
	[@"" writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

+ (void)setupOutputStateGraphFile {
	//Grab and empty a reference to the output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logStateGraph.xml"]];
	[@"" writeToFile:path atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
}

+ (void)removeOldScreenshotsDirectory {
	// Attempt to delete the file at documentsDirectory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];
	
	NSFileManager *fileManager= [NSFileManager defaultManager];
	if([fileManager fileExistsAtPath:directory])
		if(![fileManager removeItemAtPath:directory error:NULL])
			NSLog(@"Error: Delete folder failed %@", directory);
}


#pragma mark -
#pragma mark Create Directory Methods
+ (void)createScreenshotsDirectory {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];
	
	NSFileManager *fileManager= [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:directory])
		if(![fileManager createDirectoryAtPath:directory withIntermediateDirectories:NO attributes:nil error:NULL])
			NSLog(@"Error: Create folder failed %@", directory);
}


#pragma mark -
#pragma mark Related Directory Methods
+ (void)takeScreenshotOfState:(XMLNode*)node {
	
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[directory stringByAppendingPathComponent:[NSString stringWithFormat:@"S%d.jpg", node.currentStateIndex]]];
	[UIImageJPEGRepresentation(img, 1.0) writeToFile:path atomically:NO];
}


#pragma mark -
#pragma mark Write Directory Methods
+ (void)outputGraphFile:(NSMutableString*)outputString {
	// Create paths to Graph output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logGraphPath.txt"]];
	freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a+",stdout);
	NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
	[fileHandler seekToEndOfFile];
	[fileHandler writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandler closeFile];
}

+ (void)outputUIElementsFile:(NSMutableString*)outputString {
	// Create paths All UIElements to output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logUIElements.txt"]];
	freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a+",stdout);
	NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
	[fileHandler seekToEndOfFile];
	[fileHandler writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandler closeFile];
}

+ (void)outputStateGraphFile:(NSMutableString*)outputString {
	// Create paths to State Graph output txt file
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[documentsDirectory stringByAppendingPathComponent:@"logStateGraph.xml"]];
	freopen([path cStringUsingEncoding:NSASCIIStringEncoding],"a+",stdout);
	NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:path];
	[fileHandler seekToEndOfFile];
	[fileHandler writeData:[outputString dataUsingEncoding:NSUTF8StringEncoding]];
	[fileHandler closeFile];
}

//http://code.google.com/p/xswi/source/browse/trunk/xswi/Classes/?r=122
+ (void)writeXMLFile {
	XMLWriter* xmlWriter = [[XMLWriter alloc]init];
	
	//NSString* xsNamespace = @"http://www.w3.org/2001/XMLSchema";
	//[xmlWriter setPrefix:@"xs" namespaceURI:xsNamespace];
	//[xmlWriter writeStartElementWithNamespace:xsNamespace localName:@"schema"];
	//[xmlWriter writeStartElementWithNamespace:xsNamespace localName:@"complexType"];
	
	[xmlWriter writeStartDocumentWithEncodingAndVersion:@"UTF-8" version:@"1.0"];
	
	[xmlWriter writeStartElement:@"States"];
	
	NSMutableArray *nodesArray = [[Globals sharedInstance] xmlNodesArray];
    [nodesArray removeObjectAtIndex:0];
	for(XMLNode * node in nodesArray)
		[self logPropertiesForState:node inTo:xmlWriter];
	
	[xmlWriter writeEndElement];
	
	// Create paths to output txt file
	[self outputStateGraphFile:[xmlWriter toString]];
	
	[xmlWriter release];
}

+ (void)logPropertiesForState:(XMLNode*)node inTo:(XMLWriter*)xmlWriter {
	[xmlWriter writeStartElement:@"State"];
	
	[xmlWriter writeStartElement:@"PreviousState"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"State%i", node.preStateIndex]];
	[xmlWriter writeEndElement];
	
	[xmlWriter writeStartElement:@"CurrentState"];
	[xmlWriter writeCharacters:[NSString stringWithFormat:@"State%i", node.currentStateIndex]];
	[xmlWriter writeEndElement];
	
	[xmlWriter writeStartElement:@"Edge"];
	[xmlWriter writeCharacters:node.edge];
	[xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:@"ElementId"];
	[xmlWriter writeCharacters:node.currentElement.monkeyId ? node.currentElement.monkeyId: @""];
	[xmlWriter writeEndElement];
    
    [xmlWriter writeStartElement:@"ElementCommand"];
	[xmlWriter writeCharacters:node.currentElement.monkeyCommand ? node.currentElement.monkeyCommand: @""];
	[xmlWriter writeEndElement];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *directory = [documentsDirectory stringByAppendingPathComponent: @"/Screenshots"];
	NSString *path = [[NSString alloc] initWithFormat:@"%@",[directory stringByAppendingPathComponent:[NSString stringWithFormat:@"S%d.jpg", node.currentStateIndex]]];
	[xmlWriter writeStartElement:@"ScreenshotPath"];
	[xmlWriter writeCharacters:path];
	[xmlWriter writeEndElement];
	
	[xmlWriter writeEndElement];
}

+ (void)writeAllStatesElements {
    
    DCIntrospect *dcIntrospect = [[DCIntrospect alloc] init];
    NSArray *statesArray =[[ICrawlerController sharedICrawler] visitedStates];
    
    int count = 0;
    for (State* s in statesArray) {
        for (UIElement* e in s.uiElementsArray) {
            count++;
            if ([e.className isEqualToString:@"UINavigationItemButtonView"] || [e.className isEqualToString:@"UIActivityIndicatorView"])
                [dcIntrospect logPropertiesForObject:(UIView*)e.object
                                  withViewController:NSStringFromClass([s.selfViewController class])
                                       andStateIndex:s.visitedStateIndex];
            else if ([e.objectClass isKindOfClass:[NSString class]])
                NSLog(@"Unknow element %@", e.objectClass);
            else
                [dcIntrospect logPropertiesForObject:e.object
                                  withViewController:NSStringFromClass([s.selfViewController class])
                                       andStateIndex:s.visitedStateIndex];
        }
    }
    
    NSLog(@"Total number of GUI elements %d", count);
}

+ (void)writeTestScripts {
    
    SparseGraph *graph = [[SparseGraph alloc] initWithIsDigraph:YES];
    NSArray *statesArray = [[ICrawlerController sharedICrawler] visitedStates];
    NSArray *nodesArray = [[Globals sharedInstance] xmlNodesArray];
    
    for (State* s in statesArray)
        [graph addNodeWithIndex:s.visitedStateIndex];
    
	for(XMLNode* n in nodesArray)
        [graph addEdgeFrom:n.preStateIndex to:n.currentStateIndex command:n.currentElement.monkeyCommand];
    //[graph addEdgeFrom:n.preStateIndex to:n.currentStateIndex];
    
    NSMutableString *outputString = [NSMutableString stringWithFormat:@"\n\n** Graph with %d nodes and %d edges", graph.numNodes, graph.numEdges];
    
    outputString = [graph print:outputString];
    
    [outputString appendFormat:@"\n\n** DFS & BFS Paths:"];
    for (int i=0; i<[statesArray count]; i++) {
        
        [outputString appendFormat:@"\n\n DFS path to state %d is ", i];
        GraphSearchDFS *dfs = [[GraphSearchDFS alloc] initWithGraph:graph sourceNodeIndex:0 targetNodeIndex:i];
        NSArray *dfsPath = [dfs getPathToTarget];
        
        for (NSString *string in dfsPath) {
            [outputString appendFormat:@"%@ => ", string];
        }
        [outputString deleteCharactersInRange:NSMakeRange([outputString length]-3, 3)];
        [outputString appendFormat:@"\n Test Script is: \n"];
        
        for (NSString *string in dfsPath) {
            NSMutableArray *edges = [graph.nodeEdges objectAtIndex:[string intValue]];
            for (GraphEdge *edge in edges)
                if (edge.to == i)
                    [outputString appendFormat:@"   %@ \n", edge.monkeyCommand];
        }
        
        [outputString appendFormat:@"\n\n BFS path to state %d is ", i];
        GraphSearchBFS *bfs = [[GraphSearchBFS alloc] initWithGraph:graph sourceNodeIndex:0 targetNodeIndex:i];
        NSArray *bfsPath = [bfs getPathToTarget];
        for (NSString *string in bfsPath) {
            [outputString appendFormat:@"%@ => ", string];
        }
        [outputString deleteCharactersInRange:NSMakeRange([outputString length]-3, 3)];
        [outputString appendFormat:@"\n Test Script is: \n"];
        for (NSString *string in bfsPath) {
            NSMutableArray *edges = [graph.nodeEdges objectAtIndex:[string intValue]];
            for (GraphEdge *edge in edges)
                if (edge.to == i)
                    [outputString appendFormat:@"   %@ \n", edge.monkeyCommand];
        }
    
    }
    [outputString appendFormat:@"\n\n**"];
    
    [OutputComponent outputGraphFile:outputString];
    
}





@end
