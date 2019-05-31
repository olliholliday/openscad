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


$powerbuttonlength=10;
$powerbuttonradius=1;
$powerbuttondepth=1;
$powerbuttonfromcentre=28;

$volclusterfromcentre=14;
$volclusterlength=36;

$bottomcutoutlength=22;
$bottomcutoutradius=0.5;

$powerlength=3;
$powerradius=1;

$camerapositionw=14;
$camerapositionh=8.5;
$cameraradius=4;
$camerastretch=9.8;


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

if ($preview) {
    translate([0,0,-30]) {
        iphone6s();
        
        // volume cluster
        color("silver") translate([-$width/2, $volclusterfromcentre, 0]) hull(){
            rotate([0, 90, 0]){
                cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
                translate([0, $volclusterlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
            }
        }
    
        // power button
        color("silver") translate([$width/2, $powerbuttonfromcentre, 0]) hull(){
            rotate([0, 90, 0]){
                cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
                translate([0, $powerbuttonlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
            }
        }
        
        // bottom long cutout
        color("black") hull(){
            rotate([90, 90, 0]){
                translate([0, -$bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, center=true);
                translate([0, $bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, center=true);
            }
        }
        
        // power cutout
        color("black") hull(){
            rotate([90, 90, 0]){
                translate([0, -$powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, center=true);
                translate([0, $powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, center=true);
            }
        }
        
        // camera cutout
        color("silver") translate([$width/2-$camerapositionw, $height/2-$camerapositionh, -$depth/2]) hull(){
            cylinder(r=$cameraradius, h=$powerbuttondepth, center=true);
            translate([-$camerastretch,0, 0]) cylinder(r=$cameraradius, h=$powerbuttondepth, center=true);
        }
    }
}


$casewidth = $width + $caseedge*2;
$caseheight = $height + $caseedge*2;
$casedepth = $depth + $caseback;

module case() {
    difference() {
        roundedbox($casewidth, $caseheight, $casedepth, $casedepth/2, $hradius+$caseedge);
       
        translate([0,0,($casedepth-$depth)/2]) {
            
            intersection() {
                iphone6sbody();
                translate([0,0,-$screendepth]) cube([$width, $height, $depth], center=true);
            };
            // get screen notched area only by subtracting the other part and resizing it to screen dimensions
            translate([0,0,-13]) {
                resize([$screenwidth,$screenheight,5]) intersection() {
                    iphone6sbody();
                    translate([0,0,($depth/2)-$screendepth]) cube([$width, $height, $screendepth], center=true);
                }
            };
            
            
            $powerbuttondepth=10;
            $powerbuttonradius=1.5;            
            $powerradius=2.2;
            
            // volume cluster
            color("silver") translate([-$width/2, $volclusterfromcentre, 0]) hull(){
                rotate([0, 90, 0]){
                    cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
                    translate([0, $volclusterlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
                }
            }
        
            // power button
            color("silver") translate([$width/2, $powerbuttonfromcentre, 0]) hull(){
                rotate([0, 90, 0]){
                    cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
                    translate([0, $powerbuttonlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, center=true);
                }
            }
            
            // bottom long cutout
            color("black") hull(){
                rotate([90, 90, 0]){
                translate([0, -$bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, center=true);
                translate([0, $bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, center=true);
                }
            }
            
            // power cutout
            color("black") hull(){
                rotate([90, 90, 0]){
                    translate([0, -$powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, center=true);
                    translate([0, $powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, center=true);
                }
            }

            // camera cutout
            translate([$width/2-$camerapositionw, $height/2-$camerapositionh, -$depth/2]) hull(){
                cylinder(r=$cameraradius, h=$powerbuttondepth, center=true);
                translate([-$camerastretch,0, 0]) cylinder(r=$cameraradius, h=$powerbuttondepth, center=true);
            }            
        }
    }
}

case();

