//
//  DLog.h
//  Ideawork
//
//  Created by Bill Snook on 9/29/10.
//  Copyright Ideawork Studios 2010. All rights reserved.
//


#define DEBUG_ROTATE
#define DEBUG_NAVIGATION


#ifdef	DEBUG

#define DLog( args... )		_DLog( __FILE__, __func__, __LINE__, args );

#ifdef DEBUG_ROTATE

#define RLog( args... )		_DLog( __FILE__, __func__, __LINE__, args );

#else

#define RLog( x... )		

#endif	// DEBUG_ROTATE

#ifdef DEBUG_NAVIGATION

#define NLog( args... )		_DLog( __FILE__, __func__, __LINE__, args );

#else

#define NLog( x... )		

#endif	// DEBUG_NAVIGATION

#else

#define DLog( x... )		
#define RLog( x... )		
#define NLog( x... )		

#endif

void _DLog( const char *file, const char *func, int line, NSString *format, ... );
