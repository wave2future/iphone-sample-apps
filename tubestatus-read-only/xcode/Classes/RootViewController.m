//
//  RootViewController.m
//  TubeStatus
//
//  Created by Malcolm Barclay on 28/06/2008.
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

	#import "RootViewController.h"
	#import "TubeStatusAppDelegate.h"
	#import "TubeLine.h"
	#import "XMLReader.h"
	#import "DetailViewController.h"

	#define ROW_HEIGHT 60

	static NSString *feedURLString = @"http://runtimepartners.com/tube/status.php";

	static NSString *updatingStatusTextMessage = @"updating...";

	static UIImage *goodServiceIcon;
	static UIImage *informationIcon;
	static UIImage *minorDelaysIcon;
	static UIImage *partSuspendedIcon;
	static UIImage *severeDelaysIcon;
	static UIImage *suspendedIcon;

	@implementation RootViewController

	@synthesize displayList;

	// view with tag names 
	#define TUBE_LINE_NAME_TAG 1
	#define STATUS_TEXT_TAG 2
	#define LINE_COLOR_IMAGE_TAG 3
	#define STATUS_ICON_IMAGE_TAG 4

	// label coordinates and defaults
	#define LEFT_COLUMN_OFFSET 35.0
	#define LEFT_COLUMN_WIDTH 200.0

	#define MIDDLE_COLUMN_OFFSET 35.0
	#define MIDDLE_COLUMN_WIDTH 200.0

	#define RIGHT_COLUMN_OFFSET 270.0

	#define MAIN_FONT_SIZE 18.0
	#define SMALL_FONT_SIZE 13.0
	#define LABEL_HEIGHT 25.0

	#define IMAGE_SIDE 30.0

	- (id)initWithStyle:(UITableViewStyle)style {
		if (self = [super initWithStyle:style]) {
			self.title = NSLocalizedString(@"Tube Status", @"Tube Status title");
			self.tableView.rowHeight = ROW_HEIGHT;
		}
		return self;
	}

	+ (void)initialize {
		// assign the status icons
		goodServiceIcon = [[UIImage imageNamed:@"GoodServiceIcon.png"] retain];
		informationIcon = [[UIImage imageNamed:@"InformationIcon.png"] retain];
		minorDelaysIcon = [[UIImage imageNamed:@"MinorDelaysIcon.png"] retain];
		partSuspendedIcon = [[UIImage imageNamed:@"PartSuspendedIcon.png"] retain];
		severeDelaysIcon = [[UIImage imageNamed:@"SevereDelaysIcon.png"] retain];
		suspendedIcon = [[UIImage imageNamed:@"SuspendedIcon.png"] retain];
	}

	-(void)addTubeLine:(TubeLine *)tubeLine
	{
		for (TubeLine *element in displayList) {
			if ( [element.name isEqualToString:tubeLine.name] )
			{
				element.statusText = [[NSString alloc] initWithString:tubeLine.statusText];
				element.statusType = [[NSString alloc] initWithString:tubeLine.statusType];
				element.messages = [[NSString alloc] initWithString:tubeLine.messages];
				element.lastUpdate = [[NSString alloc] initWithString:tubeLine.lastUpdate];
			}
		}

		[[(RootViewController *)[self.navigationController topViewController] tableView] reloadData];
	}

	- (void)viewDidLoad {
		// set up the display list of tube lines
		[self setUpDisplayList];
	}

	- (void)getTubeStatusData
	{
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

		NSError *parseError = nil;
	    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	    XMLReader *streamingParser = [[XMLReader alloc] init];
	    [streamingParser parseXMLFileAtURL:[NSURL URLWithString:feedURLString] parseError:&parseError];
	    [streamingParser release];        
	    [pool release];

	    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}

	- (void)setUpDisplayList {
		// build the tube lines display list
		NSMutableArray *tubeLinesArray = [[NSMutableArray alloc] init];

		// Bakerloo
		TubeLine *tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Bakerloo";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"BakerlooColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Central
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Central";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"CentralColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Circle
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Circle";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"CircleColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// District
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"District";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"DistrictColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];
		
		/*
		// East London - Disabled as it's becoming part of the Overground Network
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"East London";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"EastLondonColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];
		 */

		// Hammersmith & City
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Hammersmith & City";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"HammersmithCityColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Jubilee
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Jubilee";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.messages = [[NSMutableArray alloc] init];
		tubeLine.tabImage = [[UIImage imageNamed:@"JubileeColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Metropolitan
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Metropolitan";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"MetropolitanColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Northern
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Northern";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"NorthernColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Piccadilly
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Piccadilly";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"PiccadillyColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Victoria
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Victoria";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"VictoriaColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// Waterloo & City
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"Waterloo & City";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"WaterlooCityColorTab.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// DLR
		tubeLine = [[TubeLine alloc] init];
		tubeLine.name = @"DLR";
		tubeLine.statusText = updatingStatusTextMessage;
		tubeLine.tabImage = [[UIImage imageNamed:@"DLR.png"] retain];
		[tubeLinesArray addObject:tubeLine];

		// assign the display list
		self.displayList = tubeLinesArray;
		[tubeLinesArray release];

		// spwan a thread to go and get the tube line status xml
		[NSThread detachNewThreadSelector:@selector(getTubeStatusData) toTarget:self withObject:nil];
	}

	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		// Number of sections to display in the table
		return 1;
	}


	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return [displayList count];
	}

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

		static NSString *TubeLineIdentifier = @"TubeLineIdentifier";

		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TubeLineIdentifier];

		if (cell == nil) {
			cell = [self tableviewCellWithReuseIdentifier:TubeLineIdentifier];
		}

		UILabel *label;

		TubeLine *tubeLine = [displayList objectAtIndex:indexPath.row];

		// tube line name
		label = (UILabel *)[cell viewWithTag:TUBE_LINE_NAME_TAG];
		label.text = tubeLine.name;

		// tubline status
		label = (UILabel *)[cell viewWithTag:STATUS_TEXT_TAG];

		if ([tubeLine.statusText isEqualToString:updatingStatusTextMessage])
		{
			label.textColor = [UIColor grayColor];
		}
		else
		{
			label.textColor = [UIColor blackColor];
		}

		label.text = tubeLine.statusText;

		// tube line tab color
		UIImageView *imageView = (UIImageView *)[cell viewWithTag:LINE_COLOR_IMAGE_TAG];
		imageView.image = tubeLine.tabImage;

		imageView = (UIImageView *)[cell viewWithTag:STATUS_ICON_IMAGE_TAG];

		// if we do not have a status for the tube line yet
		if ([tubeLine.statusText isEqualToString:updatingStatusTextMessage]) {
			imageView.image = nil;
		}
		else {
			// assign the tube lines status icon based on the status text
			if ([tubeLine.statusText isEqualToString:@"Good service"]) {
				imageView.image = goodServiceIcon;
			}
			else if ([tubeLine.statusText isEqualToString:@"Minor delays"]) {
				imageView.image = minorDelaysIcon;
			}
			else if ([tubeLine.statusText isEqualToString:@"Part closure"]) {
				imageView.image = partSuspendedIcon;
			}
			else if ([tubeLine.statusText isEqualToString:@"Part suspended"]) {
				imageView.image = partSuspendedIcon;
			}
			else if ([tubeLine.statusText isEqualToString:@"Severe delays"]) {
				imageView.image = severeDelaysIcon;
			}
			else if ([tubeLine.statusText isEqualToString:@"Suspended"]) {
				imageView.image = suspendedIcon;
			}
			else if ([tubeLine.statusText isEqualToString:@"Planned closure"]) {
				imageView.image = suspendedIcon;
			}
			else {
				imageView.image = informationIcon;
			}
		}

		// Set up the cell
		return cell;
	}

	- (UITableViewCell *)tableviewCellWithReuseIdentifier:(NSString *)identifier {

		// Create an instance of UITableViewCell and add tagged subviews for the tube line status details.
		CGRect rect;

		rect = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);

		UITableViewCell *cell = [[[UITableViewCell alloc] initWithFrame:rect reuseIdentifier:identifier] autorelease];

		/*
		 Create labels for the text fields; set the highlight color so that when the cell is selected it changes appropriately.
		 */
		UILabel *label;

		// rect = CGRectMake(LEFT_COLUMN_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, LEFT_COLUMN_WIDTH, LABEL_HEIGHT);
		rect = CGRectMake(LEFT_COLUMN_OFFSET, 5, LEFT_COLUMN_WIDTH, 30);
		label = [[UILabel alloc] initWithFrame:rect];
		label.tag = TUBE_LINE_NAME_TAG;
		label.font = [UIFont boldSystemFontOfSize:MAIN_FONT_SIZE];
		label.adjustsFontSizeToFitWidth = YES;
		[cell.contentView addSubview:label];
		label.highlightedTextColor = [UIColor whiteColor];
		[label release];

		// rect = CGRectMake(MIDDLE_COLUMN_OFFSET, (ROW_HEIGHT - LABEL_HEIGHT) / 2.0, MIDDLE_COLUMN_WIDTH, LABEL_HEIGHT);
		rect = CGRectMake(MIDDLE_COLUMN_OFFSET, 30, 150, LABEL_HEIGHT);
		label = [[UILabel alloc] initWithFrame:rect];
		label.tag = STATUS_TEXT_TAG;
		label.font = [UIFont systemFontOfSize:SMALL_FONT_SIZE];
		label.adjustsFontSizeToFitWidth = YES;
		[cell.contentView addSubview:label];
		label.highlightedTextColor = [UIColor whiteColor];
		[label release];

		// tube line color tab
		rect = CGRectMake(0, 0, 30, 60);
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
		imageView.tag = LINE_COLOR_IMAGE_TAG;
		[cell.contentView addSubview:imageView];
		[imageView release];

		// status image icon
		rect = CGRectMake(RIGHT_COLUMN_OFFSET, (ROW_HEIGHT - IMAGE_SIDE) / 2.0, IMAGE_SIDE, IMAGE_SIDE);
		imageView = [[UIImageView alloc] initWithFrame:rect];
		imageView.tag = STATUS_ICON_IMAGE_TAG;
		[cell.contentView addSubview:imageView];
		[imageView release];

		return cell;
	}

	 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

		 // get the tube line that was selected
		 TubeLine *tubeLine = [displayList objectAtIndex:indexPath.section];

		 // if we are still updating i.e its detail messages have not been retrieved, ignore the user selection
		 if ([tubeLine.statusText isEqualToString:updatingStatusTextMessage]) {
			 [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		 }
		 else {
			 // display the messages detail
			 DetailViewController *detailViewController = [[DetailViewController alloc] init];
			 [detailViewController setTubeLine:tubeLine];
			 [[self navigationController] pushViewController:detailViewController animated:YES];
		 }
	}


	/*
	 Override if you support editing the list
	- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

		if (editingStyle == UITableViewCellEditingStyleDelete) {
			// Delete the row from the data source
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		}	
		if (editingStyle == UITableViewCellEditingStyleInsert) {
			// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
		}	
	}
	*/


	/*
	 Override if you support conditional editing of the list
	- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
		// Return NO if you do not want the specified item to be editable.
		return YES;
	}
	*/


	/*
	 Override if you support rearranging the list
	- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	}
	*/


	/*
	 Override if you support conditional rearranging of the list
	- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
		// Return NO if you do not want the item to be re-orderable.
		return YES;
	}
	 */ 


	- (void)viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	- (void)viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	}

	- (void)viewWillDisappear:(BOOL)animated {
	}

	- (void)viewDidDisappear:(BOOL)animated {
	}


	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		// Return YES for supported orientations
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}


	- (void)didReceiveMemoryWarning {
		[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	}


	- (void)dealloc {
		[displayList release];
		[super dealloc];
	}


	@end


