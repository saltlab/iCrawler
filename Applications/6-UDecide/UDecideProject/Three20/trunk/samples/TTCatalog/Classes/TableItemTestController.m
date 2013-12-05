#import "TableItemTestController.h"

///////////////////////////////////////////////////////////////////////////////////////////////////

static NSString* kLoremIpsum = @" Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt\
mollit anim id est laborumDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.";

static NSString* kLoremIpsum2 = @" Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt\
mollit anim id est laborumDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in www.it.com  reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
pariatur. Excepteur sint ddddddddddddd.";

//Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
 pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt\
 mollit anim id est laborum.

///////////////////////////////////////////////////////////////////////////////////////////////////

@implementation TableItemTestController

///////////////////////////////////////////////////////////////////////////////////////////////////
// NSObject

- (id)init {
  if (self = [super init]) {
    self.title = @"Table Items";
    self.variableHeightRows = YES;

    // Uncomment this to see how the table looks with the grouped style
    //self.tableViewStyle = UITableViewStyleGrouped;

    // Uncomment this to see how the table cells look against a custom background color 
    //self.tableView.backgroundColor = [UIColor yellowColor];
      
    NSString* localImage = @"bundle://tableIcon.png";
    NSString* remoteImage = @"http://profile.ak.fbcdn.net/v223/35/117/q223792_6978.jpg";
    UIImage* defaultPerson = TTIMAGE(@"bundle://defaultPerson.png");
	TTTableStyledMessageItem *tt = [[TTTableStyledMessageItem alloc] init]; 
	TTStyledText *ttt = [TTStyledText textFromXHTML:@"Here we have a URL http://www.h0tlinkz.com followed by another http://www.internets.com"];
	[tt setTitle:@"Title"];
	[tt setCaption:@"Caption"];
	[tt setImageURL:remoteImage];
	
	  TTStyledText *styleText =  [TTStyledText textFromXHTML:@" Here we have a URL followed by ff another  Here we have a URL   followed by another\
								  aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbccccccccccccc"];
	  
	  TTTableStyledMessageItem *item = [TTTableStyledMessageItem itemWithTitle:@"title" caption:nil text:styleText  timestamp:[NSDate date]
																	imageURL:remoteImage URL:nil];
	  
	  TTStyledText *styleText2 =  [TTStyledText textFromXHTML:@" Here we have a URL followed by"];
	  

	  TTTableStyledMessageItem *item2 = [TTTableStyledMessageItem itemWithTitle:@"title" caption:nil text:styleText2  timestamp:[NSDate date]
																	  imageURL:remoteImage URL:nil];
	    TTStyledText *styleText3 =  [TTStyledText textFromXHTML:kLoremIpsum];
	  TTTableStyledMessageItem *item3 = [TTTableStyledMessageItem itemWithTitle:@"title" caption:nil text:styleText3  timestamp:[NSDate date]
																	   imageURL:remoteImage URL:nil];
	  
	  TTStyledText *styleText4 =  [TTStyledText textFromXHTML:kLoremIpsum2];
	  TTTableStyledMessageItem *item4 = [TTTableStyledMessageItem itemWithTitle:@"title" caption:nil text:styleText4  timestamp:[NSDate date]
																	   imageURL:remoteImage URL:nil];

	   // This demonstrates how to create a table with standard table "fields".  Many of these
    // fields with URLs that will be visited when the row is selected
    self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
      @"Links and Buttons",
       item,
	   item2,
					
	   item3,
	  item4,
		
			[TTTableTextItem itemWithText:@"TTTableTextItem" URL:@"tt://tableItemTest"
			accessoryURL:@"http://www.google.com"],
			[TTTableLink itemWithText:@"TTTableLink" URL:@"tt://tableItemTest"],
			[TTTableButton itemWithText:@"TTTableButton"],
			[TTTableCaptionItem itemWithText:@"TTTableCaptionItem" caption:@"caption"
			URL:@"tt://tableItemTest"],
			[TTTableSubtitleItem itemWithText:@"TTTableSubtitleItem" subtitle:kLoremIpsum
			URL:@"tt://tableItemTest"],
			 [TTTableMessageItem itemWithTitle:@"Bob Jones" caption:@"TTTableMessageItem"
			text:kLoremIpsum timestamp:[NSDate date] URL:@"tt://tableItemTest"],
			[TTTableMoreButton itemWithText:@"TTTableMoreButton"],
			
			@"Images",
			[TTTableImageItem itemWithText:@"TTTableImageItem" imageURL:localImage
			URL:@"tt://tableItemTest"],
			[TTTableRightImageItem itemWithText:@"TTTableRightImageItem" imageURL:localImage
			defaultImage:nil imageStyle:TTSTYLE(rounded)
			URL:@"tt://tableItemTest"],
			[TTTableSubtitleItem itemWithText:@"TTTableSubtitleItem" subtitle:kLoremIpsum
			imageURL:remoteImage defaultImage:defaultPerson
			URL:@"tt://tableItemTest" accessoryURL:nil],
			  [TTTableMessageItem itemWithTitle:@"Bob Jones" caption:@"TTTableMessageItem"
			text:kLoremIpsum timestamp:[NSDate date]
			imageURL:remoteImage URL:@"tt://tableItemTest"],
			   @"Static Text",
			   [TTTableTextItem itemWithText:@"TTTableItem"],
			   [TTTableCaptionItem itemWithText:@"TTTableCaptionItem which wraps to several lines"
			   caption:@"Text"],
			   [TTTableSubtextItem itemWithText:@"TTTableSubtextItem"
			   caption:kLoremIpsum],
			   [TTTableLongTextItem itemWithText:[@"TTTableLongTextItem "
			   stringByAppendingString:kLoremIpsum]],
			   [TTTableGrayTextItem itemWithText:[@"TTTableGrayTextItem "
			   stringByAppendingString:kLoremIpsum]],
			   [TTTableSummaryItem itemWithText:@"TTTableSummaryItem"],
			   
			   @"",
			   [TTTableActivityItem itemWithText:@"TTTableActivityItem"],
	 
			
       nil];
  }
	// [TTStyledText textFromXHTML:@"Here we have a URL http://www.h0tlinkz.com followed by another http://www.internets.com"]
	
	  return self;
}

- (void)dealloc {
  [super dealloc];
}

@end
