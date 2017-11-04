#!/usr/bin/perl


open(CRC, "<ISBOX.hex");
#$crc = <CRC>;

#chomp($crc);

#@c = split(/, /, $crc);

@c = <CRC>;
chomp(@c);
close(CRC);

open(CRC, ">ISBOX.txt");

$i = 0;
foreach $cc(@c)
{
	@mm = split('', $cc);
	$m = sprintf("%08b%04b%04b", $i, hex($mm[0]), hex($mm[1]));
	$m =~ s/(\d)/$1 /g;
	$i++;
	print CRC $m, "\n";
}

close(CRC);
