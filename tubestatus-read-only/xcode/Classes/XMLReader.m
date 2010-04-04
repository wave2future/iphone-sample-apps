//
//  XMLReader.m
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

#import "XMLReader.h"

@implementation XMLReader
@synthesize currentTubeLineObject = currentTubeLineObject;
@synthesize contentOfCurrentTubeLineProperty = contentOfCurrentTubeLineProperty;

NSString *linesLastUpdate;

- (void)parseXMLFileAtURL:(NSURL *)URL parseError:(NSError **)error;
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [parser setDelegate:self];

	/*
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
	*/

    [parser parse];

    NSError *parseError = [parser parserError];
    if (parseError && error) {
        *error = parseError;
    }

    [parser release];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{	
    if (qName) 
	{
        elementName = qName;
    }

	if ([elementName isEqualToString:@"lines"]) {
		linesLastUpdate = [[NSString alloc] initWithString:[attributeDict valueForKey:@"lastUpdate"]];
    }

	if ([elementName isEqualToString:@"line"]) {
		// A line entry in the feed represents a tube line, so create an instance of it.
        self.currentTubeLineObject = [[TubeLine alloc] init];

		// Assign the attributes of the tube line
		self.currentTubeLineObject.name = [attributeDict valueForKey:@"name"];
		self.currentTubeLineObject.statusType = [attributeDict valueForKey:@"statustype"];
		self.currentTubeLineObject.statusText = [attributeDict valueForKey:@"statustext"];
		self.currentTubeLineObject.lastUpdate = linesLastUpdate;
    }

	// extract the messages
	if ([elementName isEqualToString:@"messages"]) 
	{
		self.contentOfCurrentTubeLineProperty = [NSMutableString string];
    }
	else 
	{
        self.contentOfCurrentTubeLineProperty = nil;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{     
    if (qName) 
	{
        elementName = qName;
    }

    if ([elementName isEqualToString:@"messages"]) 
	{
		self.currentTubeLineObject.messages = self.contentOfCurrentTubeLineProperty;
    }
	else if ([elementName isEqualToString:@"line"]) {
		// call the main thread and add the tube line to our display list
		[(id)[[UIApplication sharedApplication] delegate] performSelectorOnMainThread:@selector(addToTubeLineList:) withObject:self.currentTubeLineObject waitUntilDone:YES];
        return;	
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.contentOfCurrentTubeLineProperty) {
        // If the current element is one whose content we care about, append 'string'
        [self.contentOfCurrentTubeLineProperty appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {
	// If the current element is one whose content we care about, append 'string'
	self.contentOfCurrentTubeLineProperty = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
}


@end