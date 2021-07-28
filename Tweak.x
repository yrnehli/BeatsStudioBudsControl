#import "Tweak.h"

static NSString *prefsPath = @"/var/mobile/Library/Preferences/xyz.henryli17.beatsstudiobudscontrol.prefs.plist";
NSString *headphonesName = nil;
BluetoothDevice *headphones = nil;

%group Tweak
	%hook BluetoothDevice 
	- (id)initWithDevice:(BTDeviceImplRef)arg1 address:(id)arg2 {
		id orig = %orig;

		if ([[self name] isEqualToString:headphonesName]) {
			headphones = self;
		}

		return orig;
	}
	%end

	%hook AVOutputDevice
	- (id)availableBluetoothListeningModes {
		if ([[self name] isEqualToString:headphonesName]) {
			return [NSArray arrayWithObjects:
				@"AVOutputDeviceBluetoothListeningModeNormal",
				@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation",
				@"AVOutputDeviceBluetoothListeningModeAudioTransparency",
				nil
			];
		}

		return %orig;
	}

	- (BOOL)setCurrentBluetoothListeningMode:(id)arg1 error:(id*)arg2  {
		if (headphones && [[self name] isEqualToString:headphonesName]) {
			NSString *listeningMode = arg1;
			unsigned listeningModeEnum = 1;
			
			if ([listeningMode isEqualToString:@"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation"]) {
				listeningModeEnum = 2;
			} else if ([listeningMode isEqualToString:@"AVOutputDeviceBluetoothListeningModeAudioTransparency"]) {
				listeningModeEnum = 3;
			}

			[headphones setListeningMode:listeningModeEnum];

			return YES;
		}

		return %orig;
	}

	- (id)currentBluetoothListeningMode {
		if (headphones && [[self name] isEqualToString:headphonesName]) {
			unsigned listeningModeEnum = [headphones listeningMode];

			if (listeningModeEnum == 1) {
				return @"AVOutputDeviceBluetoothListeningModeNormal";
			} else if (listeningModeEnum == 2) {
				return @"AVOutputDeviceBluetoothListeningModeActiveNoiseCancellation";
			} else if (listeningModeEnum == 3) {
				return @"AVOutputDeviceBluetoothListeningModeAudioTransparency";
			}
		}

		return %orig;
	}
	%end
%end

%ctor {
	NSMutableDictionary *prefsDict = [[NSMutableDictionary alloc] initWithContentsOfFile:prefsPath];

	if ([[prefsDict objectForKey:@"enabled"] boolValue]) {
		%init(Tweak);
		headphonesName = [[prefsDict objectForKey:@"headphonesName"] stringValue];
	}
}