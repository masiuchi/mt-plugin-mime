package MT::Plugin::MIME::CMS;
use strict;
use warnings;

sub tmpl_src_edit_tmpl {
    my ( $cb, $app, $tmpl ) = @_;

    return unless _load_email_tmpl($app);

    my $insert = quotemeta <<'__MTML__';
    </div>
  </div>
__MTML__

    my $mtml = <<'__MTML__';
  <__trans_section component="MIME">
  <mtapp:setting
    id="html_mail"
    label_class="top-level">
    <input type="checkbox" id="html_mail" name="html_mail" value="1" <mt:if name="html_mail">checked="checked"</mt:if> />
    <label for="html_mail"><__trans phrase="Send as HTML mail"></label>
  </mtapp:setting>
  </__trans_section>
__MTML__

    $$tmpl =~ s/($insert)/$mtml$1/;
}

sub tmpl_param_edit_tmpl {
    my ( $cb, $app, $param, $tmpl ) = @_;
    my $template = _load_email_tmpl($app) or return;
    $param->{html_mail} = $template->html_mail;
}

sub pre_save_tmpl {
    my ( $cb, $app, $obj, $orig ) = @_;
    return 1 if $obj->type ne 'email';
    $obj->html_mail( $app->param('html_mail') ? 1 : undef );
    1;
}

sub _load_email_tmpl {
    my ($app) = @_;
    my $id = $app->param('id') or return;
    require MT::Template;
    my $template = MT::Template->load($id) or return;
    $template->type eq 'email' ? $template : undef;
}

1;

