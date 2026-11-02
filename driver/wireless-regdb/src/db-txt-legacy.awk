# Rewrites the rules of db.txt in the syntax the genregdb.awk of kernels before
# 4.4 reads: (gain, power in dBm), and PASSIVE-SCAN, NO-IBSS for NO-IR
/^[ \t]*\(/ {
	line = $0
	sub(/^[ \t]*/, "", line)
	range = line
	sub(/\),.*/, ")", range)
	rest = line
	sub(/^[^)]*\),[ \t]*/, "", rest)
	power = rest
	sub(/\).*/, "", power)
	sub(/^\(/, "", power)
	flags = rest
	sub(/^[^)]*\)/, "", flags)
	# A DFS CAC time, in its own parentheses, is unknown to these kernels
	sub(/^,[ \t]*\([0-9]+\)/, "", flags)
	gsub(/NO-IR/, "PASSIVE-SCAN, NO-IBSS", flags)
	if (power ~ /mW/) {
		sub(/[ \t]*mW/, "", power)
		power = int(10 * log(power) / log(10) + 0.5)
	}
	printf "\t%s, (N/A, %d)%s\n", range, power, flags
	next
}
{ print }
