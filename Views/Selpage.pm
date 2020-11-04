#!/usr/bin/perl
package Selpage;
use strict;
use warnings;
use lib('/var/www/cgi-bin/Models');
use Sqlcontrol;
use Template;
use Cwd;


sub show_success {
    my $o_success_page = Template->new({INCLUDE_PATH =>'/var/www/cgi-bin/Views/Templates/', EVAL_PERL => 1,});
    my $s_page = $o_success_page->process('Successpage.html');
    chop $s_page;
    return $s_page;
}

sub show_err {
    my $o_err_psge = Template->new({INCLUDE_PATH => '/var/www/cgi-bin/Views/Templates/', EVAL_PERL => 1,});
    my $s_page = $o_err_psge->process('Errpage.html');
    chop $s_page;
    return $s_page;
}

sub show_table {
    my ($method, $db, $name, $Storage, $OP, $size) = @_;
    my $o_db = Sqlcontrol->new();
    my $s_command = Sqlcontrol::command($method, $db, $name, $Storage, $OP, $size);
    my $o_table_page = Template->new({INCLUDE_PATH => '/var/www/cgi-bin/Views/Templates/', EVAL_PERL => 1,});
    my %h_data = (
        headers  => $o_db->get_row_names($s_command, $db),
        rows     => $o_db->get_row_values($s_command, $db),
    );
    my $s_page = $o_table_page->process('Tablepage.tt', \%h_data);
    $o_db->close();
    chop $s_page;
    return $s_page;
}

sub print_head {
    # PLEASE use this function before using show_*.
    return "Content-type: text/html\n\n";
}

sub non_sel_status {
    my ($method, $db, $name, $Storage, $OP, $size) = @_;
    my $o_db = Sqlcontrol->new();
    my $s_command = Sqlcontrol::command($method, $db, $name, $Storage, $OP, $size);
    my $d_status = $o_db->dooo($s_command);
    $o_db->close;
    return $d_status;
}

1;
