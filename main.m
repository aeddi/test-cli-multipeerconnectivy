#import <Foundation/Foundation.h>
#import "MPCManager.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
		if (argc > 1 && !strcmp(argv[1], "host")) {
			[[MPCManager alloc] hostWithDisplayName:@"cli-host"];
		} else {
			[[MPCManager alloc] joinWithDisplayName:@"cli-guest"];
		}

		dispatch_main();
    }
    return 0;
}
