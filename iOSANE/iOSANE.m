//
//  iOSANE.m
//

// imports & includes //

@import UIKit;

#include <stdlib.h>

#import "FlashRuntimeExtensions.h"
#import "iOSANE.h"

// globals //

// function list
FRENamedFunction* g_pFunc = NULL;

// functions required by Flash //

// extension initializer
void iOSANEExtensionInitializer(void**                 ppExtDataToSet,
								FREContextInitializer* pCtxInitializerToSet,
								FREContextFinalizer*   pCtxFinalizerToSet)
{
	// reset data
	(*ppExtDataToSet) = NULL;
	
	// set context initializer
	(*pCtxInitializerToSet) = &iOSANEContextInitializer;
	
	// reset finalizer
	(*pCtxFinalizerToSet) = &iOSANEContextFinalizer;
}

// context initializer
void iOSANEContextInitializer(void*                    pExtData,
							  const uint8_t*           pCtxType,
							  FREContext               ctx,
							  uint32_t*                pNumFunctionsToSet,
							  const FRENamedFunction** pFunctionsToSet)
{
	// set number of functions
	(*pNumFunctionsToSet) = 4;
	
	// allocate memory for functions
	g_pFunc = g_pFunc ? g_pFunc : (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * (*pNumFunctionsToSet));
	
	// add functions
	#define SET_LIB_FN_POINTER(n, str, fn) g_pFunc[n].name = (const uint8_t*) str; g_pFunc[n].functionData = NULL; g_pFunc[n].function = &fn
	
	SET_LIB_FN_POINTER(0, "getLongestDisplaySide", getLongestDisplaySide);
	SET_LIB_FN_POINTER(1, "keepScreenOn",          keepScreenOn);
	SET_LIB_FN_POINTER(2, "messageBox",            messageBox);
	SET_LIB_FN_POINTER(3, "testANE",               testANE);
	
	// set function pointer
	(*pFunctionsToSet) = g_pFunc;
}

// context finalizer
void iOSANEContextFinalizer(void* pExtData)
{
	// free function list
	SAFE_FREE(g_pFunc);
}

// function implementations //

// getLongestDisplaySide() -- retrieve largest resolution dimension
FREObject getLongestDisplaySide(FREContext ctx,
								void*      pFuncData,
								uint32_t   argc,
								FREObject  argv[])
{
	// get main screen rect
	CGRect screenRect = [[UIScreen mainScreen] nativeBounds];
	
	// get longest side
	int nData = (screenRect.size.width > screenRect.size.height) ? screenRect.size.width : screenRect.size.height;
	
	// object to return
	FREObject pRet = NULL;
	
	// create object
	TRY_CATCH_DONT_CARE(FRENewObjectFromInt32(nData, &pRet));
	
	// ok (errors will fall thru)
	return(pRet);
}

// keepScreenOn() -- prevent display from dimming
FREObject keepScreenOn(FREContext ctx,
					   void*      pFuncData,
					   uint32_t   argc,
					   FREObject  argv[])
{
	// get main application
	UIApplication* application = [UIApplication sharedApplication];
	
	// disable idle timer
	[application setIdleTimerDisabled: YES];
	
	// ok
	return(NULL);
}

// messageBox() -- display simple modal message box
FREObject messageBox(FREContext ctx,
					 void*      pFuncData,
					 uint32_t   argc,
					 FREObject  argv[])
{
	// text lengths
	uint32_t nCaptionLen;
	uint32_t nMessageLen;
	
	// text data
	const uint8_t *pCaption;
	const uint8_t *pMessage;
	
	// get objects
	FREGetObjectAsUTF8(argv[0], &nCaptionLen, &pCaption);
	FREGetObjectAsUTF8(argv[1], &nMessageLen, &pMessage);
	
	// convert to strings
	NSString* caption = [NSString stringWithUTF8String: (const char*) pCaption];
	NSString* message = [NSString stringWithUTF8String: (const char*) pMessage];
	
	// create alert
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle: caption
													message: message
												   delegate: nil
										  cancelButtonTitle: @"OK"
										  otherButtonTitles: nil ];
	
	// run alert
	[alert show];
	
	// ok
	return(NULL);
}

// testANE() -- verify that the library is working correctly
FREObject testANE(FREContext ctx,
				  void*      pFuncData,
				  uint32_t   argc,
				  FREObject  argv[])
{
	// passed parameter
	int32_t nData = 0;
	
	// get first parameter
	FREGetObjectAsInt32(argv[0], &nData);
	
	// object to return
	FREObject pRet = NULL;
	
	// create object
	TRY_CATCH_DONT_CARE(FRENewObjectFromInt32(nData, &pRet));
	
	// ok (errors will fall thru)
	return(pRet);
}

// eof //
