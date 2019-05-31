$accuracy=$preview ? 30 : 100; 

// proportions of case
$caseback=1.5;
$caseedge=2;

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

// 
$cameradiameter=7.15; 
$cameram=9.86; // distance from centre of camera to centre of flash




// the overall outside bounding box of the main phone body
module bbox() {
    cube([$width, $height, $depth], center=true);
}
// sanity check
if ($preview) translate([0,0,-60]) bbox();


// a rounded box with specified outer dimensions, and with rounded vertical and horizontal chamfers
module roundedbox(width, height, depth, vradius, hradius) {
    // a rounder corner with different horizontal end vertical diameters
    module corner() {
        // extrude the corner circle around the horizontal profile radius
        rotate_extrude(convexity=1, $fn=$accuracy)
            translate([hradius-vradius, 0, 0])
                circle(r=vradius, $fn=$accuracy);
    };
    
    // the total hull encompassing the four corners
    hull() {
        translate([+(width/2-hradius), +(height/2-hradius), 0]) corner();
        translate([-(width/2-hradius), +(height/2-hradius), 0]) corner();
        translate([+(width/2-hradius), -(height/2-hradius), 0]) corner();
        translate([-(width/2-hradius), -(height/2-hradius), 0]) corner();
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


if ($preview) {
    translate([0,0,-30]) {
        iphone6s();
        
        // volume cluster
        color("silver") translate([-$width/2, $volclusterfromcentre, 0]) hull(){
            rotate([0, 90, 0]){
                cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                translate([0, $volclusterlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
            }
        }
    
        // power button
        color("silver") translate([$width/2, $powerbuttonfromcentre, 0]) hull(){
            rotate([0, 90, 0]){
                cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                translate([0, $powerbuttonlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
            }
        }
        
        // bottom long cutout
        color("black") hull(){
            rotate([90, 90, 0]){
                translate([0, -$bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                translate([0, $bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
            }
        }
        
        // power cutout
        color("black") hull(){
            rotate([90, 90, 0]){
                translate([0, -$powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                translate([0, $powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
            }
        }
    }
}


$casewidth = $width + $caseedge*2;
$caseheight = $height + $caseedge*2;
$casedepth = $depth + $caseback*2;

module case() {
    difference() {
        roundedbox($casewidth, $caseheight, $casedepth, $casedepth/2, $hradius+$caseedge);
        translate([0,0,($casedepth-($depth-$screendepth))/2]) {
            
            iphone6s();
                        
            $powerbuttondepth=10;
            $powerbuttonradius=1.5;            
            $powerradius=2.2;

            // volume cluster
            color("silver") translate([-$width/2, $volclusterfromcentre, 0]) hull(){
                rotate([0, 90, 0]){
                    cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                    translate([0, $volclusterlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                }
            }
        
            // power button
            color("silver") translate([$width/2, $powerbuttonfromcentre, 0]) hull(){
                rotate([0, 90, 0]){
                    cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                    translate([0, $powerbuttonlength, 0]) cylinder(r=$powerbuttonradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                }
            }
            
            // bottom long cutout
            color("black") hull(){
                rotate([90, 90, 0]){
                translate([0, -$bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                translate([0, $bottomcutoutlength, $height/2]) cylinder(r=$bottomcutoutradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                }
            }
            
            // power cutout
            color("black") hull(){
                rotate([90, 90, 0]){
                    translate([0, -$powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                    translate([0, $powerlength, $height/2]) cylinder(r=$powerradius, h=$powerbuttondepth, $fn=$accuracy, center=true);
                }
            }
        }
    }
}

case();

#translate([0,0,($casedepth-($depth-$screendepth))/2]) iphone6s();


//color("red") minkowski() {
//    cube([$width-$depth, $height-$depth, 0], center=true);
//    sphere(r=$vradius);
//};
//
//color("red") minkowski() {
//    rotate([90,0,0]) cylinder(r=$vradius,h=$depth);
//    cube([$width-2*$vradius, $height-2*$vradius, $depth-$vradius], center=true);
//}




//
//
//color ("red") minkowski() {
//    cylinder(r=$hradius, h=0.00001, center=true, $fn=50);
//    sphere(r=$vradius, $fn=50);
//};
//
//hull() {
//    translate([+($width/2-$hradius), +($height/2-$hradius), -60]) cylinder(r=$hradius,h=$depth, center=true);
//    translate([-($width/2-$hradius), +($height/2-$hradius), -60]) cylinder(r=$hradius,h=$depth, center=true);
//    translate([+($width/2-$hradius), -($height/2-$hradius), -60]) cylinder(r=$hradius,h=$depth, center=true);
//    translate([-($width/2-$hradius), -($height/2-$hradius), -60]) cylinder(r=$hradius,h=$depth, center=true);
//};
//
//hull() {
//    translate([+($width/2-$vradius), +($height/2-$vradius), -30]) sphere(r=$vradius);
//    translate([-($width/2-$vradius), +($height/2-$vradius), -30]) sphere(r=$vradius);
//    translate([+($width/2-$vradius), -($height/2-$vradius), -30]) sphere(r=$vradius);
//    translate([-($width/2-$vradius), -($height/2-$vradius), -30]) sphere(r=$vradius);
//};
//
//intersection() {
//    hull() {
//        translate([+($width/2-$hradius), +($height/2-$hradius), -90]) cylinder(r=$hradius,h=$depth, center=true);
//        translate([-($width/2-$hradius), +($height/2-$hradius), -90]) cylinder(r=$hradius,h=$depth, center=true);
//        translate([+($width/2-$hradius), -($height/2-$hradius), -90]) cylinder(r=$hradius,h=$depth, center=true);
//        translate([-($width/2-$hradius), -($height/2-$hradius), -90]) cylinder(r=$hradius,h=$depth, center=true);
//    };
//    hull() {
//        translate([+($width/2-$vradius), +($height/2-$vradius), -90]) sphere(r=$vradius);
//        translate([-($width/2-$vradius), +($height/2-$vradius), -90]) sphere(r=$vradius);
//        translate([+($width/2-$vradius), -($height/2-$vradius), -90]) sphere(r=$vradius);
//        translate([-($width/2-$vradius), -($height/2-$vradius), -90]) sphere(r=$vradius);
//    };
//}