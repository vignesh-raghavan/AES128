#!/usr/bin/perl


open(CRC, "<logicfriday_sbox");
@c = <CRC>;
chomp(@c);
close(CRC);

open(CRC, ">sbox.bool");


print CRC "module sbox (\n";
print CRC "	input [7:0] index,\n";
print CRC "\n";
print CRC "	output [7:0] o\n";
print CRC ");\n";
print CRC "\n";
print CRC "wire a, b, c, d, e, f, g, h;\n";
print CRC "\n";
print CRC "assign a = index[7];\n";
print CRC "assign b = index[6];\n";
print CRC "assign c = index[5];\n";
print CRC "assign d = index[4];\n";
print CRC "assign e = index[3];\n";
print CRC "assign f = index[2];\n";
print CRC "assign g = index[1];\n";
print CRC "assign h = index[0];\n";
print CRC "\n";
print CRC "\n";
print CRC "wire [591:0] x;\n\n\n";


$i=0;
$j = 0;
$k = 7;
foreach $cc(@c)
{
	$cc =~ s/^.*?= //;
	next if($cc =~ m/^ *$/);
	$cc = lc($cc);
	
	@m = split(/ *\+ */, $cc);
	foreach $mm(@m)
	{
		#print CRC $mm, "\n";
		$mm =~ s/ *;/;/;
		$mm =~ s/; *$//;
		$mm =~ s/ / & /g; #AND
		$mm =~ s/(\w)'/(~$1)/g; #NOT

		if($term{$mm} == undef)
		{
			$term{$mm} = $i;
			print CRC "\nassign x[$i] = ( $mm );";
			#print CRC $mm, "\n";
		}
		else
		{
			print CRC "\nassign x[$i] = ( x[$term{$mm}] );";
			#print CRC $mm, "#$term{$mm}\n";
		}
		$i++;
	}

	$len =  keys%term;
	print $len, "\n";
	print CRC "\n\n\nassign o[$k] = |(x[",$i-1,":$j]);\n\n\n";
	$k--;
	$j = $i;
}

print CRC "endmodule\n";

close(CRC);
