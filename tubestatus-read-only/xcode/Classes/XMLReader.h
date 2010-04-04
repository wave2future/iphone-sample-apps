//
//  XMLReader.h
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
#import "XMLReader.h"
#import "TubeLine.h"

@interface XMLReader : NSObject {       
    TubeLine *currentTubeLineObject;
    NSMutableString *contentOfCurrentTubeLineProperty;
}

@property (nonatomic, retain) TubeLine *currentTubeLineObject;
@property (nonatomic, retain) NSMutableString *contentOfCurrentTubeLineProperty;

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;

@end