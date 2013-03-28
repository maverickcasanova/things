#!/usr/bin/awk -f
# Combine current /etc/hosts with a adfree's hosts
# Since google dropped adfree from market, this is a solution.

BEGIN {
	while (getline < "/etc/hosts" > 0) {
		if ($0 != "### Adfree hosts below ###") {
			print
		} else {
			break
		}
	}
	print "### Adfree hosts below ###"
	cmd = "curl --silent --compressed  \"http://winhelp2002.mvps.org/hosts.txt\""
	while (cmd | getline > 0) {
		if ($1 == "127.0.0.1") {
			print $1, $2
		}
	}
	close(cmd)
}
