// Based on github.com/krugazor/MCChat

#import "MPCManager.h"

static NSString * const AppServiceType = @"chat-service";

@interface MPCManager () <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate>
@property(nonatomic, copy) NSString *displayName;
@property(nonatomic, strong) MCPeerID *localPeerID;
@property(nonatomic, strong) MCNearbyServiceAdvertiser *advertiser;
@property(nonatomic, strong) MCNearbyServiceBrowser *browser;
@property(nonatomic) MCSession *session;
@end

@implementation MPCManager

- (MCSession*) createOrGetSession {
    NSLog(@"createOrGetSession");

    if (self.session == nil) {
        self.session = [[MCSession alloc] initWithPeer:self.localPeerID securityIdentity:nil encryptionPreference:MCEncryptionNone];
        self.session.delegate = self;
    }
    return self.session;
}

- (instancetype)hostWithDisplayName:(NSString *)n {
    NSLog(@"initAsHostWithDisplayName: %@", n);

    self.displayName = n;
    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:n];

    self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID discoveryInfo:nil serviceType:AppServiceType];
    self.advertiser.delegate = self;
    [self.advertiser startAdvertisingPeer];

    return self;
}

- (instancetype)joinWithDisplayName:(NSString *)n {
    NSLog(@"joinWithDisplayName: %@", n);

    self.localPeerID = [[MCPeerID alloc] initWithDisplayName:n];

    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.localPeerID serviceType:AppServiceType];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];

    return self;
}

- (void) advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler: (void(^)(BOOL accept, MCSession *session))invitationHandler {
    NSLog(@"didReceiveInvitationFromPeer: %@", [peerID displayName]);
    invitationHandler(YES, [self createOrGetSession]);
}

- (void) browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(nullable NSDictionary<NSString *, NSString *> *)info {
    NSLog(@"foundPeer: %@", [peerID displayName]);
    [browser invitePeer:peerID toSession:[self createOrGetSession] withContext:nil timeout:30.0]; // 30s
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID {
    NSLog(@"lostPeer: %@", [peerID displayName]);
}

- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    NSLog(@"didChangeState: %ld", state);
}

- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
    NSLog(@"didReceiveData: %@", [peerID displayName]);
}

- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID {
    NSLog(@"didReceiveStream: %@", [peerID displayName]);
}

- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress {
    NSLog(@"didStartReceivingResourceWithName: %@", [peerID displayName]);
}

- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    NSLog(@"didFinishReceivingResourceWithName: %@", [peerID displayName]);
}

@end
