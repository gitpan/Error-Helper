package Error::Helper;

use warnings;
use strict;

=head1 NAME

Error::Helper - Provides some easy error related methods.

=head1 VERSION

Version 0.0.0

=cut

our $VERSION = '0.0.0';


=head1 SYNOPSIS

Below is a example module using this.

    package Foo;
    
    use warnings;
    use strict;
    use base 'Error::Helper';
    
    sub new{
		my $arg=$_[1];

		my $self = {
			perror=>undef,
			error=>undef,
			errorString=>"",
		};
        bless $self;

		#error if $arg is set to "test"
        if( $arg eq "test" ){
			$self->{perror}=1;
			$self->{error}=2;
			$self->{errorString}='A value of "test" has been set';
			$self->warn;
			return $self;
        }  

		return undef;
    }

    sub foo{
		my $self=$_[0];
		my $a=$_[1];

		if( ! $self->errorblank ){
			return undef;
        }

		if( !defined( $a ) ){
			$self->{error}=1;
			$self->{errorString}='No value specified';
			$self->warn;
			return undef;
		}

		return 1;
    }

Below is a example script.

    use Foo;
    
    my $foo=Foo->new( $ARGV[0] );
    if( $foo->error ){
	    warn('error:'.$foo->error.': '.$foo->errorString);
        exit $foo->error;
    }
    
    $foo->foo($ARGV[1]);
    if( $foo->error ){
	    warn('error:'.$foo->error.': '.$foo->errorString);
        exit $foo->error;
    }

There are three required variables in the blessed hash.

    $self->{error}

This contains the current error code.

    $self->{errorString}

This contains a description of the current error.

    $self->{perror}

This is set to true is a permanent error is present. If note,
it needs set to false.

=head1 METHODS

=head2 error

Returns the current error code and true if there is an error.

If there is no error, undef is returned.

    if($self->error){
                warn('error: '.$foo->error.":".$foo->errorString);
    }

=cut

sub error{
    return $_[0]->{error};
}

=head2 errorblank

This blanks the error storage and is only meant for internal usage.

It does the following.

If $self->{perror} is set, it will not be able to blank any current
errors.

        $self->{error}=undef;
        $self->{errorString}="";

=cut

sub errorblank{
        my $self=$_[0];

		if ($self->{perror}) {
			my ($package, $filename, $line)=caller;
			
			#get the calling sub
			my @called=caller( 1 );
			my $subroutine=$called[3];
			$subroutine=~s/.*\:\://g;
			
			$package =~ s/\:\:/\-/g;

			print STDERR $package.' '.$subroutine.': Unable to blank, as a permanent error is set. '.
				'error="'.$self->error.'" errorString="'.$self->errorString.'"';

			return undef;
		}

        $self->{error}=undef;
        $self->{errorString}="";

        return 1;
};

=head2 errorString

Returns the error string if there is one. If there is not,
it will return ''.

    if($self->error){
        warn('error: '.$self->error.":".$self->errorString);
    }

=cut

sub errorString{
    return $_[0]->{errorString};
}

=head2 warn

Throws a warn like error message based

    $self->warn;

=cut

sub warn{
	my $self=$_[0];
	
	my ($package, $filename, $line)=caller;

	#get the calling sub
	my @called=caller( 1 );
	my $subroutine=$called[3];
	$subroutine=~s/.*\:\://g;

	$package =~ s/\:\:/\-/g;

	print STDERR $package.' '.$subroutine.':'.$self->error.
		': '.$self->errorString.' at '.$filename.' line '.$line."\n";
}

=head1 AUTHOR

Zane C. Bowers-Hadley, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-error-helper at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Error-Helper>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Error::Helper


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Error-Helper>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Error-Helper>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Error-Helper>

=item * Search CPAN

L<http://search.cpan.org/dist/Error-Helper/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 Zane C. Bowers-Hadley.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Error::Helper
