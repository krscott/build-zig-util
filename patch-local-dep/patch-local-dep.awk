#!/usr/bin/env -S awk -f

BEGIN {
    TAB = "    "

    if (ARGC < 3) {
        print "Usage: ./update_dependency.awk <dependency_name> <local_path> <input_file>"
        exit 1
    }

    dep_pattern = "^" TAB TAB "\\." ARGV[1] " = \\.{$"
    local_path = ARGV[2]

    # Clear ARGV to avoid processing as input files
    ARGV[1] = ""
    ARGV[2] = ""

}

$0 ~ dep_pattern, $0 ~ "^" TAB TAB "},$" {
    if ($0 ~ /^\s*\.url =/) {
        print TAB TAB TAB ".path = \"" local_path "\","
        next
    }
    if ($0 ~ /^\s*\.hash =/) {
        next
    }
}

{ print }
