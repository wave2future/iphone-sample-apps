<?php
/*

	Copyright (C) 2008 Alistair Priest, Malcolm Barclay

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/

include "begin_cache.php";
include_once "HttpClient.class.php";

$url = "http://www.tfl.gov.uk/tfl/livetravelnews/realtime/tube/default.html";
$content = HttpClient::quickGet($url);

// Extract the Service Board from the HTML
$serviceBoardPattern = "/\<DIV id=\"service-board\">(.*?)<\/DIV>/is";
preg_match_all($serviceBoardPattern, $content, $serviceBoards);

// Prefix the TFL website URL
$hrefPattern = "/HREF=\"/is";
$serviceBoard = $serviceBoards[0][0];

// Extract the Tube Line names and links
$linesPattern = "/<DT><a class=\"[^\">]*\" title=\"[^\">]*\" href=\"([^\">]*)\"[^\>]*>(.*?)<\/a><\/DT>/is";
preg_match_all($linesPattern, $serviceBoard, $lines);

// Extract the Tube Line statuses
$lineStatusesPattern = "/<dd>(.*?)<\/dd>/is";
$xserviceBoard = trim($serviceBoard);
$serviceBoard = str_replace(array("\r", "\n", "\t"), "", $serviceBoard);

preg_match_all($lineStatusesPattern, $serviceBoard, $statuses);

$lastUpdatedPattern = "/<p class=\"timestamp\" id=\"last-update\">([^<]*)<\/p>/is";
preg_match_all($lastUpdatedPattern, $content, $lastUpdateds);
$lastUpdated = $lastUpdateds[1][0];

$output = "";

// Output header information
header('Content-type: text/xml');
$output = "<?xml version='1.0' encoding='UTF-8' ?>\n<xml><lines lastUpdate='" . $lastUpdated . "'>";

// Get the set of lines and extract the status
$count = count($lines[0]);
$statusProblemPattern = "/<a [^>]*>(<strong>)?(?P<status>[^<]*)(<\/strong>)?<\/a>/is";

for ($index = 0; $index < $count; $index++) {
	$status = $statuses[1][$index];
	$statusType = "okay";
	if (preg_match_all($statusProblemPattern, $statuses[1][$index], $problem) > 0) {
		$status = $problem['status'][0];
		$statusType = "problem";
	}
	
	// get the realtime updates for each tube line
	$urlTubeNow = "http://www.tfl.gov.uk/tfl/livetravelnews/realtime/tube/" . $lines[1][$index];
	$contentTubeNow = HttpClient::quickGet($urlTubeNow);
	
	// extract the messages from the tube now information
	$messagePattern = "/\<DIV class=\"message\">(.*?)<\/DIV>/is";	
	preg_match_all($messagePattern, $contentTubeNow, $messages);
	
	// paragraph matching pattern
	$paragraphPattern = "/\<P>(.*?)<\/P>/is";

	$output .=  "  <line name='" . $lines[2][$index] . "' statustype='" . $statusType . "' statustext='" . $status . "'>\n";
	
	// if the line has messages
	$messagesOutput = "";
	$messageCount = count($messages);
	
	if ( $messageCount > 0 ) {
		$messagesOutput = "<messages><![CDATA[";
		
		for ( $indexMessage = 0; $indexMessage < $messageCount; $indexMessage++ ) {
			
			$message = $messages[1][$indexMessage];
			if ( strlen( $message ) > 0 ) {
				// extract the first paragraph of the message only
				preg_match_all($paragraphPattern, $message, $paragraphs);
				$messagesOutput .= "<p style='font-family: Helvetica;'>" . $paragraphs[1][0] . "</p>";
			}
		}
		
		// $messagesOutput .= "<p style='font-family: Helvetica; font-style:italic;'>[DLR Messages are in the next version of TubeStatus (1.1), I am waiting on Apple to load into the iTunes Store. Keep the feedback coming!]</p>";
		$messagesOutput .= "]]></messages>\n";
		$output .= $messagesOutput;
		$output .=  "</line>\n";
	}
}


/*
 * DLR Messages 
 */
$dlrUrl = "http://www.tfl.gov.uk/tfl/livetravelnews/realtime/dlr/default.html";
$dlrContent = HttpClient::quickGet($dlrUrl);

// paragraph matching pattern
$paragraphPattern = "/\<p>(.*?)<\/p>/is";

// extract the messages from the dlr content
$messagePattern = "/\<div class=\"message\">(.*?)<\/div>/is";	
preg_match_all($messagePattern, $dlrContent, $messages);

$messages = $messages[0];

$output .=  "  <line name='DLR' statustype='DLR' statustext='Docklands Light Railway'>\n";

// if the dlr has messages
$messagesOutput = "";
$messageCount = count($messages);

if ( $messageCount > 0 ) {
	$messagesOutput = "<messages><![CDATA[";
	
	for ( $indexMessage = 0; $indexMessage < $messageCount; $indexMessage++ ) {
		
		$message = $messages[$indexMessage];
		$message = str_replace('<div class="message">', "", $message);
		$message = str_replace('</div>', "", $message);
		
		if ( strlen( $message ) > 0 ) {
			// extract the paragraphs
			preg_match_all($paragraphPattern, $message, $paragraphs);			
			$paragraphs = $paragraphs[0];
			
			for ( $indexParagraph = 0; $indexParagraph < count($paragraphs); $indexParagraph++ ) {	
				$paragraphMessage = $paragraphs[$indexParagraph];
				
				// we are only interested in messages that are NOT links
				if ( preg_match( "/a href/", $paragraphMessage ) == 0 ) {
					$paragraphMessage = str_replace("<p>", "<p style='font-family: Helvetica;'>", $paragraphMessage);
					$messagesOutput .= $paragraphMessage;
				}
			}
		}
	}
	
	$messagesOutput .= "]]></messages>\n";
	$output .= $messagesOutput;
}

$output .=  "</line>\n";

// Output foooter information
$output .= "</lines></xml>";

print $output;

include "end_cache.php";
?>