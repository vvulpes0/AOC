use strict;
use warnings;
chomp (my $x = <>);
sub rle {
	my $s = shift;
	my $run = 1;
	my $last = '';
	my $out = '';
	foreach(split //,$s) {
		if ($_ eq $last) {
			$run = $run + 1;
		} else {
			$out = $out . $run . $last if ($last ne '');
			$run = 1;
		}
		$last = $_;
	}
	$out = $out . $run . $last;
	return $out
}
sub rleX {
	my $s = shift;
	my $n = shift;
	$s = rle($s) for(1..$n);
	return $s
}
print length(rleX($x,40)) . "\t" . length(rleX($x,50)) . "\n";
