#include <stdio.h>

int main(int argc, char *argv[], char *envp[]) {
	NSMutableArray *listOfApps = [[NSMutableArray alloc] init];
	NSArray *sandboxedAppsDirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/private/var/containers/Bundle/Application/" error:nil];
	for (NSString *sandboxedAppBundle in sandboxedAppsDirContents) {
		NSString *sandboxedAppBundlePath = [NSString stringWithFormat:@"/private/var/containers/Bundle/Application/%@", sandboxedAppBundle];
		NSArray *sandboxedAppBundleContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:sandboxedAppBundlePath error:nil];
		for (NSString *sandboxedAppDir in sandboxedAppBundleContents) {
			if ([sandboxedAppDir hasSuffix:@".app"]) {
				NSString *sandboxedAppDirPath = [sandboxedAppBundlePath stringByAppendingPathComponent:sandboxedAppDir];
				NSString *infoPlistPath = [sandboxedAppDirPath stringByAppendingPathComponent:@"Info.plist"];
				NSString *pluginsDirPath = [sandboxedAppDirPath stringByAppendingPathComponent:@"PlugIns"];
				if ([[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath]) {
					if ([[NSDictionary dictionaryWithContentsOfFile:infoPlistPath] objectForKey:@"CFBundleIdentifier"]) {
						[listOfApps addObject:[[NSDictionary dictionaryWithContentsOfFile:infoPlistPath] objectForKey:@"CFBundleIdentifier"]];
					}
				}
				if ([[NSFileManager defaultManager] fileExistsAtPath:pluginsDirPath]) {
					NSArray *pluginsDirPathContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pluginsDirPath error:nil];
					for (NSString *appPlugin in pluginsDirPathContents) {
						NSString *appPluginInfoPlistPath = [[pluginsDirPath stringByAppendingPathComponent:appPlugin] stringByAppendingPathComponent:@"Info.plist"];
						if ([[NSFileManager defaultManager] fileExistsAtPath:appPluginInfoPlistPath]) {
							if ([[NSDictionary dictionaryWithContentsOfFile:appPluginInfoPlistPath] objectForKey:@"CFBundleIdentifier"]) {
								[listOfApps addObject:[[NSDictionary dictionaryWithContentsOfFile:appPluginInfoPlistPath] objectForKey:@"CFBundleIdentifier"]];
							}
						}
					}
				}
			}
		}
	}
	NSArray *systemAppsContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Applications" error:nil];
	for (NSString *systemApp in systemAppsContents) {
		NSString *systemAppPath = [NSString stringWithFormat:@"/Applications/%@", systemApp];
		NSString *infoPlistPath = [systemAppPath stringByAppendingPathComponent:@"Info.plist"];
		NSString *pluginsDirPath = [systemAppPath stringByAppendingPathComponent:@"PlugIns"];
		if ([[NSFileManager defaultManager] fileExistsAtPath:infoPlistPath]) {
			if ([[NSDictionary dictionaryWithContentsOfFile:infoPlistPath] objectForKey:@"CFBundleIdentifier"]) {
				[listOfApps addObject:[[NSDictionary dictionaryWithContentsOfFile:infoPlistPath] objectForKey:@"CFBundleIdentifier"]];
			}
		}
		if ([[NSFileManager defaultManager] fileExistsAtPath:pluginsDirPath]) {
			NSArray *pluginsDirPathContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:pluginsDirPath error:nil];
			for (NSString *appPlugin in pluginsDirPathContents) {
				NSString *appPluginInfoPlistPath = [[pluginsDirPath stringByAppendingPathComponent:appPlugin] stringByAppendingPathComponent:@"Info.plist"];
				if ([[NSFileManager defaultManager] fileExistsAtPath:appPluginInfoPlistPath]) {
					if ([[NSDictionary dictionaryWithContentsOfFile:appPluginInfoPlistPath] objectForKey:@"CFBundleIdentifier"]) {
						[listOfApps addObject:[[NSDictionary dictionaryWithContentsOfFile:appPluginInfoPlistPath] objectForKey:@"CFBundleIdentifier"]];
					}
				}
			}
		}
	}
	[listOfApps addObject:@"com.apple.springboard"];
	[listOfApps addObject:@"com.apple.backboardd"];
	NSArray *contentsOfDynamicLibs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/MobileSubstrate/DynamicLibraries/" error:nil];
	for (NSString *file in contentsOfDynamicLibs) {
        if ([file hasSuffix:@".plist"]) {
            NSString *filePath = [NSString stringWithFormat:@"/Library/MobileSubstrate/DynamicLibraries/%@", file];
            NSDictionary *filterPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
			if ([[filterPlist objectForKey:@"Filter"] objectForKey:@"Bundles"]) {
				if ([[[filterPlist objectForKey:@"Filter"] objectForKey:@"Bundles"] containsObject:@"com.apple.UIKit"]) {
					NSMutableArray *newBundles = [NSMutableArray arrayWithArray:[[filterPlist objectForKey:@"Filter"] objectForKey:@"Bundles"]];
					[newBundles removeObject:@"com.apple.UIKit"];
					[newBundles addObjectsFromArray:listOfApps];
					NSMutableDictionary *newFilter = [NSMutableDictionary dictionaryWithDictionary:[filterPlist objectForKey:@"Filter"]];
					[newFilter setObject:newBundles forKey:@"Bundles"];
					NSMutableDictionary *newPlist = [NSMutableDictionary dictionaryWithDictionary:filterPlist];
					[newPlist setObject:newFilter forKey:@"Filter"];
					[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
					[newPlist writeToFile:filePath atomically:TRUE];
				}
			}
            
        }
	}
}
