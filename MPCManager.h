// Based on github.com/krugazor/MCChat

#ifndef MPCManager_h
#define MPCManager_h

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPCManager : NSObject

- (instancetype) hostWithDisplayName:(NSString*)n;
- (instancetype) joinWithDisplayName:(NSString*)n;

@end

#endif /* MPCManager_h */
