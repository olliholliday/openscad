$fn=50;
module samsung() {
    minkowski() {
    translate([2.5,7.45,2.1]) cube([122.4,49.6,3.5]); //original höhe 3.3
    translate([0,0,0]) cylinder(r=8, h=.5);
        sphere(r=2);
    }
}

difference() {
    union() {
        //case
    color("green") minkowski() {
        samsung();
        sphere(r=1);
    }
        //volume buttons
    translate([106.5,65,4.5]) color("blue") minkowski() {
        cube([10,5,1], center=true);
        sphere(r=1);
    }   
    translate([92.5,65,4.5]) color("blue") minkowski() {
        cube([10,5,1], center=true);
        sphere(r=1);
    }   
        //power button
    translate([82,-.6,4.5]) color("blue") minkowski() {
        cube([10,5,1], center=true);
        sphere(r=1);
    }   
}
union() {
    // inside
    samsung();
    // screen opening
    translate([1.7,1.7,5]) scale([.975,.95,1]) samsung();
    //cube(20,center=true);
    // headphone opening
    rotate([0,90,0]) translate([-4,48.5,0]) cylinder(r=3.4,h=20, center=true);
    // buttom openings
    translate([-10,32,4]) color("red") minkowski() {
        cube([10,12,4], center=true);
        sphere(r=1.4);
    }
    translate([-10,15,4]) color("red") minkowski() {
        cube([10,12,4], center=true);
        sphere(r=1.4);
    }
    // volume buttons inner
    translate([106.5,63.6,5]) color("blue") minkowski() {
        cube([10,5,2], center=true);
        sphere(r=1.4);
    }   
    translate([92.5,63.6,5]) color("blue") minkowski() {
        cube([10,5,2], center=true);
        sphere(r=1.4);
    }   
    //translate([88,64,5.5]) cube(10, center=true);
    // power button inner
    translate([82,.95,5]) color("blue") minkowski() {
        cube([10,5,2], center=true);
        sphere(r=1.4);
    }   
    //translate([80,0,5.5]) cube(10, center=true);

    // top mic opening
    rotate([0,90,0]) translate([-5.5,21,135]) cylinder(r=2,h=20, center=true);    
    // camera opening
    translate([110.5,37.5,-5]) color("yellow") minkowski() {
        cube([10,21,10], center=true);
        sphere(r=3.5);
    }
}   
}

//translate([-100,-30,-30]) import("Galaxy_S7_for_SemiFlex.stl");
