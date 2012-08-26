//
//  DLog.m
//  Ideawork
//
//  Created by Bill Snook on 9/29/10.
//  Copyright Ideawork Studios 2010. All rights reserved.
//

#import "DLog.h"


#define	useTimestamp


void _DLog( const char *file, const char *func, int line, NSString *format, ... ) {

	va_list argList;
	NSString *logInfo;
	NSString *fileInfo;
	
	va_start ( argList, format );
	if ( ! [format hasSuffix: @"\n"] )
		format = [format stringByAppendingString: @"\n"];
	logInfo = [[NSString alloc] initWithFormat: format arguments: argList];
	va_end ( argList );
	
	fileInfo = [[NSString stringWithUTF8String: file] lastPathComponent];
	NSString *funcString = [NSString stringWithCString: func encoding: NSUTF8StringEncoding];
	NSArray *fArray = [funcString componentsSeparatedByString: @" "];
	NSMutableString *methodName = [((NSString *)[fArray objectAtIndex: fArray.count - 1]) mutableCopy];
#ifdef	useTimestamp
	NSString *timeInfo;
	NSDateFormatter *ts = [[NSDateFormatter alloc] init];
	[ts setDateFormat:@"mm:ss.SSS"];
//	[ts setDateFormat:@"yyyy-MM-dd kk:mm:ss.SSS"];
	timeInfo = [ts stringFromDate: [NSDate date]];
//	[ts release];
	fprintf( stderr,"%9s %-12.12s:%5d  %-32.32s  %s", [timeInfo UTF8String], [fileInfo UTF8String], line, [[methodName stringByReplacingOccurrencesOfString: @"]" withString: @""] UTF8String], [logInfo UTF8String] );
//	fprintf( stderr,"%23s  %s:%d  %s", [timeInfo UTF8String], [fileInfo UTF8String], line, [logInfo UTF8String] );
#else
	fprintf( stderr,"%-12.12s:%5d %-32.32s  %s", [fileInfo UTF8String], line, [[methodName stringByReplacingOccurrencesOfString: @"]" withString: @""] UTF8String], [logInfo UTF8String] );
//	fprintf( stderr,"%18s:%4d  %s", [fileInfo UTF8String], line, [logInfo UTF8String] );
#endif
}
