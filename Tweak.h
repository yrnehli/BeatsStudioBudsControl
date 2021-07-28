#import <Foundation/Foundation.h>

typedef struct BTDeviceImpl* BTDeviceImplRef;

@interface BluetoothDevice : NSObject
- (id)name;
- (BOOL)setListeningMode:(unsigned)arg1;
- (unsigned)listeningMode;
@end

@interface AVOutputDevice : NSObject
- (id)name;
@end