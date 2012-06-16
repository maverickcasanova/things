#!/usr/bin/awk -f
# Copyright (c) 2012, Piotr Karbowski <piotr.karbowski@gmail.com>

# Minify package.use, remove join multiple lines with the same package and remove duplicate flags.

# Usage: awk -f minify_package_use.awk /etc/portage/package.use > /etc/portage/new_package.use
# Check new_package.use and replace old package.use with new_package.use.

$1 !~ "^(([ \t]+#|#)|$)" {
	target = $1; $1 = ""
	flags = $0
	sub(/^[ \t]+/, "", flags);
	#flags = substr($0, index($0,$2))
	if (package_use_flags[target]) {
		package_use_flags[target] = flags " " package_use_flags[target]
	} else {
		package_use_flags[target] = flags
	}
}


END {
	# loop over all the flags and remove duplicates.
	for (i in package_use_flags) {		
		# Clear le_flags variable and seen array.
		new_flags=""
		split("", seen)

		split(package_use_flags[i], le_flags, "[ \t]+");
		for (x in le_flags) {
			seen[le_flags[x]]
		}
		for (flag in seen) {
			if (new_flags) {
				new_flags = new_flags " " flag
			} else {
				new_flags = flag
			}
		}
		print i, new_flags
	}
}
