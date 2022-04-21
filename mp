use Geo::OSM::StaticMap;

# Alternatively let center and zoom be calculated from markers
my $staticmap_url = Geo::OSM::StaticMap->new(
    size    => [ 756, 476 ], # width, height
    markers => [ [ 51.8785011494, -0.3767887732, 'ol-marker' ],
                 [ 51.455313, -2.591902, 'ol-marker' ], ],
                 # lat, lon, marker
)->url();

print $staticmap_url, "\n";
