#!env perl

use v5.20;

use feature qw(signatures say);
no warnings qw(experimental::signatures);

use Test::More;
use HTTP::Tiny;

run(@ARGV) unless caller();

sub run(@files) {
	
	#note explain \@files;

	open( my $fh, '<', $files[0] ) or die $!;

	my $stats = {};

	foreach my $line ( <$fh> ) {
		chomp $line;
		$line =~ s{,}{}g;
		my ( $commit, $email, $name ) = split( /\|/, $line );

		#note $line, " => ", "$email - $name";

		$stats->{$email} //= { name => $name, commits => 0, sha1 => $commit };
		$stats->{$email}->{commits}++;
	}

	say "Name, Email, Commits, GitHub";
	foreach my $email ( sort keys %$stats ) {
		
		my $github = get_github_account_for( $stats->{$email}->{sha1} );

		say $stats->{$email}->{name},  ", $email, ", $stats->{$email}->{commits}, ", ", $github;

	}

}


sub get_github_account_for($sha1) {
	
	die unless defined $sha1;

	my $github;

	my $r = HTTP::Tiny->new->get('https://github.com/Perl/perl5/commit/'.$sha1);

	return unless $r->{success};

	my $content = $r->{content} // '';

	if ( $content =~ m{aria-label="View all commits by[^<]+">(.+)</a>} ) {
		$github = $1;
	}

	return $github;
}

__END__

git log --no-merges --pretty=format:"%h|%ae|%an" --since="2017-01-01" > 2years

https://github.com/Perl/perl5/commit/74345e5b

<a href="/Perl/perl5/commits?author=bingos" class="commit-author tooltipped tooltipped-s user-mention" 
aria-label="View all commits by bingos">bingos</a> 

