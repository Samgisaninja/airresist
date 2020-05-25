#include <stdio.h>

int main(int argc, char *argv[], char *envp[]) {
	NSArray *contentsOfDynamicLibs = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/Library/MobileSubstrate/DynamicLibraries/" error:nil];
	for (NSString *file in contentsOfDynamicLibs) {
        if ([file hasSuffix:@".plist"]) {
            NSString *filePath = [NSString stringWithFormat:@"/Library/MobileSubstrate/DynamicLibraries/%@", file];
            NSDictionary *filterPlist = [NSDictionary dictionaryWithContentsOfFile:filePath];
			if ([[filterPlist objectForKey:@"Filter"] objectForKey:@"Bundles"]) {
				if ([[[filterPlist objectForKey:@"Filter"] objectForKey:@"Bundles"] containsObject:@"com.apple.UIKit"]) {
					NSMutableArray *newBundles = [NSMutableArray arrayWithArray:[[filterPlist objectForKey:@"Filter"] objectForKey:@"Bundles"]];
					[newBundles removeObject:@"com.apple.UIKit"];
					[newBundles addObject:@"com.apple.springboard"];
					// Get a list of apps instead of just adding SpringBoard
					NSMutableDictionary *newFilter = [NSMutableDictionary dictionaryWithDictionary:[filterPlist objectForKey:@"Filter"]];
					[newFilter setObject:newBundles forKey:@"Bundles"];
					NSMutableDictionary *newPlist = [NSMutableDictionary dictionaryWithDictionary:filterPlist];
					[newPlist setObject:newFilter forKey:@"Filter"];
					[newPlist writeToFile:[NSString stringWithFormat:@"%@_TEST.plist", filePath] atomically:TRUE];
				}
			}
            
        }
	}
}
