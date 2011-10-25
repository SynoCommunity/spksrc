#!/usr/bin/perl
use File::Copy;

if (open (IN,"/usr/local/openssh/log/openssh-spk.log")) {
	print "<table>";
	while($l=<IN>) {
		print "<tr>";
		if ($l =~ /(.{29}).{3}(.*)/ )
		{
			print "<td>$1</td><td>-</td><td>$2</td>";
			print "</tr>";
		}
	}
	print "</table>";
	close(IN);
}

exit(0);
