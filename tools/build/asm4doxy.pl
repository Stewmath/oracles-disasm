#!/usr/bin/perl --
#
# asm4doxy.pl - A script which transforms specially-formatted assembly
#	language files into something Doxygen can understand.
#
#	Copyright (C) 2007-2009 Bogdan 'bogdro' Drozdowski
#		(bogdandr AT op.pl, bogdro AT rudy.mif.pg.gda.pl)
#		http://rudy.mif.pg.gda.pl/~bogdro/inne/
#       Copyright (C) 2009 Rick Foos, SolengTech
#               (rick.foos AT solengtech.com)
#          Enhancements for IDA-Pro, MASM, and Procedure calls.
#          New options:
#		./asm4doxy.pl -od ccc/ddd.asm
#              Set the output directory to the file input directory.
#              Allows large blocks of files to be processed in a single
#              command execution.
#		./asm4doxy.pl -nosort ccc/ddd.asm
#              Do not sort structures, functions, and macros alphabetically
#              Position order of data and functions are preserved in output file.
#              Allows data from "org" to appear the same in C file.
#		./asm4doxy.pl -undoc ccc/ddd.asm
#              Show undocumented members.
#              By default only doxygen documented members are shown.
#              Allows large blocks of code to be reviewe
#
#
#	License: GNU General Public Licence v3+
#
#	Last modified : 2009-08-12
#
#	Syntax:
#		./asm4doxy.pl aaa.asm bbb.asm ccc/ddd.asm
#		./asm4doxy.pl --help|-help|-h
#
#	Documentation comments should start with ';;' or '/**' and
#	 end with ';;' or '*/'.
#
#	Examples:
#
#	;;
#	; This procedure reads data.
#	; @param CX - number of bytes
#	; @return DI - address of data
#	;;
#	procedure01:
#		...
#		ret
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 3
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software Foundation:
#		Free Software Foundation
#		51 Franklin Street, Fifth Floor
#		Boston, MA 02110-1301
#		USA

use strict;
use warnings;
use Cwd;
use File::Spec::Functions ':ALL';
use Getopt::Long;
use PerlIO::encoding;
use IO::Handle;


if ( @ARGV == 0 ) {
	print_help ();
	exit 1;
}

Getopt::Long::Configure ("ignore_case", "ignore_case_always");

my $help='';
my $lic='';
my $encoding='iso-8859-1';
my $odir='';
my $undoc='';
my $nosort='';
my $idapro='';
if ( !GetOptions (
	'encoding=s'			=> \$encoding,
	'h|help|?'			=> \$help,
	'ida|idapro'			=> \$idapro,
	'license|licence|l'		=> \$lic,
	'no-sort|nosort|ns'		=> \$nosort,
	'output-directory|odir|od'	=> \$odir,
	'undocumented|undoc|ud'		=> \$undoc,
	)
   )
{
	print_help ();
	exit 2;
}

if ( $lic )
{
	print	"Asm4doxy - a program for converting specially-formatted assembly\n".
		"language files into something Doxygen can understand.\n".
		"See http://rudy.mif.pg.gda.pl/~bogdro/inne\n".
		"Author: Bogdan 'bogdro' Drozdowski, bogdro # rudy.mif.pg.gda.pl.\n\n".
		"(Enhancements): Rick Foos, rick.foos # solengtech.com.\n\n".
		"    This program is free software; you can redistribute it and/or\n".
		"    modify it under the terms of the GNU General Public License\n".
		"    as published by the Free Software Foundation; either version 3\n".
		"    of the License, or (at your option) any later version.\n\n".
		"    This program is distributed in the hope that it will be useful,\n".
		"    but WITHOUT ANY WARRANTY; without even the implied warranty of\n".
		"    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n".
		"    GNU General Public License for more details.\n\n".
		"    You should have received a copy of the GNU General Public License\n".
		"    along with this program; if not, write to the Free Software Foundation:\n".
		"		Free Software Foundation\n".
		"		51 Franklin Street, Fifth Floor\n".
		"		Boston, MA 02110-1301\n".
		"		USA\n";
	exit 1;
}

# if "HELP" is on the command line or no files are given, print syntax
if ( $help || @ARGV == 0 )
{
	print_help ();
	exit 1;
}

# if TEST file (asm4doxy-xx.pl), modify output file with test xx, and coded options.
my ($testname) = $0;
$testname =~ s/.*(-)(\w+)\.pl*$/$2/;
if ($testname eq $0)
{
	$testname = "";
}
else
{
	$testname .= "-od" if ($odir);
	$testname .= "-ud" if ($undoc);
	$testname .= "-ns" if ($nosort);
	$testname .= "-id" if ($idapro);
}

my ($disc, $directory, undef) = splitpath (cwd (), 1);

my @files = sort @ARGV;
my %files_orig;
foreach my $p (@files)
{
	my $newf;
	($newf = $p) =~ s/\./-/go;
	$newf = (splitpath $newf)[2];
	$files_orig{$newf} = (splitpath $p)[2];	# =$p;
}

$encoding     =~ tr/A-Z/a-z/;

my (%files_descr, %files_vars, %files_funcs, %files_vars_descr, %files_funcs_descr,
	%files_funcs_vars, %files_funcs_vars_descr, %files_funcs_vars_values,
	%files_funcs_vars_types, %files_vars_values, %files_structs, %files_structs_descr,
	%files_structs_vars, %files_structs_vars_descr, %files_structs_vars_values,
	%files_macros, %files_macros_descr, %files_includes, %files_includes_descr, %files_vars_types,
	%files_structs_vars_types, %files_sections);

