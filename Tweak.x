%hookf(void *, dlopen, const char *path, int mode) {
	NSString *pathString = [NSString stringWithUTF8String:path];
	if ([pathString hasPrefix:@"/Library/MobileSubstrate/DynamicLibraries/"]) {
		if ([[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@"/Application"] || [[[[NSProcessInfo processInfo] arguments] objectAtIndex:0] containsString:@"SpringBoard.app"]) {
			NSLog(@"Allowing %@ to load into %@", pathString, [[[NSProcessInfo processInfo] arguments] objectAtIndex:0]);
			return %orig;
		} else {
			NSLog(@"Disallowing %@ to load into %@", pathString, [[[NSProcessInfo processInfo] arguments] objectAtIndex:0]);
			return NULL;
		}
	} else {
	 return %orig;
	}
}