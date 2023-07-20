
#ifndef SocketAddress_h
#define SocketAddress_h

#import <Foundation/Foundation.h>

typedef struct sockaddr *sockaddr_t;

@interface SocketAddress : NSObject
@property sockaddr_t sockaddr;
@property(readonly) socklen_t size;

- (instancetype)initWithSockaddr:(struct sockaddr *)address;
@end

#endif /* SocketAddress_h */
