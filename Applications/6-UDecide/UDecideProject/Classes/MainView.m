#import "MainView.h"

@implementation MainView

- (IBAction)abcd {
    int rNumber = rand() % 4;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"A";
			break;
		case 1:
			result.text = @"B";
			break;
		case 2:
			result.text = @"C";
			break;
		case 3:
			result.text = @"D";
			break;
		default:
			break;
	}
}

- (IBAction)agreeDisagree {
    int rNumber = rand() % 2;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"Agree";
			break;
		case 1:
			result.text = @"Disagree";
			break;
		default:
			break;
	}
}

- (IBAction)headsTails {
	int rNumber = rand() % 4;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"Heads";
			break;
		case 1:
			result.text = @"Tails";
			break;
		default:
			break;
	}
}

- (IBAction)leftCenterRight {
   	int rNumber = rand() % 3;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"Left";
			break;
		case 1:
			result.text = @"Center";
			break;
		case 2:
			result.text = @"Right";
			break;
		default:
			break;
	} 
}

- (IBAction)lottery {
  	int rNumber = rand() % 3;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"Buy";
			break;
		case 1:
			result.text = @"Sell";
			break;
		case 2:
			result.text = @"Hold";
			break;
		default:
			break;
	}  
}

- (IBAction)oneToHundred {
	int rNumber = rand() % 100;
	result.text	 = [[NSString alloc] initWithFormat:@"%d", rNumber];
}

- (IBAction)positiveNegative {
	int rNumber = rand() % 2;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"Positive";
			break;
		case 1:
			result.text = @"Negative";
			break;
		default:
			break;
	}
}

- (IBAction)russianRoulette {
	int rNumber = rand() % 6;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"BANG!!!";
			break;
		default:
			result.text = @"Click...";
			break;
	}
}

- (IBAction)trueFalse {
	int rNumber = rand() % 2;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"True";
			break;
		case 1:
			result.text = @"False";
			break;
		default:
			break;
	}
}

- (IBAction)yesNo {
	int rNumber = rand() % 2;
	
	switch (rNumber) {
		case 0:
			result.text	 = @"Yes";
			break;
		case 1:
			result.text = @"No";
			break;
		default:
			break;
	}
}

@end
