$bottom=45;
$rotation=-90;
$text1size=10;
$text1="";
$linespace=-20;
$text2size=10;
$text2 ="";

module samsung() {
    minkowski() {
        translate([2.5,7.45,2.1]) cube([122.4,49.6,3.5]);
        translate([0,0,0]) cylinder(r=8, h=.5);
        sphere(r=2);
    }
}
module  slogan() {
    translate([$bottom,32,1])
    rotate (a=[0,180,-$rotation]) 
    linear_extrude(3) union() {
        text($text1, halign="center", size=$text1size);
        translate([0,$linespace,0])
            text($text2, halign="center", size=$text2size, font="verdana" );
    }
}

difference() {
    union() {
        //case
        color("green") minkowski() {
            samsung();
            sphere(r=0.8);
        }
//        //volume buttons
//        translate([106.5,65,4.5]) color("blue") minkowski() {
//            cube([10,5,1], center=true);
//            sphere(r=1);
//        }   
//        translate([92.5,65,4.5]) color("blue") minkowski() {
//            cube([10,5,1], center=true);
//            sphere(r=1);
//        }   
//        //power button
//        translate([82,-.6,4.5]) color("blue") minkowski() {
//            cube([10,5,1], center=true);
//            sphere(r=1);
//        }   
    }
    slogan();
    union() {
        // inside
        samsung();
        // screen opening
        translate([1.7,1.7,5]) scale([.975,.95,1]) samsung();
        // headphone opening
        rotate([0,90,0]) translate([-4,48.5,0]) cylinder(r=2.8,h=20,$fn=20, center=true);
        // buttom openings
        translate([-10,32,4]) color("red") minkowski() {
            cube([10,12,4], center=true);
            sphere(r=0.7);
        }
        translate([-10,15,4]) color("red") minkowski() {
            cube([7,11,3], center=true);
            sphere(r=0.6);
        }
        // volume buttons inner
        translate([106.5,63.6,4.5]) color("blue") minkowski() {
            cube([10,5,2], center=true);
            sphere(r=1.3);
        }   
        translate([92.5,63.6,4.5]) color("blue") minkowski() {
            cube([10,5,2], center=true);
            sphere(r=1.3);
        }   

        // power button inner
        translate([82,.95,4.5]) color("blue") minkowski() {
            cube([10,5,2], center=true);
            sphere(r=1.4);
        }   

        // top mic opening
        rotate([0,90,0]) translate([-5.5,21,135]) cylinder(r=2,h=20,$fn=20, center=true);    
        // camera opening
        translate([110.5,37.5,-5]) color("yellow") minkowski() {
            cube([10,21,10], center=true);
            sphere(r=3.5);
        }
    }   
}
