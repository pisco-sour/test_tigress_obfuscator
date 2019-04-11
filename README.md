# test_tigress_obfuscator
Simple test code testing Tigress obfuscator tool


At the time I was testing this, after intalling Tigress I was getting this error:
Cannot find GNUCC version

To fix it, the following change is needed for Tigress in ~/tools/tigress-2.2/App/Cilly.pm:

sub setVersion {
    my($self) = @_;
    my $cversion = "";
    open(VER, "@{$self->{CC}} -dumpversion "
         . join(' ', @{$self->{PPARGS}}) ." |")
        || die "Cannot start GNUCC";
    while(<VER>) {
        #if($_ =~ m|^(\d+\S+)| || $_ =~ m|^(egcs-\d+\S+)|) {        <- old
        if($_ =~ m|^(\d+\S*)| || $_ =~ m|^(egcs-\d+\S*)|) {         <- new
            $cversion = "gcc_$1";
            close(VER) || die "Cannot start GNUCC\n";
            $self->{CVERSION} = $cversion;
            return;
        }
    }
    die "Cannot find GNUCC version\n";
}

