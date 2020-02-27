#!/usr/bin/perl -s

if($h or $help or not @ARGV){
    print "
Create Conflict-of-interest list from publications/presentations (co-authors)
The text file should have one line per publication/preentation in the format
author1, author2, author3, YEAR, other information. This file may be created
with 

  pub_tex2txt.pl [-year=YEAR] publication.tex > publication.txt


Usage:
  pub_txt2coi.pl [-year=YEAR] [-first=NAME] publication.txt > publication.coi

  -year=YEAR     - only publications written in YEAR or newer are included
                   default is to include all publications/presentations

  -first=NAME    - only first author to co-author conflicts are listed for author NAME
                   default is to list all co-author to co-author conflicts

";
    exit 0;
}

while(<>){
    # Find year
    /, (\d\d\d\d)\b/;
    $yr = $1;
    $authors = $`;

    next if not $yr;
    next if ($year and $yr < $year);

    $authors =~ s/[, ]+and +/, /;
    $authors =~ s/,(( [A-Z]\.)+,)/$1/g;
    $authors =~ s/,(( [A-Z]\.)+$)/$1/;

    @authors = split(/[;,]/, $authors);

    if($first){
	# Keep first author only if the first author is not myself
	@authors = ($authors[0]) if $authors[0] !~ /$first/;
    }

    foreach $author (@authors){
	# Put into $_ for easy processing
	$_ = $author;
	# Remove leading space
	s/^ +//;
	# Put space between initials
	s/\.([A-Z])/\. $1/g;
	# Swap last name and initials
	if(/(.*\.) ([\w][\w ]+)/){
	    $_ = "$2 $1";
	    # Keep first initial only
	    s/([A-Z]\.).*/$1/;
	}

	if(/^\w\.?\s*$/ or /^$debug$/){
	    warn "ERROR: line=$_\n";
	    warn "author=$author\n";
	    warn "authors=$authors\n";
	}

	# Store author into list
	$list{$_}++;
    }
}

print "List of co-authors for year=$year:\n";
foreach $author (sort keys %list){
    print "$author\n";
}

exit 0;
