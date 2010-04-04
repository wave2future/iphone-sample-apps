//
//  TubeLine.h
//  TubeStatus
//
//  Created by Malcolm Barclay on 21/06/2008.
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

#import <Foundation/Foundation.h>

@interface TubeLine : NSObject 
{
	NSString *name;				// name of the tube line
	NSString *statusType;		// current status of the tube line
	NSString *statusText;		// short status description
	NSString *messages;			// detail status messages
	NSString *lastUpdate;		// last updated text
	UIImage *tabImage;			// tube line color
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *statusType;
@property (nonatomic, retain) NSString *statusText;
@property (nonatomic, retain) NSString *messages;
@property (nonatomic, retain) NSString *lastUpdate;
@property (nonatomic, retain) UIImage *tabImage;

@end
