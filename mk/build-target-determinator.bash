#!bash
#
# A fairly-reliable method of determining the SPKs that need to be rebuild based on the files that
# changed in the last commit.  Only looks at cross/* native/* and spk/* because, well, mk/* might
# be a bit harder, and toolchains/* would require a rebuild of the world.
#
# I did this as a script rather than inside a mk/spksrc.spk.mk target to ensure I'm not evaluating
# this on every run, only when needed.

# test via:  git diff --stat HEAD^^^ | bash mk/build-target-determinator.bash
# expected output is a list of subdirs of spk dir
awk '
func getdeps(depdir) {
	checked[depdir]++

	# somewhat reliable shell-exec grep for Makefiles referring to what we have
	command = "grep -l \"DEPENDS .*"depdir"\" {cross,native,spk}/*/Makefile"
	while ((command | getline line) > 0) {
		split(line,path,"/");
		dep[path[1]"/"path[2]]++;
	}
	close(command)
}

BEGIN {
    # This is effectively a typedef, avoids errors when check has no elements
	checked[2]="bogus"; delete checked[2];
}

/^ (cross|native|spk)\// {
	split($1,path,"/");
	dep[path[1]"/"path[2]]++;
}

END {
	max_cycles = 30  # avoid infinite loop
	while ((length(checked) < length(dep)) && (max_cycles--)) {
		# easier with re-entrant code :)
		# but instead we loop until the checked == depends
		for (d in dep) {
			# simplified "if (d not in checked) { getdeps(d)}"
			found=0;
			for (c in checked) if (c == d) found++;
			if (1 > found) {
			   getdeps(d)
			}
		}
	}
	# print the collected dependents, spk subdirs only
	for (d in dep) if (d ~ "^spk/") { gsub("^spk/","",d); printf "%s ",d; } printf "\n";
}'
