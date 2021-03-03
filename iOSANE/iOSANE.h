//
//  iOSANE.h
//

#ifndef iOSANE_iOSANE_h
#define iOSANE_iOSANE_h

// macros //

// DEBUG_MSG() -- display message box with debug string
#define DEBUG_MSG(msg) { UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"DEBUG_MSG" message: msg delegate: nil cancelButtonTitle: @"OK" otherButtonTitles: nil ]; [alert show]; }

// SAFE_FREE() -- safe release of memory pointers
#define SAFE_FREE(ptr) if(ptr) { free((void*) ptr); ptr = NULL; }

// SAFE_RELEASE() -- safe release of interface objects
#define SAFE_RELEASE(obj) if(obj) { [obj release];     obj = nil;  }

// TRY_CATCH_DONT_CARE() -- compiler requires try/catch but result doesn't matter
#define TRY_CATCH_DONT_CARE(fn) @try { fn; } @catch(NSException* e) {}

// library function prototypes //

#define DECL_LIB_FN_PROTOTYPE(fn) FREObject fn (FREContext, void*, uint32_t, FREObject*)

void iOSANEExtensionInitializer(void**, FREContextInitializer*, FREContextFinalizer*);
void iOSANEContextInitializer(void*, const uint8_t*, FREContext, uint32_t*, const FRENamedFunction**);
void iOSANEContextFinalizer(void*);

DECL_LIB_FN_PROTOTYPE(getLongestDisplaySide);
DECL_LIB_FN_PROTOTYPE(keepScreenOn);
DECL_LIB_FN_PROTOTYPE(messageBox);
DECL_LIB_FN_PROTOTYPE(testANE);

#endif // iOSANE_iOSANE_h
