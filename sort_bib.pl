#!/usr/bin/perl

# Purpose: Sort items in a bib file alphabetically
# Usage: sort_bib.pl UNSORTED.bib > SORTED.bib

use strict;
my $text = join('',<>);
my @text = 
    split(/\n *\@(article.*|book.*|incollection.*|techreport.*|unpublished.*)/i,
	  $text);
my $intro= shift @text;
my %text = @text;
my @keys = keys %text;
my @sorted = 
    sort {(my $c=lc $a)=~s/.*\{//;(my $d=lc $b)=~s/.*\{//; $c cmp $d} @keys;

print $intro;
my $key;
foreach $key (@sorted){
    my $cite = $key;
    $cite =~ s/(.*\{)//;
    my $pub = lc($1);
    print "\n\@",$pub,$cite,$text{$key};
}

#print "text=$text";
#print "intro=$intro\n";
#print "Keys (",$#keys+1,"):\n";
#print "Keys:\n";
#print join("\n------------\n", @keys);
#print "\nSorted keys (",$#sorted+1,"):\n";
#print join("\n------------\n", @sorted),"\n";

