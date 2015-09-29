package MT::Plugin::MIME;
use strict;
use warnings;

use MT;
use MT::Mail;

use Class::Method::Modifiers;

my $key = 'MIME::build_mail';

sub init_app {
    around 'MT::build_email' => sub {
        my $orig = shift;

        require MT::Template;
        my $context = \&MT::Template::context;
        local *MT::Template::context = sub {
            MT->request( $key, $_[0] );
            $context->(@_);
        };

        $orig->(@_);
    };
}

sub mail_filter {
    my ( $cb, %args ) = @_;
    my $tmpl = MT->request($key) or return 1;
    MT->request( $key, undef );
    $args{headers}{'Content-Type'} =~ s!plain!html! if $tmpl->html_mail;
    1;
}

1;

