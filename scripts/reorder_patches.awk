#!/usr/bin/awk -f

# Print commands to reorder files, meant for patches.
# usage: ls *.patch | awk -f reorder_files.awk
# Created to easly normalize patch names.
# Example:
# 02_asd.patch   -> 001_asd.patch
# 4421_foo.patch -> 002_foo.patch
# 4423_bar.patch -> 003_bar.patch

BEGIN {
	patch_prefix = "1"
}

{
	orig_name = $0
	stripped_name = $0
	sub(/^[0-9]+[-_]/, "", stripped_name)
	new_name = sprintf("%03d_%s", patch_prefix,  stripped_name)
	if (orig_name != new_name) 	printf("mv -- '%s' '%s'\n", orig_name, new_name)
	patch_prefix++
}
