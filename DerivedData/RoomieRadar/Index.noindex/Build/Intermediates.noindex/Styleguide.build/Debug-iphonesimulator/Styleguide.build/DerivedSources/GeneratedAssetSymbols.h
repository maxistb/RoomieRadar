#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The resource bundle ID.
static NSString * const ACBundleID AC_SWIFT_PRIVATE = @"Styleguide";

/// The "beatzColor" asset catalog color resource.
static NSString * const ACColorNameBeatzColor AC_SWIFT_PRIVATE = @"beatzColor";

#undef AC_SWIFT_PRIVATE