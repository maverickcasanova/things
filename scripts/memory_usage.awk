#!/usr/bin/awk -f
#
# Copyright (c) 2012, Piotr Karbowski <piotr.karbowski@gmail.com>
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# * Redistributions in binary form must reproduce the above copyright notice, this
#   list of conditions and the following disclaimer in the documentation and/or other
#   materials provided with the distribution.
# * Neither the name of the Piotr Karbowski nor the names of its contributors may be
#   used to endorse or promote products derived from this software without specific
#   prior written permission.
#
# Summarize process' memory usage and compare it to free -m memory usage.
# Example output:
#
# 	Memory usage by:
#	ps_mem             3036 MiB
#	free -m            1314 MiB
#
# All hail linux memory managment and KVM with KSM ;-)

BEGIN {
	# You may need to adjust, like 'python ps_mem.py' unless ps_mem is in your $PATH.
	cmd = "ps_mem";
	while (cmd | getline > 0 ) {
		value = $7;
		unit = $8
		if (unit == "GiB") { value = value * 1024 * 1024 ; }
		else if (unit == "MiB") { value = value * 1024; }
		sum += value
	}
	close(cmd);

	cmd = "free -m";
	while ( cmd | getline > 0) {
		if ($2 == "buffers/cache:") {
			free_m_usage = $3;
			break;
		}
	}
	close(cmd);

	printf("%s\n", "Memory usage by:");
	printf("%-18s %d %s\n", "ps_mem", int(sum/1024), "MiB");
	printf("%-18s %d %s\n", "free -m", int(free_m_usage), "MiB");
}
