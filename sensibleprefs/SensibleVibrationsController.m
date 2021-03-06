#include "SensibleVibrationsController.h"
#include "SensibleConst.h"
#include "Headers.h"

FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(unsigned long, id, NSDictionary*);

@implementation SensibleVibrationsController : PSListController

- (NSArray *)specifiers {
	if (_specifiers == nil) {
		NSMutableArray *specifiers = [[NSMutableArray alloc] init];
		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:LocalizedString(@"TouchID Vibrations") target:self set:Nil get:Nil detail:Nil cell:PSGroupCell edit:Nil];
			specifier;
		})];
		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:LocalizedString(@"Duration") target:self set:NULL get:Nil detail:Nil cell:PSTitleValueCell edit:Nil];
			specifier;
		})];
		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:Nil target:self set:@selector(sendVibrationWithValue:specifier:) get:@selector(readPreferenceValue:) detail:Nil cell:PSSliderCell edit:Nil];
				
			[specifier setProperty:@35 forKey:@"default"];
			[specifier setProperty:SensiblePlist forKey:@"defaults"];
			[specifier setProperty:VibrationDurationKey forKey:@"key"];
			[specifier setProperty:@0 forKey:@"min"];
			[specifier setProperty:@80 forKey:@"max"];
			[specifier setProperty:@YES forKey:@"showValue"];
			[specifier setProperty:@"com.tonyciroussel.sensible/reloadSettings" forKey:@"PostNotification"];
			[specifier setIdentifier:@"Duration"];
			specifier;
		})];
		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:LocalizedString(@"Intensity") target:self set:NULL get:Nil detail:Nil cell:PSTitleValueCell edit:Nil];
			specifier;
		})];
		[specifiers addObject:({
			PSSpecifier *specifier = [PSSpecifier preferenceSpecifierNamed:Nil target:self set:@selector(sendVibrationWithValue:specifier:) get:@selector(readPreferenceValue:) detail:Nil cell:PSSliderCell edit:Nil];
				
			[specifier setProperty:@1 forKey:@"default"];
			[specifier setProperty:SensiblePlist forKey:@"defaults"];
			[specifier setProperty:VibrationIntensityKey forKey:@"key"];
			[specifier setProperty:@0 forKey:@"min"];
			[specifier setProperty:@1 forKey:@"max"];
			[specifier setProperty:@YES forKey:@"showValue"];
			[specifier setProperty:@"com.tonyciroussel.sensible/reloadSettings" forKey:@"PostNotification"];
			[specifier setIdentifier:@"Intensity"];
			specifier;
		})];
		_specifiers = specifiers;
	}
	return _specifiers;
}

- (void)sendVibrationWithValue:(id)value specifier:(PSSpecifier*)specifier;
{
	[self setPreferenceValue:value specifier:specifier];

	NSNumber *intensity;
	NSNumber *duration;
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/User/Library/Preferences/com.tonyciroussel.sensibleprefs.plist"];
	if([specifier.identifier isEqualToString:@"Intensity.0"]){
		intensity = value;
		duration = [settings objectForKey:VibrationDurationKey] ? [settings objectForKey:VibrationDurationKey] : @35;
	}
	else
	{
		duration = value;
		intensity = [settings objectForKey:VibrationIntensityKey] ? [settings objectForKey:VibrationIntensityKey] : @1;
	}
	NSArray* arr = @[[NSNumber numberWithBool:YES], duration];
	NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:arr,@"VibePattern", intensity,@"Intensity",nil];
	AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, dict);
}

@end
