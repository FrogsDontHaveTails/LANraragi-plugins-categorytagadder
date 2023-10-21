package LANraragi::Plugin::Metadata::CategoryTagAdder;

use strict;
use warnings;

# Plugins can freely use all Perl packages already installed on the system 
# Try however to restrain yourself to the ones already installed for LRR (see tools/cpanfile) to avoid extra installations by the end-user.
use Mojo::UserAgent;

# You can also use LRR packages when fitting.
# All packages are fair game, but only functions explicitly exported by the Utils packages are supported between versions.
# Everything else is considered internal API and can be broken/renamed between versions.
use LANraragi::Model::Plugins;
use LANraragi::Utils::Logging qw(get_logger);
use LANraragi::Model::Category;

use LANraragi::Utils::Database qw(compute_id);

#Meta-information about your plugin.
sub plugin_info {

    return (
        #Standard metadata
        name         => "CategoryTagAdder",
        type         => "metadata",
        namespace    => "categorytagadder",
        author       => "Svartavaggen",
        version      => "0.001",
        description  => "Adds the category's name as a tag. Only if the archive is part of the category",
        icon         => "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABmJLR0QAAAAAAAD5Q7t/AAAACXBI\nWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4wYDFCYzptBwXAAAAB1pVFh0Q29tbWVudAAAAAAAQ3Jl\nYXRlZCB3aXRoIEdJTVBkLmUHAAAAjUlEQVQ4y82UwQ7AIAhDqeH/f7k7kRgmiozDPKppyisAkpTG\nM6T5vAQBCIAeQQBCUkiWRTV68KJZ1FuG5vY/oazYGdcWh7diy1Bml5We1yiMW4dmQr+W65mPjFjU\n5PMg2P9jKKvUdxWMU8neqYUW4cBpffnxi8TsXk/Qs8GkGGaWhmes1ZmNmr8kuMPwAJzzZSoHwxbF\nAAAAAElFTkSuQmCC",
        oneshot_arg  => "Category ID. Example: SET_1695510194",
    );

}

#Mandatory function to be implemented by your plugin
sub get_tags {

    shift;
    my $lrr_info = shift; # Global info hash, contains various metadata provided by LRR
    
    #Use the logger to output status - they'll be passed to a specialized logfile and written to STDOUT.
    my $logger = get_logger("CategoryTagAdder","plugins");
    my $file   = $lrr_info->{file_path};

    my $category_of_interest = $lrr_info->{oneshot_param}

    my $id = "";
    eval { $id = compute_id($file); };

    my @arc_categories = LANraragi::Model::Category::get_categories_containing_archive($id);

    foreach my $cat (@arc_categories) {

        my $catid = %{$cat}{"id"};
        
        if ($catid == $category_of_interest)
        {
            my $catname = %{$cat}{"name"};
            return ( tags => $catname);
        }

        $logger->info($catid);
    }

    #Otherwise, return the tags you've harvested.
    return ( "" );
}

1;