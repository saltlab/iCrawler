//
//  TextViewViewController.h
//
//  Created by Mona.
//

@interface TextViewViewController : UIViewController <UITextViewDelegate> { 
	UITextView* textView;
	UIBarButtonItem *buttonAdd;
}

@property (nonatomic, retain) IBOutlet UITextView* textView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *buttonAdd;

-(IBAction) saveNote;

@end
