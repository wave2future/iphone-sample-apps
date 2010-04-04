//
//  TubeStatusAppDelegate.m
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

#import "TubeStatusAppDelegate.h"
#import "RootViewController.h"
#import "TubeLine.h"

@implementation TubeStatusAppDelegate

@synthesize window;
@synthesize navigationController;

static RootViewController *rootViewController;

- (id)init {
	if (self = [super init]) {
		// 
	}
	return self;
}

- (void)addToTubeLineList:(TubeLine *)newTubeLine
{
    [rootViewController addTubeLine:newTubeLine];
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// Create the navigation and view controllers
	rootViewController = [[RootViewController alloc] initWithStyle:UITableViewStylePlain];
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
	self.navigationController = aNavigationController;
	[aNavigationController release];
	[rootViewController release];
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}



- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
