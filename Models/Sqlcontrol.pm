package Sqlcontrol;
use strict;
use warnings;
use DBI;
use Digest::MD5 qw/md5_hex/;

# control database and generate SQL commands, return SQL commands and executed results.
my $db_user = '';
my $db_pass = '';

sub new {
	my $class = shift @_;
	my $self = {
		dbh => DBI->connect('dbi:Pg:dbname=testdb', $db_user, $db_pass),
	};
	return bless $self=>__PACKAGE__;
}

sub dooo {
    my ($self, $s_command) = @_;
    if (eval {$self->{dbh}->do($s_command)}) { return 1;} else {return -1};
}

sub close {
	my ($self) = @_;
	return $self->{dbh}->disconnect();
}

sub get_row_names {
    # ok
	my ($self, $commend, $s_table) = @_;
    my $sth = $self->{dbh}->prepare($commend); # get execute results or return with error
    if (eval {$sth->execute()}) {
        my $d_i = 0;
        my @a_column_names;
        while (my $s_name = $sth->{NAME}->[$d_i]) {
            @a_column_names = (@a_column_names, $s_name);
            $d_i++;
        }
        if ($s_table eq 'vms') {
            @a_column_names = (@a_column_names, 'MD5');
        }
        return(\@a_column_names); #return an array refer of column names.
    } else {
        return -1;
    }

}

sub get_row_values {
    # not ok
    # return a 2-d array table in reference format, first layer contains an array of refers.
    my ($self, $commend, $s_db) = @_;
    my $sth = $self->{dbh}->prepare($commend);
    $sth->execute() or return 'ERROR'; # get execute results or return error
    if ($s_db eq 'storage') {
        return $sth->fetchall_arrayref();
    } else {
        my $arr = $sth->fetchall_arrayref();
        foreach my $row (@$arr) {
            my $s_name = $row->[1];
            my $s_op = $row->[2];
            my $s_storage = $row->[4];
            $row->[5] = md5_hex($s_name, $s_op, $s_storage);
        }
        return $arr;
    }

}

sub command { # ok
    # put params together to form a SQL command.
	my ($method, $db, $name, $Storage, $OP, $size) = @_;

	if ($method eq 'SELECT') { #ok
        my $param = &paramsel($db, $name, $Storage, $OP, $size);
        my $comm = "SELECT * FROM $db";
        if (keys %$param) {
            my @pa;
            foreach my $key (keys %$param) {
                push(@pa, "$key='$param->{$key}'") if defined($param->{$key});
            }
            $comm = $comm . ' WHERE ';
            return($comm.join(' AND ', @pa).';');
        } else {
            return "$comm".';';
        }
	}
	if ($method eq 'DELETE') { #ok
		my $param = &paramsel($db, $name, $Storage, $OP, $size);
		my @pa = ();
		foreach my $key (keys %$param) {
			push(@pa, "$key='$param->{$key}'") if defined($param->{$key});
		}
		my $comm = "DELETE FROM $db WHERE ";
		return($comm.join(' AND ', @pa).';');
	}
	if ($method eq 'INSERT') { #ok
		my $param = &paramsel($db, $name, $Storage, $OP, $size, );
		my @a_key_pa;
        my @a_val_pa;
		foreach my $key (keys %$param) {
            push @a_key_pa,"$key";
            push @a_val_pa,"$param->{$key}";
        }
        my $comm = "INSERT INTO $db\(";
        my $s_keys = join(', ',@a_key_pa);
        my $s_vals = join("', '",@a_val_pa);
        $comm = $comm.$s_keys.')'; # insert column names
        $comm = $comm." VALUES ('".$s_vals."')"; # insert suitable values
        return($comm.';');
	}
    if ($method eq 'UPDATE') { # ok
        my $param = &paramsel($db, $name, $Storage, $OP, $size);
        delete($param->{name}) if defined($param->{name});
        my @a_key_pa;
        foreach my $key (keys %$param) {
            push @a_key_pa, "$key";
        }
        my $comm = "UPDATE $db SET";
        foreach my $tmp (@a_key_pa) {
            $comm = $comm." $tmp='$param->{$tmp}'";
        }
        $comm = $comm." WHERE name='$name';";
        return $comm;
    }
}

sub paramsel {
	# select useful params for certain database
    my ($db, $name, $Storage, $OP, $size) = @_;
    my $hash = {
        name            => $name,
        storage         => $Storage,
        operatingsystem => $OP,
        capacity            => $size,
    };
	if ($db eq 'vms') {
        my $tmp_hash = {};
        foreach my $key (('name', 'storage', 'operatingsystem')) {
            $tmp_hash->{$key} = $hash->{$key} if (defined($hash->{$key}) and $hash->{$key} ne '');
        }
		return $tmp_hash;
	}
	if ($db eq 'storage') {
        my $tmp_hash = {};
        foreach my $key (('name', 'capacity')) {
            $tmp_hash->{$key} = $hash->{$key} if ($hash->{$key} ne '');
        }
		return $tmp_hash;
	}
}

1;
