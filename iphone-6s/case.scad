$fs=$preview ? 2 : 0.6;
$fa=$preview ? 6 : 6;

// proportions of case
$caseback=0.9;
$caseedge=1.4;

// the overall bounding box of the phone and screen as measured with calipers
$width=66.99;
$height=137.94;
$depth=6.92;
$vradius=($depth/2); // the phone has a vertical corner profile of a semi-circle
$hradius=10.25; // and about this radius of horizontal corner profile

// the screen has a slight notch around it which measures as follows
$screenwidth=64.55;
$screenheight=135.22;
$screendepth=0.8;

$buttondepth=1;
$buttonradius=1;

$powerbuttonlength=9;
$powerbuttonfromcentre=30;

$volclusterfromcentre=18;
$volclusterlength=32;

$bottomcutoutfromcentre=12;
$bottomcutoutlength=12;
$bottomcutoutradius=0.6;

$powerlength=3;
$powerradius=1;

$camerapositionw=13;
$camerapositionh=7.5;
$cameraradius=4;
$camerastretch=9.7;


// the overall outside bounding box of the main phone body
module bbox() {
    cube([$width, $height, $depth], center=true);
}
// sanity check
if ($preview) translate([0,0,-60]) bbox();


// a rounded box with specified outer dimensions, and with specified vertical and horizontal semicircular chamfers
module roundedbox(width, height, depth, vradius, hradius) {
    // a rounded corner with different horizontal and vertical diameters
    module corner() {
        // create a vradius circle and extrude it around hradius
        rotate_extrude(convexity=1)
            translate([hradius-vradius, 0, 0]) circle(r=vradius);
    };

    // position the centre of each corner so that we get the total dimensions after hulling
    innerWidth = width / 2 - hradius;
    innerHeight = height / 2 -hradius;

    // the total hull encompassing the four corners
    hull() {
        translate([+innerWidth, +innerHeight, 0]) corner();
        translate([-innerWidth, +innerHeight, 0]) corner();
        translate([+innerWidth, -innerHeight, 0]) corner();
        translate([-innerWidth, -innerHeight, 0]) corner();
    };
}


// the overall outside shape of the phone body
module iphone6sbody() {
    roundedbox($width, $height, $depth, $vradius, $hradius);
};
// sanity check
if ($preview) translate([0,0,-50]) iphone6sbody();


// the phone body with notch around screen
module iphone6s() {
    // get phone metal body only by subtracting the screen volume
    color("silver") intersection() {
        iphone6sbody();
        translate([0,0,-$screendepth]) cube([$width, $height, $depth], center=true);
    };
    // get screen notched area only by subtracting the other part and resizing it to screen dimensions
    color("black") resize([$screenwidth,$screenheight,$screendepth]) intersection() {
        iphone6sbody();
        translate([0,0,($depth/2)-$screendepth]) cube([$width, $height, $screendepth], center=true);
    };
}
// sanity check
if ($preview) translate([0,0,-40]) iphone6s();


// the buttons / camera / power socket / speaker holes
module buttons(
    width = $width, height = $height, depth = $depth,
    buttonradius = $buttonradius, buttondepth = $buttondepth,
    powerbuttonfromcentre = $powerbuttonfromcentre, powerbuttonlength = $powerbuttonlength, powerbuttonvshift = 0,
    volclusterfromcentre = $volclusterfromcentre, volclusterlength = $volclusterlength, volclustervshift = 0
    bottomcutoutradius = $bottomcutoutradius, bottomcutoutfromcentre = $bottomcutoutfromcentre, bottomcutoutlength = $bottomcutoutlength,
    powerradius = $powerradius, powerlength = $powerlength, powervshift = 0,
    cameraradius = $cameraradius, camerapositionw = $camerapositionw, camerapositionh = $camerapositionh, camerastretch = $camerastretch
) {

    // power button
    color("silver") translate([width/2, powerbuttonfromcentre, 0]) hull(){
        rotate([0, 90, 0]){
            translate([powerbuttonvshift, 0, 0]) cylinder(r=buttonradius, h=buttondepth, center=true);
            translate([powerbuttonvshift, powerbuttonlength, 0]) cylinder(r=buttonradius, h=buttondepth, center=true);
        }
    }

    // volume cluster
    color("silver") translate([-width/2, volclusterfromcentre, 0]) hull(){
        rotate([0, 90, 0]){
            translate([volclustervshift, 0, 0]) cylinder(r=buttonradius, h=buttondepth, center=true);
            translate([volclustervshift, volclusterlength, 0]) cylinder(r=buttonradius, h=buttondepth, center=true);
        }
    }

    // bottom long cutout left
    color("black") hull(){
        rotate([90, 90, 0]){
            translate([0, -bottomcutoutfromcentre, height/2]) cylinder(r=bottomcutoutradius, h=buttondepth, center=true);
            translate([0, -bottomcutoutlength-bottomcutoutfromcentre, height/2]) cylinder(r=bottomcutoutradius, h=buttondepth, center=true);
        }
    }

    // bottom long cutout right
    color("black") hull(){
        rotate([90, 90, 0]){
            translate([0, bottomcutoutfromcentre, height/2]) cylinder(r=bottomcutoutradius, h=buttondepth, center=true);
            translate([0, bottomcutoutlength+bottomcutoutfromcentre, height/2]) cylinder(r=bottomcutoutradius, h=buttondepth, center=true);
        }
    }

    // power cutout
    color("black") hull(){
        rotate([90, 90, 0]){
            translate([powervshift, -powerlength, height/2]) cylinder(r=powerradius, h=buttondepth, center=true);
            translate([powervshift, powerlength, height/2]) cylinder(r=powerradius, h=buttondepth, center=true);
        }
    }

    // camera cutout
    color("silver") translate([width/2-camerapositionw, height/2-camerapositionh, -depth/2]) hull(){
        cylinder(r=cameraradius, h=buttondepth, center=true);
        translate([-camerastretch,0, 0]) cylinder(r=cameraradius, h=buttondepth, center=true);
    }
}
// sanity check
if ($preview) translate([0,0,-30]) { iphone6s(); buttons(); }


$casewidth = $width + $caseedge*2;
$caseheight = $height + $caseedge*2;
$casedepth = $depth + $caseback;

module case() {
    difference() {
        roundedbox($casewidth, $caseheight, $casedepth, $casedepth/2, $hradius+$caseedge);

        translate([0,0,($casedepth-$depth)/2]) {

            // subtract the phone
            iphone6s();

            // make a hole for the screen
            translate([0,0,-13]) {
                resize([$screenwidth,$screenheight,5]) intersection() {
                    iphone6sbody();
                    translate([0,0,($depth/2)-$screendepth]) cube([$width, $height, $screendepth], center=true);
                }
            };
            buttons(buttondepth = 10, buttonradius = 1.5, powerradius = 2.9, powervshift = 0.5, bottomcutoutradius = 0.8);
        }
    }
}
case();
