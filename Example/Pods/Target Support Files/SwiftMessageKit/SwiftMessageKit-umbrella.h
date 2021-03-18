#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "KKAudioControlManager.h"
#import "KKAudioLongPressListener.h"
#import "KKMuteSwitchListener.h"
#import "KKVolumeProgressWindow.h"
#import "InputBarAccessoryView-Bridging-Header.h"
#import "MessageKit.h"

FOUNDATION_EXPORT double SwiftMessageKitVersionNumber;
FOUNDATION_EXPORT const unsigned char SwiftMessageKitVersionString[];

