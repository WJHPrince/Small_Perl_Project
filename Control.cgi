#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use lib('/var/www/cgi-bin/Controller/');
use Control;

my $o_cgi = CGI->new();
my $s_name = $o_cgi->param('firstname');
my $s_storage = $o_cgi->param('lastname');
my $s_op = $o_cgi->param('operatingsystem');
my $s_table = $o_cgi->param('database');
my $s_hd_size = $o_cgi->param('disksize');
my $s_method = $o_cgi->param('method');

if (Control::check($s_name) == 1) {
    Control::chose_page($s_method, $s_table, $s_name, $s_storage, $s_op, $s_hd_size);
}
