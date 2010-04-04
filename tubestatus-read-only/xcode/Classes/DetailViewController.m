//
//  DetailViewController.m
//  TubeStatus
//
//  Created by Malcolm Barclay on 07/07/2008.
//

/*
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version, see <http://www.gnu.org/licenses/>.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
*/

#import "DetailViewController.h"
#import "TubeLine.h"

TubeLine *tubeLine; 

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
		self.title = @"Messages";
	}
	return self;
}

- (void)setTubeLine:(TubeLine *)displayTubeLine {
	tubeLine = displayTubeLine;
}

// programmatically create a view hierarchy
- (void)loadView {
	UIView *detailView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	detailView.backgroundColor = [UIColor whiteColor];

	self.view = detailView;
	[detailView release];

	CGRect textViewFrame = [[UIScreen mainScreen] applicationFrame];

	UIWebView *webView = [[UIWebView alloc] initWithFrame:textViewFrame];
	webView.detectsPhoneNumbers = NO;

	// build the html string
	NSString *htmlString = [[NSString alloc] init];

	// tube line
	htmlString = [htmlString stringByAppendingString:@"<p style='font-family: Helvetica; font-weight:bold;'>"];
	htmlString = [htmlString stringByAppendingString:tubeLine.name];

	if ( ! [tubeLine.name isEqualToString:@"DLR"] ) {
		htmlString = [htmlString stringByAppendingString:@" Line"];
	}

	htmlString = [htmlString stringByAppendingString:@"</p>"];

	// messages
	htmlString = [htmlString stringByAppendingString:tubeLine.messages];

	// last update
	htmlString = [htmlString stringByAppendingString:@"<p style='font-family: Helvetica;; font-weight:bold;'>"];
	htmlString = [htmlString stringByAppendingString:tubeLine.lastUpdate];
	htmlString = [htmlString stringByAppendingString:@"</p>"];

	// horizontal rule
	htmlString = [htmlString stringByAppendingString:@"<hr size='1'/>"];

	// footer
	htmlString = [htmlString stringByAppendingString:@"<p style='font-family: Helvetica;'>TubeStatus 1.1 by Malcolm Barclay<br/>http://mbarclay.net</p><p>&nbsp;</p><p>&nbsp;</p>"];

	// assign the html to the web view and display it
	[webView loadHTMLString:htmlString baseURL:nil];
	[self.view addSubview:webView];

}



/*
 If you need to do additional setup after loading the view, override viewDidLoad.
- (void)viewDidLoad {
}
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
}


- (void)dealloc {
	[tubeLine release];
	[super dealloc];
}


@end