# =================== Reading input files =================
FILES: foreach my $p (@files)
{
	# Hash array key is the filename with dashes instead of dots.
	my $curr_file;
	$curr_file = (splitpath $p)[2];
	$curr_file =~ s/\./-/go;

	# Current variable (or function) and its description:
	my ($current_variable, $current_variable_descr, $current_variable_value, $function,
		$inside_func, $func_name, $type, $structure, $inside_struc,
		$struc_name, $macro, $current_type, $have_descr);
	$type = 0;
	$function = 0;
	$structure = 0;
	$inside_struc = 0;
	$struc_name = "";
	$inside_func = 0;
	$func_name = "";
	$macro = 0;
	$have_descr = 0;

	$files_vars{$curr_file} = ();
	$files_funcs{$curr_file} = ();
	$files_structs{$curr_file} = ();
	$files_macros{$curr_file} = ();
	$files_includes{$curr_file} = "";
	$files_includes_descr{$curr_file} = ();
    $files_sections{$curr_file} = ();

	open (my $asm, "<:encoding($encoding)", catpath($disc, $directory, $p)) or
		die "$0: ".catpath($disc, $directory, $p).": $!\n";

	# find file description, if it exists
	MAIN_DESCR: while ( <$asm> )
	{
		next if (/^\s*$/o && ! $idapro); # to leave when an empty line is encountered (IDA Pro)
		# Force a comment type
		if (($undoc) && ($have_descr == 0))
		{
			$type = 1 if ( /^\s*;;/o && $type == 0 );
			$type = 2 if ( /^\s*\/\*\*/o && $type == 0 );
			$files_descr{$curr_file} .= "" if ($type == 0);
			$type = 1 if ($type == 0);
		}
		$type = 1 if ( /^\s*;;/o && $type == 0 );
		$type = 2 if ( /^\s*\/\*\*/o && $type == 0 );

		if ( /^\s*[\%\#]?include\s*['"]?([\\\/\w\.\-\!\~\(\)\$\@]+)['"]?/io )
		{
			$files_includes{$curr_file} .= "$1 ";
			$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = $files_descr{$curr_file};
			$files_descr{$curr_file} = "";
			last;
		}

		if ( $type == 1 ) # also when the file is undocumented
		{
			last MAIN_DESCR if ( $undoc && (! /^\s*;/o) && $have_descr );
			last MAIN_DESCR if ( ((! /^\s*;/o) || /^\s*;;\s*$/o) && $have_descr );
		}
		elsif ( $type == 2 )
		{
			last MAIN_DESCR if /^\s*\*\/\s*$/o;
		}

		# removing leading comment characters from the beginning of the line
		s/^\s*;+//o if $type == 1;
		s/^\s*\/?\*+//o if $type == 2;

		$files_descr{$curr_file} .= $_ if $type != 0;
		$have_descr = 1;
	}
	if ( ! defined $_ )
	{
		close $asm;
		next FILES;
	}
	if ( /^\s*;;\s*$/o || /^\s*\*\/\s*$/o )
	{
		$_ = <$asm>;
		if ( ! defined $_ )
		{
			close $asm;
			next FILES;
		}
		if ( /^\s*[\%\#]?include\s*['"]?([\\\/\w\.\-\!\~\(\)\$\@]+)['"]?/io )
		{
			$files_includes{$curr_file} .= "$1 ";
			$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = $files_descr{$curr_file};
			undef ($files_descr{$curr_file});
		}
	}

	# if the first comment wasn't about the file
	# all of the data types are executed here...
	if ( (! /^\s*$/o) && (! $undoc) )
	{
		if ( /^\s*[\%\#]?include\s*['"]?([\\\/\w\.\-\!\~\(\)\$\@]+)['"]?/io )
		{
			$files_includes{$curr_file} .= "$1 ";
			$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = $files_descr{$curr_file};
			$files_descr{$curr_file} = "";
			undef ($files_descr{$curr_file});
		}
		# variable/type 1 constant (xxx equ yyy)
		elsif ( /^\s*([\.\w]+)(:|\s+)\s*((times\s+\w+|(d|r|res)[bwudpfqt]\s|equ\s|=)+)\s*([\w\,\.\+\-\s\*\/\\\'\"\!\@\#\$\%\^\&\\(\)\{\}\[\]\<\>\?\=\|]*)/io )
		{
			my ($m1, $m3, $m5);
			$m1 = $1;
			$m3 = $3;
			$m5 = $6;
			# Can't be in a structure yet!
			$files_vars{$curr_file}[++$#{$files_vars{$curr_file}}] = $m1;
			$files_vars_descr{$curr_file}{$m1} = $files_descr{$curr_file};
			$files_vars_types{$curr_file}{$m1} = "$m3 $m5";

			$function = 0;
			my $value = $m5;
			if ( $m3 =~ /equ/io || $m3 =~ /=/o )
			{
				# Can't be in a structure yet!
				$files_vars_values{$curr_file}{$m1} = $value;
			}
			else
			{
				# Can't be in a structure yet!
				$files_vars_values{$curr_file}{$m1} = "";
			}
			undef ($files_descr{$curr_file});
		}
		# type 2 constant (.equ xxx yyy)
		elsif ( /^\s*\.equ?\s*(\w+)\s*,\s*([\w\,\.\+\-\s\*\/\\\'\"\!\@\#\$\%\^\&\\(\)\{\}\[\]\<\>\?\=\|]*)/io )
		{
			# Can't be in a structure yet!
			$files_vars{$curr_file}[++$#{$files_vars{$curr_file}}] = $1;
			$files_vars_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$files_vars_values{$curr_file}{$1} = $2;
			undef ($files_descr{$curr_file});
		}
		# traditional procedure beginning
		elsif ( /^\s*(\w+)(\s*:|\s+(proc|near|far){1,2})\s*($|;.*$)/io )
		{
			$files_funcs{$curr_file}[++$#{$files_funcs{$curr_file}}] = $1;
			$files_funcs_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$func_name = $1;
			# enabling this makes the script fail on procedures that don't have
			# an explicit end, because once such a procedure is encountered,
			# everything from that point is taken as a part of the procedure, because
			# $inside_func is reset to zero only when /endp/ was found
			#$inside_func = 1;
			undef ($files_descr{$curr_file});
		}
		# HLA syntax procedure
		elsif ( /^\s*proc(edure)?\s+(\w+)/io )
		{
			$files_funcs{$curr_file}[++$#{$files_funcs{$curr_file}}] = $2;
			$files_funcs_descr{$curr_file}{$2} = $files_descr{$curr_file};
			$func_name = $2;
			$inside_func = 1;
			undef ($files_descr{$curr_file});
		}
		# structures
		elsif ( /^\s*struc\s+(\w+)/io )
		{
			$files_structs{$curr_file}[++$#{$files_structs{$curr_file}}] = $1;
			$files_structs_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$structure = 1;
			$inside_struc = 1;
			$struc_name = $1;
			undef ($files_descr{$curr_file});
		}
		# macros
		elsif ( /^\s*((\%i?)?|\.)macro\s+(\w+)/io )
		{
			$files_macros{$curr_file}[++$#{$files_macros{$curr_file}}] = $3;
			$files_macros_descr{$curr_file}{$3} = $files_descr{$curr_file};
			undef ($files_descr{$curr_file});
		}
		elsif ( /^\s*(\w+)\s+macro/io )
		{
			$files_macros{$curr_file}[++$#{$files_macros{$curr_file}}] = $1;
			$files_macros_descr{$curr_file}{$1} = $files_descr{$curr_file};
			undef ($files_descr{$curr_file});
		}
		# structure instances in NASM
		elsif ( /^\s*(\w+):?\s+istruc\s+(\w+)/io )
		{
			$files_vars{$curr_file}[++$#{$files_vars{$curr_file}}] = $1;
			$files_vars_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$files_vars_types{$curr_file}{$1} = "istruc $2";
			undef ($files_descr{$curr_file});
		}
		# dup()
		elsif ( /^\s*(\w+)\:?\s+(d([bwudpfqt])\s+\w+\s*\(?\s*\bdup\b.*)/io )
		{
			$files_vars{$curr_file}[++$#{$files_vars{$curr_file}}] = $1;
			$files_vars_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$files_vars_types{$curr_file}{$1} = "$2";
			undef ($files_descr{$curr_file});
		}
		# MASM PROC
		elsif ( /^\s*(\w+):?\s+(proc)/io )
		{
			$files_funcs{$curr_file}[++$#{$files_funcs{$curr_file}}] = $1;
			$files_funcs_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$inside_func = 1;
			$func_name = $1;
			$function = 2;
			undef ($files_descr{$curr_file});
		}
		# MASM STRUCTURE
		elsif ( /^\s*(\w+):?\s+(struc)/io )
		{
			$files_structs{$curr_file}[++$#{$files_structs{$curr_file}}] = $1;
			$files_structs_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$structure = 1;
			$inside_struc = 1;
			$struc_name = $1;
			undef ($files_descr{$curr_file});
		}
		# some other type (like FASM structure instances)
		elsif ( /^\s*(\w+):?\s+(\w+)/io )
		{
			$files_vars{$curr_file}[++$#{$files_vars{$curr_file}}] = $1;
			$files_vars_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$files_vars_types{$curr_file}{$1} = "$2";
			undef ($files_descr{$curr_file});
		}
	} # END of block dealing with the first comment in the file

    my ($current_section, $last_func_finished, $last_func);

    $last_func_finished = 0;
    $current_section = "";

	while ( <$asm> )
	{
		undef ($current_variable);
		undef ($current_variable_descr);
		undef ($current_variable_value);
		undef ($current_type);
		# IDA-Pro Subroutine comment substitution (MASM PROC)
		if ($undoc && ( /^;.*(S\s+U\s+B)/o ))
		{
			$_ = ";; ";
		}
		# MASM Proc End
		if ( $inside_func && /^\s*(\w+):?\s+(endp)/io )
		{
			$inside_func = 0;
			$function = 0;
		}
		# Inside Function
		if ( $inside_func )
		{
			$current_type = "";
			if ( /;/o )
			{
				$current_variable_descr = $_;
				$current_variable_descr =~ s/.*;//o;
			}
			else
			{
				$current_variable_descr = "";
			}
			# Function call
            my ($m2);
			if ( /^\s*call(ab)?\s+(n?[zc]\s*,)?\s*([^\s]+)/i || /^\s*(j[rp])\s+(n?[zc]\s*,)?\s*([^\s]+)/i )
			{
				$m2 = $3;
			}
            if ( /^\s*(\.dw)\s+(\S+)\s+/i ) {
                $m2 = $2;
            }
            if ( defined $m2 && ! ( $m2 =~ /[+-]/ ) )
            {
                $current_variable = $m2;
                $current_variable_value = "";
                $current_type = "call";
            }

            # Ret statement
            if ( /^\s*reti?\s+(?!n?[zc])/io )
            {
                # Remove this when the disassembly is more complete
                $inside_func = 0;
            }

            if ( /^[^\.]\S+:/i )
            {
                # Consider the function ended
                $inside_func = 0;
            }
            elsif ( /^\s*(;.*)?$/i || /^\S+:/ || /^\s*\.\S+/i )
            {
                # Whitespace or other non-code thing, do nothing
            }
            elsif ( /^\s*reti?\s+/i || /^\s*j[rp]\s+(?!n?[zc]\s*,)/i || /^\s*rst_jumpTable\s+/i )
            {
                $last_func_finished = 1;
            }
            else
            {
                $last_func_finished = 0;
            }
            $last_func = $func_name;

			if ($current_type ne "")
			{
				$files_funcs_vars{$curr_file}{$func_name}[++$#{$files_funcs_vars{$curr_file}{$func_name}}] = $current_variable;
				$files_funcs_vars_values{$curr_file}{$func_name}{$current_variable} = $current_variable_value;
				$files_funcs_vars_descr{$curr_file}{$func_name}{$current_variable} = $current_variable_descr;
				$current_variable =~ s/^\.//o;
				$files_funcs_vars_types{$curr_file}{$func_name}{$current_variable} = $current_type;
				undef ($current_variable_descr);
			}
		}
        # Section start
        if ( $current_section eq "" && /^\s*\.SECTION\s+"(.*)"/i)
        {
            $current_section = $1;
            $files_sections{$curr_file}[++$#{$files_sections{$curr_file}}] = $current_section;

            $last_func = "";
        }
        # Section end
        if ( $current_section ne "" && /^\s*\.ENDS\s+/i )
        {
            $current_section = "";

            $last_func = "";
        }
		# Structure end
		if ( $inside_struc && ( /^\s*(endstruc|\})/io || /^\s*(\w+):?\s+(ends)/io ) )
		{
			$structure = 0;
			$inside_struc = 0;
		}
		# Inside Structure
		if ( $inside_struc )
		{
			$current_variable = '';
			$current_type = '';
			$current_variable_value = "";
			if ( /;/o )
			{
				$current_variable_descr = $_;
				$current_variable_descr =~ s/.*;//o;
			}
			else
			{
				$current_variable_descr = "";
			}
			#dup
			if ( /^\s*\.?(\w+)\:?\s+(d([bwudpfqt])\s+\w+\s*\(?\s*\bdup\b.*)/io )
			{
				$current_variable = $1;
				$current_variable_value = "";
				$current_type = "$2";
			}
			elsif ( /^\s*\.?(\w+)\s+(d([bwudpfqt]))/io )
			{
				$current_variable = $1;
				$current_variable_value = "";
				$current_type = "$2 ";
			}
			if ( $current_variable ne '' )
			{
				$files_structs_vars{$curr_file}{$struc_name}[++$#{$files_structs_vars{$curr_file}{$struc_name}}] = $current_variable;
				$files_structs_vars_values{$curr_file}{$struc_name}{$current_variable} = $current_variable_value;
				$files_structs_vars_descr{$curr_file}{$struc_name}{$current_variable} = $current_variable_descr;
				$current_variable =~ s/^\.//;
				$files_structs_vars_types{$curr_file}{$struc_name}{$current_variable} = $current_type;
				undef ($current_variable_descr);
			}
		}
		# Include files
		if ( /^\s*[\%\#]?include\s*['"]?([\\\/\w\.\-\!\~\(\)\$\@]+)['"]?/io )
		{
			$files_includes{$curr_file} .= "$1 ";
			if ( defined ($current_variable_descr) )
			{
				$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = $current_variable_descr;
				undef ($current_variable_descr);
			}
			else
			{
				if ( $undoc )
				{
					$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = '';
				}
				else
				{
					++$#{$files_includes_descr{$curr_file}};
				}
			}
			next;
		}
		## TODO @todo Add more elements for undocumented support here as needed.
		# MASM PROC (undoc)
 		if ( $undoc && /^\s*(\w+):?\s+(proc)/io )
		{
			$func_name = $1;
			$files_funcs{$curr_file}[++$#{$files_funcs{$curr_file}}] = $1;
			#$files_descr{$curr_file} = "";
			#$files_funcs_descr{$curr_file}{$1} = $files_descr{$curr_file};
			$inside_func = 1;
			$function = 2;
 		}
		# look for characters which start a doxygen comment
		next if ! ( /^\s*;;/o || /^\s*\/\*\*/o );

        $inside_func = 0;

		$type = 1 if /^\s*;;/o;
		$type = 2 if /^\s*\/\*\*/o;
		$current_variable_descr = $_;
		$current_variable_descr =~ s/^\s*;+//o if $type == 1;
		$current_variable_descr =~ s/^\s*\/?\*+//o if $type == 2;

		$have_descr = 0;

		# Put all up to the first non-comment line into the current description
		while ( <$asm> )
		{
			next if (/^\s*$/o && $idapro);
			# to leave when an empty line is encountered (IDA Pro)
			if (/^\s*$/o && ! $idapro) {$_ = ";;\n"; last;}

			if ( $type == 1 )
			{
				last if ( (! /^\s*;/o) || /^\s*;;\s*$/o && $have_descr );
			}
			elsif ( $type == 2 )
			{
				last if /^\s*\*\/\s*$/o;
			}

			# removing leading comment characters from the beginning of the line
			s/^\s*;+//o  if $type == 1;
			s/^\s*\/?\*+//o if $type == 2;

			$current_variable_descr .= $_ if $type != 0;
			$have_descr = 1;
		}
		if ( ! defined $_ )
		{
			close $asm;
			next FILES;
		}
		if ( (/^\s*;;\s*$/o || /^\s*\*\/\s*$/o) )
		{
			$_ = <$asm>;
			if ( ! defined $_ )
			{
				close $asm;
				next FILES;
			}
			if ( /^\s*[\%\#]?include\s*['"]?([\\\/\w\.\-\!\~\(\)\$\@]+)['"]?/io )
			{
				$files_includes{$curr_file} .= "$1 ";
				if ( defined ($current_variable_descr) )
				{
					$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}]
						= $current_variable_descr;
					undef ($current_variable_descr);
				}
				else
				{
					if ( $undoc )
					{
						$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = '';
					}
					else
					{
						++$#{$files_includes_descr{$curr_file}};
					}
				}
			}
		}
		if ( $inside_func )
		{
			$current_type = "";
			if ( /;/o )
			{
				$current_variable_descr = $_;
				$current_variable_descr =~ s/.*;//o;
			}
			else
			{
				$current_variable_descr = "";
			}
			# MASM Call (call sub_xxx, call word ptr es:[si+0Eh])
			if ( /\s*(call)\s+(.*)/io )
			{
				my ($m2);
				$m2 = $2;
				$m2 =~ s/(?:^\s+)|(?:\s+$)//go;
				$m2 =~ s/\s|\:|\]|\[|\+/_/go;
				$current_variable = $m2;
				$current_variable_value = "";
				$current_type = "call";
			}
			# x86 INT call, treat like call.
			elsif ( $idapro && /^\s*(int)\s*(\w+)/io )
			{
				$current_variable = "INT_".$2;
				$current_variable_value = "";
				$current_type = $1;
			}
			# type 3 constant (var_15 = byte ptr -15h, arg_0 = word ptr 2)
			elsif ( $idapro && /^\s*((arg|var)\w+)\s+\=\s+?([\w\s\-\+]+)[;]?/io )
			{
				# IDA-Pro when inside function arguments and variables.
				$current_variable = $1;
				$current_variable_value = $3;
				$current_type = $2;
			}
			if ($current_type ne "")
			{
				$files_funcs_vars{$curr_file}{$func_name}[++$#{$files_funcs_vars{$curr_file}{$func_name}}] = $current_variable;
				$files_funcs_vars_values{$curr_file}{$func_name}{$current_variable} = $current_variable_value;
				$files_funcs_vars_descr{$curr_file}{$func_name}{$current_variable} = $current_variable_descr;
				$current_variable =~ s/^\.//o;
				$files_funcs_vars_types{$curr_file}{$func_name}{$current_variable} = $current_type;
				undef ($current_variable_descr);
				next;
			}
		}
		# Include files
		if ( /^\s*[\%\#]?include\s*['"]?([\\\/\w\.\-\!\~\(\)\$\@]+)['"]?/io )
		{
			$files_includes{$curr_file} .= "$1 ";
			if ( defined ($current_variable_descr) )
			{
				$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = $current_variable_descr;
				undef ($current_variable_descr);
			}
			else
			{
				if ( $undoc )
				{
					$files_includes_descr{$curr_file}[++$#{$files_includes_descr{$curr_file}}] = '';
				}
				else
				{
					++$#{$files_includes_descr{$curr_file}};
				}
			}
			next;
		}
		# finding the name of the variable or function
		# variable/type 1 constant (xxx equ yyy)
		if ( /^\s*([\.\w]+)(:|\s+)\s*((times\s+\w+|(d|r|res)[bwudpfqt]\s|equ\s|=)+)\s*([\w\,\.\+\-\s\*\/\\\'\"\!\@\#\$\%\^\&\\(\)\{\}\[\]\<\>\?\=\|]*)/io )
		{
			my ($m1, $m3, $m5);
			$m1 = $1;
			$m3 = $3;
			$m5 = $6;
			$current_variable = $m1;
			$current_type = "$m3 $m5";
			$function = 0;
			my $value = $m5;
			if ( $m3 =~ /equ/io || $m3 =~ /=/o )
			{
				$current_variable_value = $value;
			}
			else
			{
				$current_variable_value = "";
			}
		}
		# type 2 constant (.equ xxx yyy)
		elsif ( /^\s*\.equ?\s*([\w\.]+)\s*,\s*([\w\,\.\+\-\s\*\/\\\'\"\!\@\#\$\%\^\&\\(\)\{\}\[\]\<\>\?\=\|]*)/io )
		{
			$current_variable = $1;
			$function = 0;
			$current_variable_value = $2;
		}
		# traditional procedure beginning
		elsif ( /^\s*(\w+)(\s*:|\s+(proc|near|far){1,2})\s*($|;.*$)/io )
		{
			$current_variable = $1;
			$function = 1;
			$current_variable_value = "";
			$func_name = $1;
			# enabling this makes the script fail on procedures that don't have
			# an explicit end, because once such a procedure is encountered,
			# everything from that point is taken as a part of the procedure, because
			# $inside_func is reset to zero only when /endp/ was found
			$inside_func = 1;
		}
		# HLA syntax procedure
		elsif ( /^\s*proc(edure)?\s*(\w+)/io )
		{
			$current_variable = $2;
			$function = 1;
			$current_variable_value = "";
			$func_name = $2;
			$inside_func = 1;
		}
		# structures
		elsif ( /^\s*struc\s+(\w+)/io )
		{
			$struc_name = $1;
			$function = 0;
			$structure = 1;
			$inside_struc = 0;
			$current_variable_value = "";
		}
		# macros
		elsif ( /^\s*((\%i?)?|\.)macro\s+(\w+)/io )
		{
			$current_variable = $3;
			$macro = 1;
			$current_variable_value = "";
		}
		elsif ( /^\s*(\w+)\s+macro/io )
		{
			$current_variable = $1;
			$macro = 1;
			$current_variable_value = "";
		}
		# structure instances in NASM
		elsif ( /^\s*(\w+):?\s+istruc\s+(\w+)/io )
		{
			$current_variable = $1;
			$current_variable_value = "";
			$current_type = "istruc $2";
		}
		# dup()
		elsif ( /^\s*(\w+)\:?\s+(d([bwudpfqt])\s+\w+\s*\(?\s*\bdup\b.*)/io )
		{
			$current_variable = $1;
			$current_variable_value = "";
			$current_type = "$2";
		}
		# MASM PROC
		elsif ( /^\s*(\w+):?\s+(proc)/io )
		{
			$func_name = $1;
			$function = 2;
			$inside_func = 1;
			$current_variable_value = "";
		}
		# MASM STRUCTURE
		elsif ( /^\s*(\w+):?\s+(struc)/io )
		{
			$struc_name = $1;
			$structure = 1;
			$inside_struc = 0;
			$current_variable_value = "";
		}
		# some other type (like FASM structure instances)
		elsif ( /^\s*(\w+):?\s+(\w+)/io )
		{
			$current_variable = $1;
			$current_variable_value = "";
			$current_type = "$2";
		}
		else
		{
			while ( /^\s*$/o )
			{
				$_ = <$asm>;
				if ( ! defined $_ )
				{
					close $asm;
					next FILES;
				}
			}
			if ( /^\s*$/o && $idapro )
			{
				$current_variable = " ";
				$current_variable_value = "";
				$current_type = " ";
			}
			elsif ( (! /^\s*end\s*$/io) || (! $idapro) )
			{
				s/[\r\n]*$//o;
				print "$0: $p: ".($asm->input_line_number).": '$_' ???\n";
			}
			next;
		}

		# {@value}
		$current_variable_descr =~ s/\{\s*(\@|\\)value\s*\}/$current_variable_value/ig;
		if ( $function )
		{
			$files_funcs{$curr_file}[++$#{$files_funcs{$curr_file}}] = $func_name;
            $files_funcs_descr{$curr_file}{$func_name} = "";
            if ( $current_section ne "")
            {
                my ($label_str);
                $label_str = $current_section;
                $label_str =~ s/ /_/g;
                $files_funcs_descr{$curr_file}{$func_name} .= "\\ingroup $label_str\n";
            }
			$files_funcs_descr{$curr_file}{$func_name} .= $current_variable_descr;
			if ( $function == 2 )
			{
				$files_funcs_vars{$curr_file}{$func_name} = ();
				$files_funcs_vars_descr{$curr_file}{$func_name} = ();
				$files_funcs_vars_values{$curr_file}{$func_name} = ();
				$inside_func = 1;
				$function = 0;
			}
            if (! $last_func_finished && defined $last_func && $last_func ne "" )
            {
                $files_funcs_vars{$curr_file}{$last_func}[++$#{$files_funcs_vars{$curr_file}{$last_func}}] = $func_name;
                $files_funcs_vars_values{$curr_file}{$last_func}{$func_name} = "";
                $files_funcs_vars_descr{$curr_file}{$last_func}{$func_name} = "";
#                 $func_name =~ s/^\.//o;
                $files_funcs_vars_types{$curr_file}{$last_func}{$func_name} = "call";
            }
            $last_func_finished = 0;
		}
		elsif ( $structure )
		{
			$files_structs{$curr_file}[++$#{$files_structs{$curr_file}}] = $struc_name;
			$files_structs_descr{$curr_file}{$struc_name} = $current_variable_descr;
			$files_structs_vars{$curr_file}{$struc_name} = ();
			$files_structs_vars_descr{$curr_file}{$struc_name} = ();
			$files_structs_vars_values{$curr_file}{$struc_name} = ();
			$inside_struc = 1;
			$structure = 0;
		}
		elsif ( $macro )
		{
			$files_macros{$curr_file}[++$#{$files_macros{$curr_file}}] = $current_variable;
			$files_macros_descr{$curr_file}{$current_variable} = $current_variable_descr;
			$macro = 0;
		}
		else
		{
			if ( $inside_struc )
			{
				$files_structs_vars{$curr_file}{$struc_name}[++$#{$files_structs_vars{$curr_file}{$struc_name}}] = $current_variable;
				$files_structs_vars_descr{$curr_file}{$struc_name}{$current_variable} = $current_variable_descr;
				$files_structs_vars_values{$curr_file}{$struc_name}{$current_variable} = $current_variable_value;
				$current_variable =~ s/^\.//o;
				$files_structs_vars_types{$curr_file}{$struc_name}{$current_variable} = $current_type;
			}
			elsif ( $inside_func )
			{
				$files_funcs_vars{$curr_file}{$func_name}[++$#{$files_funcs_vars{$curr_file}{$func_name}}] = $current_variable;
				$files_funcs_vars_descr{$curr_file}{$func_name}{$current_variable} = $current_variable_descr;
				$files_funcs_vars_values{$curr_file}{$func_name}{$current_variable} = $current_variable_value;
				$current_variable =~ s/^\.//o;
				$files_funcs_vars_types{$curr_file}{$func_name}{$current_variable} = $current_type;
			}
			else
			{
				$files_vars{$curr_file}[++$#{$files_vars{$curr_file}}] = $current_variable;
				$files_vars_descr{$curr_file}{$current_variable} = $current_variable_descr;
				$files_vars_values{$curr_file}{$current_variable} = $current_variable_value;
				$files_vars_types{$curr_file}{$current_variable} = $current_type;
			}
		}
	}

	close $asm;
	# Sort names
	if ( ! $nosort )
	{
		if ( $#{$files_vars{$curr_file}} >= 0 )
		{
			my @sorted = sort @{$files_vars{$curr_file}};
			$files_vars{$curr_file} = ();
			foreach (@sorted) { push @{$files_vars{$curr_file}}, $_; }
		}

		if ( $#{$files_structs{$curr_file}} >= 0 )
		{
			my @sorted = sort @{$files_structs{$curr_file}};
			$files_structs{$curr_file} = ();
			foreach (@sorted) { push @{$files_structs{$curr_file}}, $_; }
		}

		if ( $#{$files_funcs{$curr_file}} >= 0 )
		{
			my @sorted = sort @{$files_funcs{$curr_file}};
			$files_funcs{$curr_file} = ();
			foreach (@sorted) { push @{$files_funcs{$curr_file}}, $_; }
		}
	}
}

# =================== Writing output files =================
foreach my $p (@files)
{
	# Hash array key is the filename with dashes instead of dots.
	my $curr_file;
	$curr_file = (splitpath $p)[2];
	$curr_file =~ s/\./-/go;

	# don't do anything if file would be empty
	next if !defined $files_descr{$curr_file} && !defined $files_vars{$curr_file} && !defined $files_funcs{$curr_file};

	# Enhancement rlf, place output file in input file directory.
	my $curr_filepath='.';
	if ($odir)
	{
		$curr_filepath = (splitpath $p)[1] or $curr_filepath=".";
	}
	$p = (splitpath $p)[2];
	open (my $dox, ">:encoding($encoding)", catfile($curr_filepath,$curr_file.$testname.".c"))
		or die "$0: catfile($curr_filepath,$curr_file): $!\n";

	if ( defined $files_descr{$curr_file} )
	{
		print $dox "/**\n"
			." * \\file $curr_file.c\n"
			." * \\brief $p\n\n"
			.$files_descr{$curr_file}
			."\n */\n\n\n";
	}

    foreach (@{$files_sections{$curr_file}})
    {
        my ($label_str);
        $label_str = $_;
        $label_str =~ s/ /_/g;
        print $dox "/**\n"
            ." * \\defgroup $label_str $_\n"
            ." */\n\n";
    }

	if ( $files_includes{$curr_file} ne "" )
	{
		my @incl = split /\s+/o, $files_includes{$curr_file};
		my $i = 0;
		foreach (@incl)
		{
			print $dox "/**\n".
				$files_includes_descr{$curr_file}[$i].
				"*/\n"
				if (defined ($files_includes_descr{$curr_file}[$i]) && ($files_includes_descr{$curr_file}[$i] ne ""));
			print $dox "#include \"$_\"\n"
				if (defined $files_includes_descr{$curr_file}[$i]);
			$i++;
		}
		print $dox "\n";
	}

	# write C-style comments into the file for all documented functions
	# and variables/const. On each following line, write the variable/const
	# or a C-style function prototype.

	if ( defined($files_vars{$curr_file}) && (@{$files_vars{$curr_file}} > 0) )
	{
		foreach (@{$files_vars{$curr_file}})
		{
			# check if variable or constant
			if ( defined  ($files_vars_values{$curr_file}{$_}) &&
				$files_vars_values{$curr_file}{$_} ne "" )
			{
				# constant
				print $dox "/**\n"
					.$files_vars_descr{$curr_file}{$_}
					."\n */\n"
					."#define $_ $files_vars_values{$curr_file}{$_}\n"
					;
			}
			else
			{
				# variable
				print $dox "/**\n"
					.$files_vars_descr{$curr_file}{$_}
					."\n */\n"
					.do_variable($files_vars_types{$curr_file}{$_})."\n"
					;
			}
		}
	}
	# Process functions, and MASM calls within functions.
	if ( defined($files_funcs{$curr_file}) && (@{$files_funcs{$curr_file}} > 0) )
	{
		foreach my $func (@{$files_funcs{$curr_file}})
		{
			my ($func_proto, $func_return, $func_vars);
			$func_vars="";
			if ( defined ($files_funcs_descr{$curr_file}{$func}) &&
			             ($files_funcs_descr{$curr_file}{$func} ne ""))
			{
				my ($func_descr);
				$func_descr = $files_funcs_descr{$curr_file}{$func};
				print $dox "/**\n"
					.$func_descr
					."\n */\n";
				# Return type from doxygen comments.
				if ( $func_descr =~ /[\@\\]return[^\s]*\s+([\w\:\/\(\)\[\]\%\\@]+)/io )
				{
					$func_return = $1;
				}
				elsif ( $func_descr =~ /[\@\\]retval\s+(\w+)/io )
				{
					$func_return = $1;
				}
				else
				{
					$func_return = "void";
				}
				$func_proto="";
				# IDA Pro args and vars. arg's take precedence over params. Param matching handled by Doxygen.
				my $argcounter = 0;
				if ( defined ($files_funcs_vars_values{$curr_file}{$func}))
				{
					foreach my $arg (@{$files_funcs_vars{$curr_file}{$func}})
					{
						$argcounter++ if ( $arg =~ /arg/oi );
					}
				}
				if ( $argcounter && defined ($files_funcs_vars_values{$curr_file}{$func}))
				{
					my ($argvar);
					foreach my $arg (@{$files_funcs_vars{$curr_file}{$func}})
					{
						if ( defined  ($files_funcs_vars_values{$curr_file}{$func}{$arg}) &&
							($files_funcs_vars_values{$curr_file}{$func}{$arg} ne ""))
						{
							$argvar = $files_funcs_vars_values{$curr_file}{$func}{$arg};
							$argvar =~ s/[\r\n]//go;
							if ( $arg =~ /arg/oi )
							{
								$func_proto .= "\n\t/** ".$argvar." */\n\t";
								$argvar =~ s/^(\w+)//o;
								$func_proto .= $1;
								$func_proto .= " *" if ($argvar =~ /ptr/io);
								$func_proto .= $arg.",";
							}
							elsif ( $arg =~ /var/io )
							{
								$func_vars .= "\t/** ".$argvar;
								if (defined ($files_funcs_vars_descr{$curr_file}{$func}{$arg}))
								{
									my $descr = $files_funcs_vars_descr{$curr_file}{$func}{$arg};
									$descr =~ s/[\r\n]*//go;
									$func_vars .= ", $descr";
								}
								$func_vars .= " */\n\t";
								$argvar =~ s/^(\w+)//o;
								$func_vars .= $1;
								$func_vars .= " *" if ($argvar =~ /ptr/io);
								$func_vars .= $arg.";\n";
							}
						}
					}
				}
				# params from doxygen comments
				elsif ( $func_proto eq "" )
				{
					$func_descr = $files_funcs_descr{$curr_file}{$func};
					while ($func_descr =~ /[\@\\]param([^\s]*)\s+([\w\:\/\(\)\[\]\%\\@]+)/io)
					{
						my $type = $1;
						my $par = $2;
						$par =~ s/\://go;
						$par =~ s/^\\//go;
						if ( $type eq "" )
						{
							$func_proto .= "$par, ";
						}
						else
						{
							$type =~ s/[\[\]]//go;
							$func_proto .= "$type $par, ";
						}
						$func_descr =~ s/[\@\\]param//io;
					}
				}
				# Clean up subroutine argument list.
				if ( $func_proto eq "" )
				{
					$func_proto = "";
				}
				else
				{
					$func_proto =~ s/,\s*$//o;
				}
			}
			else
			{
				$func_return = "void";
				$func_proto = "void";
			}
			print $dox $func_return
				." "
				.$func
				." ("
				.$func_proto
				.")\n"
				."{\n";
			print $dox $func_vars if ( $func_vars ne "" );
			# function calls inside routine.
			if ( defined($files_funcs_vars{$curr_file}{$func})
				&& (@{$files_funcs_vars{$curr_file}{$func}} > 0) )
			{
				foreach my $var (@{$files_funcs_vars{$curr_file}{$func}})
				{
					next if ( ($files_funcs_vars_values{$curr_file}{$func}{$var} ne ""));
					my ($call_proto, $call_return, $call_descr, $call_undocdef);
					$call_undocdef="";
					$call_proto="";
					# doxygen bug, cannot handle (void) returns.
					$call_return="";

					# IDA Pro args and vars. arg's take precedence over params. Param matching handled by Doxygen.
					if ( defined ($files_funcs_vars_values{$curr_file}{$var}))
					{
						my ($argvar);
						foreach my $arg (@{$files_funcs_vars{$curr_file}{$var}})
						{
							if ( defined  ($files_funcs_vars_values{$curr_file}{$var}{$arg})
								&& ($files_funcs_vars_values{$curr_file}{$var}{$arg} ne ""))
							{
								$argvar = $files_funcs_vars_values{$curr_file}{$var}{$arg};
								$argvar =~ s/\n//go;
								if ( $arg =~ /arg/io )
								{
									$argvar =~ s/^(\w+)//o;
									$call_proto .= "(".$1;
									$call_proto .= " *" if ($argvar =~ /ptr/io);
									$call_proto .= ") ".$var."_".$arg.",";
								}
							}
						}
					}
					# Look up caller comments, and construct a parameter list, or void for undocumented/undefined
					if ( ($call_proto ne "") || (($call_proto eq "")
						&& defined ($files_funcs_descr{$curr_file}{$var})
						&& ($files_funcs_descr{$curr_file}{$var} ne "")))
					{
						$call_descr = $files_funcs_descr{$curr_file}{$var};
						while ($call_descr =~ /[\@\\]param[^\s]*\s+([\w\:\/\(\)\[\]\%]+)/io)
						{
							my $par = $1;
							$par =~ s/\://go;
							$call_proto .= "$par, ";
							$call_descr =~ s/[\@\\]param//io;
						}
						if ( $call_descr =~ /[\@\\]return[^\s]*\s+([\w\:\/\(\)\[\]\%]+)/io )
						{
							$call_return = $1;
						}
						elsif ( $call_descr =~ /[\@\\]retval\s+(\w+)/io )
						{
							$call_return = $1;
						}
						else
						{
							$call_return = "";
						}
					}
					else
					{
						my $exists_undoc = 0;
						foreach my $f (@{$files_funcs{$curr_file}})
						{
							if ( $f =~ /\b$var\b/i )
							{
								$exists_undoc = 1;
								last;
							}
						}
						if ($undoc && ! $exists_undoc)
						{
							$call_undocdef = "\\warning Call to undefined subroutine ".$var;
						}
						else
						{
							$call_undocdef = "\\note Call to undocumented subroutine ".$var;
						}
					}
					if ( $call_proto ne "" )
					{
						$call_proto =~ s/,\s*$//o;
					}
					# Subroutine calls, skip type 3 constants
					# local Subroutine call Comments
					if ( ($files_funcs_vars_descr{$curr_file}{$func}{$var} ne "") ||
						($call_undocdef ne ""))
					{
						print $dox "\t/**\n\t";
# 						print $dox $files_funcs_vars_descr{$curr_file}{$func}{$var}
# 							if  ($files_funcs_vars_descr{$curr_file}{$func}{$var} ne "");
						print $dox "\n\t"
							.$call_undocdef
							if  ($call_undocdef ne "");
						print $dox "\n\t*/\n";
					}
					# local call instruction
					print $dox "\t",$call_return." ";
					print $dox "= " if ( $call_return ne "" );
					print $dox $var
						." ("
						.$call_proto
						.");\n"
						."\n";
				}
			}
			# function return.
			if (( $func_return !~ /void/io ) &&
			    ( $func_return ne "" ))
			{
				print $dox "\treturn "
					.$func_return
					.";\n";
			}
			print $dox "}\n";
		}
	}
	if ( defined($files_structs{$curr_file}) && (@{$files_structs{$curr_file}} > 0) )
	{
		foreach my $stru (@{$files_structs{$curr_file}})
		{
			if ( defined $files_structs_descr{$curr_file}{$stru} )
			{
				print $dox "/**\n"
					.$files_structs_descr{$curr_file}{$stru}
					."\n */\n"
					."struct $stru \n{\n"
					;
			}
			if ( defined($files_structs_vars{$curr_file}{$stru})
				&& (@{$files_structs_vars{$curr_file}{$stru}} > 0) )
			{
				foreach (@{$files_structs_vars{$curr_file}{$stru}})
				{
					# check if call or constant
					if ( defined  ($files_structs_vars_values{$curr_file}{$stru}{$_})
						&& $files_structs_vars_values{$curr_file}{$stru}{$_} ne "" )
					{
						# constant
						print $dox "/**\n"
							.$files_structs_vars_descr{$curr_file}{$stru}{$_}
							."\n */\n"
							."#define $_ $files_structs_vars_values{$curr_file}{$stru}{$_}\n"
							;
					}
					else
					{
						# variable
						print $dox "/**\n"
							.$files_structs_vars_descr{$curr_file}{$stru}{$_}
							."\n */\n"
							;
						s/^\.//;
						print $dox "\t".
							do_variable ($files_structs_vars_types{$curr_file}{$stru}{$_}).
							"\n"
							;
					}
				}
			}
			print $dox "\n};\n";
		}
	}

	if ( defined($files_macros{$curr_file}) && (@{$files_macros{$curr_file}} > 0) )
	{
		foreach (@{$files_macros{$curr_file}})
		{
			my $macro_proto = "";
#			if ( $files_macros_descr{$curr_file}{$_} =~ /[\@\\]param[^\s]*\s+([\%\w]+):([\%\w]+)/io )
#			{
#				$files_macros_descr{$curr_file}{$_} =~ s/[\@\\]param[^\s]*\s+([\%\w]+):([\%\w]+)/\@param $1$2/gi;
#			}
			if ( $files_macros_descr{$curr_file}{$_} =~ /[\@\\]param[^\s]*\s+\%(\d+)/io )
			{
				$files_macros_descr{$curr_file}{$_} =~ s/[\@\\]param[^\s]*\s+\%(\d+)/\@param par$1/gi;
			}
			print $dox "/**\n"
				.$files_macros_descr{$curr_file}{$_}
				."\n */\n"
				."#define $_("
				;
			while ($files_macros_descr{$curr_file}{$_} =~ /[\@\\]param[^\s]*\s+([\w\:\/\(\)\[\]\%]+)/io)
			{
				my $mak_par = $1;
				$mak_par =~ s/\://go;
				$macro_proto .= "$mak_par, ";
				$files_macros_descr{$curr_file}{$_} =~ s/[\@\\]param//io;
			}
			$macro_proto =~ s/,\s*$//o;
			print $dox "$macro_proto) /* $files_orig{$curr_file}, $_ */\n";
		}
	}

	# check how many {'s were left open by the file description and close them at the end
	if ( defined $files_descr{$curr_file} )
	{
		my $i = 0;
		while ( $files_descr{$curr_file} =~ /{/o ) {$files_descr{$curr_file} =~ s/{//; $i++;}
		while ( $files_descr{$curr_file} =~ /}/o ) {$files_descr{$curr_file} =~ s/}//; $i--;}
		if ( $i > 0 )
		{
			print $dox "/**\n";
			while ( $i > 0 )
			{
				print $dox "\\} ";
				$i--;
			}
			print $dox "\n*/\n";
		}
	}

	close $dox;
}

exit 0;

# ============================ print_help ===================================

sub print_help
{
	print	"Asm4doxy - a program for converting specially-commented assembly\n".
		"language files into something Doxygen can understand.\n".
		"See Original http://rudy.mif.pg.gda.pl/~bogdro/inne\n".
		"See Enhanced http://www.solengtech.com/downloads\n".
		"Syntax: $0 [options] files\n\n".
		"Options:\n".
		"-encoding <name>\t\tSource files' character encoding\n".
		"-h|--help|-help|-?\t\tShows the help screen\n".
		"-ida|-idapro\t\t\tEnable IDA Pro mode\n".
		"-L|--license\t\t\tShows the license for this program\n".
		"-od|-odir|-output-directory\tSet output directory to input directory\n".
		"-ud|-undoc|-undocumented\tProcess undocumented procedures\n".
		"-ns|-nosort|-no-sort\t\tDo not alphabetically sort procedures, structures and data\n\n".
		"Documentation comments should start with ';;' or '/**' and\n".
		"end with ';;' or '*/'.\n\n".
		"Examples:\n\n".
		";;\n".
		"; This procedure reads data.\n".
		"; \@param CX - number of bytes\n".
		"; \@return DI - address of data\n".
		";;\n".
		"procedure01:\n".
		"\t...\n".
		"\tret\n"
		;
}

# ============================= do_variable ===================================

sub do_variable
{
	my $var;
	my $type = shift;
	$var = "$_;";
	# parse the variable type here
	if ( defined ($type) )
	{
		# times + resX/rX:
		if ( $type =~ /\btimes\s+(\w+)\s+(r|res)([bwudpfqt])\s+(\w+)/io )
		{
			my $type = $3;
			my $number1 = $1;
			my $number2 = $4;
			if ( $number1 =~ /\d+h/io )
			{
				$number1 = "0x$number1";
				$number1 =~ s/h$//io;
			}
			elsif ( $number1 =~ /\d+[qo]/io )
			{
				$number1 = "0$number1";
				$number1 =~ s/[qo]$//io;
			}
			if ( $number2 =~ /\d+h/io )
			{
				$number2 = "0x$number2";
				$number2 =~ s/h$//io;
			}
			elsif ( $number2 =~ /\d+[qo]/io )
			{
				$number2 = "0$number2";
				$number2 =~ s/[qo]$//io;
			}
			if ( $type eq "b" )
			{
				$var = "char $_ [$number1*$number2];";
			}
			elsif ( $type eq "w" || $type eq "u" )
			{
				$var = "short $_ [$number1*$number2];";
			}
			elsif ( $type eq "d" )
			{
				$var = "Dword $_ [$number1*$number2]; /* 32-bit integer or float or pointer */";
			}
			elsif ( $type eq "p" || $type eq "f" )
			{
				$var = "far void * $_ [$number1*$number2]; /* 48-bit number */";
			}
			elsif ( $type eq "q" )
			{
				$var = "Qword $_ [$number1*$number2]; /* 64-bit integer or double or pointer */";
			}
			else #if ( $type eq "t" )
			{
				$var = "long double $_ [$number1*$number2]; /* 80-bit long double */";
			}
		}
		# times + dX
		elsif ( $type =~ /\btimes\s+(\w+)\s+d([bwudpfqt])/io )
		{
			my $type = $2;
			my $number = $1;
			if ( $number =~ /\d+h/io )
			{
				$number = "0x$number";
				$number =~ s/h$//io;
			}
			elsif ( $number =~ /\d+[qo]/io )
			{
				$number = "0$number";
				$number =~ s/[qo]$//io;
			}
			if ( $type eq "b" )
			{
				$var = "char $_ [$number];";
			}
			elsif ( $type eq "w" || $type eq "u" )
			{
				$var = "short $_ [$number];";
			}
			elsif ( $type eq "d" )
			{
				$var = "Dword $_ [$number]; /* 32-bit integer or float or pointer */";
			}
			elsif ( $type eq "p" || $type eq "f" )
			{
				$var = "far void * $_ [$number]; /* 48-bit number */";
			}
			elsif ( $type eq "q" )
			{
				$var = "Qword $_ [$number]; /* 64-bit integer or double or pointer */";
			}
			else #if ( $type eq "t" )
			{
				$var = "long double $_ [$number]; /* 80-bit long double */";
			}
		}
		# dup():
		elsif  ( $type =~ /d([bwudpfqt])\s+\w+\s*\(?\s*\bdup\b/io )
		{
			my $dim = 0;
			my @dims = ();
			my $var_type = $1;
			while ( $type =~ /(\w+)\s*\(?\s*\bdup\b/io )
			{
				$dim++;
				push @dims, $1;
				$type =~ s/(\w+)\s*\(?\s*\bdup\b//io;
			}
			if ( $var_type eq "b" )
			{
				$var = "char $_ ";
			}
			elsif ( $var_type eq "w" || $var_type eq "u" )
			{
				$var = "short $_ ";
			}
			elsif ( $var_type eq "d" )
			{
				$var = "Dword $_ ";
			}
			elsif ( $var_type eq "p" || $var_type eq "f" )
			{
				$var = "far void * $_ ";
			}
			elsif ( $var_type eq "q" )
			{
				$var = "Qword $_ ";
			}
			else #if ( $var_type eq "t" )
			{
				$var = "long double $_ ";
			}
			foreach my $i (@dims)
			{
				$var .= "[$i]";
			}
			$var .= ";";
		}
		# istruc:
		elsif  ( $type =~ /\bistruc\s+(\w+)/io )
		{
			$var = "struct $1 $_;"
		}
		# resX / rX
		elsif  ( $type =~ /\b(res|r)([bwudpfqt])\s+(\w+)/io )
		{
			my $type = $2;
			my $number = $3;
			if ( $number =~ /\d+h/io )
			{
				$number = "0x$number";
				$number =~ s/h$//io;
			}
			elsif ( $number =~ /\d+[qo]/io )
			{
				$number = "0$number";
				$number =~ s/[qo]$//io;
			}
			if ( $type eq "b" )
			{
				$var = "char $_ [$number];";
			}
			elsif ( $type eq "w" || $type eq "u" )
			{
				$var = "short $_ [$number];";
			}
			elsif ( $type eq "d" )
			{
				$var = "Dword $_ [$number]; /* 32-bit integer or float or pointer */";
			}
			elsif ( $type eq "p" || $type eq "f" )
			{
				$var = "far void * $_ [$number]; /* 48-bit number */";
			}
			elsif ( $type eq "q" )
			{
				$var = "Qword $_ [$number]; /* 64-bit integer or double or pointer */";
			}
			else #if ( $type eq "t" )
			{
				$var = "long double $_ [$number]; /* 80-bit long double */";
			}
		}
		# traditional d[bwudpfqt]
		elsif  ( $type =~ /\bd([bwudpfqt])\s+(.*)$/io )
		{
			my $type;
			my $remainder;
			$type = $1;
			$remainder = $2;
			if ( $type eq "b" )
			{
				if ( $remainder =~ /["',]/o )
				{
					$var = "char $_ [];";
				}
				else
				{
					$var = "char $_;";
				}
			}
			elsif ( $type eq "w" || $type eq "u" )
			{
				if ( $remainder =~ /["',]/o )
				{
					$var = "short $_ [];";
				}
				else
				{
					$var = "short $_;";
				}
			}
			elsif ( $type eq "d" )
			{
				if ( $remainder =~ /["',]/o )
				{
					$var = "Dword $_ []; /* 32-bit integer or float or pointer */";
				}
				else
				{
					$var = "Dword $_; /* 32-bit integer or float or pointer */";
				}
			}
			elsif ( $type eq "p" || $type eq "f" )
			{
				if ( $remainder =~ /["',]/o )
				{
					$var = "far void * $_ []; /* 48-bit number */";
				}
				else
				{
					$var = "far void * $_; /* 48-bit number */";
				}
			}
			elsif ( $type eq "q" )
			{
				if ( $remainder =~ /["',]/o )
				{
					$var = "Qword $_ []; /* 64-bit integer or double or pointer */";
				}
				else
				{
					$var = "Qword $_; /* 64-bit integer or double or pointer */";
				}
			}
			else #if ( $type eq "t" )
			{
				if ( $remainder =~ /["',]/o )
				{
					$var = "long double $_ []; /* 80-bit long double */";
				}
				else
				{
					$var = "long double $_; /* 80-bit long double */";
				}
			}
		}
		# other type given:
		else
		{
			$type =~ /(\w+)/io;
			$var = "$1 $_;"
		}
	}
	return $var;
}

END { close(STDOUT) || die "$0: Can't close stdout: $!"; }
