package Control;
use strict;
use warnings;
use lib('/var/www/cgi-bin/Views/');
use Selpage;

sub check {
    my $s_name = shift @_;
    unless (defined $s_name and $s_name =~ /^[a-zA-Z]\w/) {
        # check whether the input of disk size is digits
        print Selpage::print_head();
        print Selpage::show_err();
        return -1;
    }
    return 1;
}

sub chose_page{
    my ($s_method, $s_db, $s_name, $s_storage, $s_op, $s_hd_size) = @_;
    if ($s_method eq 'SELECT') {
        # run select page
        # db_table is mast, at least 0 param.
        print Selpage::print_head();
        print Selpage::show_table($s_method, $s_db, $s_name, $s_storage, $s_op, $s_hd_size);
    }
    if ($s_method ne 'SELECT') {
        #rum DELETE page
        #at least 1 param
        my $d_stat = Selpage::non_sel_status($s_method, $s_db, $s_name, $s_storage, $s_op, $s_hd_size);
        if ($d_stat == 1) {
            print Selpage::print_head;
            print Selpage::show_success;
        } else {
            print Selpage::print_head;
            print Selpage::show_err;
        }
    }

}





1;