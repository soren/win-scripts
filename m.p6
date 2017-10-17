our %BOOKMARKS = (
	1 => ("HOME"       => ("%*ENV<HOME>" => 0)),
	2 => ("Downloads"  => ("%*ENV<HOME>/Downloads" => 0)),
	3 => ("Projects"   => ("%*ENV<HOME>/Projects" => 1)),
	4 => ("Tools dir"  => ("c:/Tools" => 0)));

our $DEFAULT_SELECTION = 'q';

sub print_menu(%bookmarks) {
	my @valid_selections;
	for %bookmarks.sort -> (:$key, :$value) { 
		printf "%2d: %-20s (%s)\n", $key, $value.key, $value.value.key;
		push @valid_selections, $key;
	};
	printf "%2s: %-20s\n", 'q', "Quit";
	push @valid_selections, 'q';
	return @valid_selections;
}

sub ask_for_selection(@valid_selections, $default_selection) {
	my $sel = '';
	while (!@valid_selections.first($sel)) {
		$sel = prompt("Go to [$default_selection]: ") || $default_selection;
	}
	return $sel;
}

sub MAIN($filename) {
	my $sel = ask_for_selection(print_menu(%BOOKMARKS), $DEFAULT_SELECTION);
	my $dir = $sel ne 'q' ?? %BOOKMARKS{$sel}.value.key !! '';
	my $fh = open $filename, :w;
	$fh.say($dir);
	$fh.close;
}
