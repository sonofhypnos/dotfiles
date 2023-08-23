# paste selection from clipboard
sub paste {
     my ($self) = @_;
     my $content = `/usr/bin/xclip -loop 1 -out -selection clipboard` ;
     $self->tt_write ($content);
}

# copy text to clipbard on selection
sub on_sel_grab {
     my $query = $_[0]->selection;
     open (my $pipe, '| /usr/bin/xclip -in -selection clipboard') or die;
     print $pipe $query;
     close $pipe;
}
