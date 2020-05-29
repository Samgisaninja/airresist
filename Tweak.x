%hookf(void *, const char *path, int mode) {
	printf("AIRRESIST TESTING: %{public}s", path);
	return %orig;
}