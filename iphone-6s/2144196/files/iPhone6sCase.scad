W=71; // overall width
L=141.5; // overall length
R=10.25; // corner radius
WT=1.5; // wall thickness
WH=9.25; // wall height
BT=1.25; // backplate thickness


module roundCorner(angle=90, 
        wallThickness=1.5, 
        wallHeight=10, 
        radius=10.5)
{
    rotate_extrude(convexity=10, angle=angle, $fn=64)
    translate([radius, 0, 0])
        polygon(points=[[0, 0], 
            [wallThickness, 0], 
            [wallThickness, wallHeight], 
            [0, wallHeight]]);
}

module backPlate(radius, 
        height, 
        width, 
        length)
{
    hull(){
        translate([radius, radius, 0])
            cylinder(r=radius, h=height, $fn=64);

        translate([width-radius, radius, 0])
            cylinder(r=radius, h=height, $fn=64);
            
        translate([radius, length-radius, 0])
            cylinder(r=radius, h=height, $fn=64);

        translate([width-radius, length-radius, 0])
            cylinder(r=radius, h=height, $fn=64);
    }
}

module backPlateCutout(){
    hull(){
        translate([44.5, 132.5, -1])
            cylinder(r=4.5, h=3, $fn=32);
        translate([57.5, 132.5, -1])
            cylinder(r=4.5, h=3, $fn=32);
    }
}

module leftWallCutout(){
    translate([-1, 87, 5])
    hull(){
        rotate([0, 88, 0]){
            cylinder(r=3, h=5, $fn=32);
            translate([0, 36, 0])
                cylinder(r=3, h=5, $fn=32);
        }
    }
}

module rightWallCutout(){
    translate([W-WT-2, 99, 5])
    hull(){
        rotate([0, 90, 0]){
            cylinder(r=3, h=5, $fn=32);
            translate([0, 12, 0])
                cylinder(r=3, h=5, $fn=32);
        }
    }
}


module flange(length){
    color("green")
    linear_extrude(height=length, 
        center=false,
        convexity=10, 
        twist=0)
        polygon(points=[[0,0], 
            [0,3], 
            [1.5,3],
            [1.5,2],
            [.5,1.3],
            [0,0]]); 
}

module cornerFlange(angle=90, 
        radius)
{
    color("red")
    rotate_extrude(convexity=10, angle=angle, $fn=64)
    translate([radius, 0, 0])
        polygon(points=[[1, 1.3], 
        [0,2], 
        [0,3], 
        [1.5,3],
        [1.5,0]]);
}




difference(){
    backPlate(width=W, length=L, radius=R, height=BT);
    backPlateCutout();
}

//corners
translate([R, R, 0]){
    rotate([0, 0, 180]){
        roundCorner(radius=R-WT, wallHeight=WH);
        translate([0, 0, WH-3])
            cornerFlange(radius=R-WT-1.5);
        translate([0, 0, 3.25])
        rotate([0, 180, -90])
            cornerFlange(radius=R-WT-1.5);
    }
}

translate([W-R, R, 0]){
    rotate([0, 0, 270]){
        roundCorner(radius=R-WT, wallHeight=WH);
        translate([0, 0, WH-3])
            cornerFlange(radius=R-WT-1.5);
        translate([0, 0, 3.25])
        rotate([0, 180, -90])
            cornerFlange(radius=R-WT-1.5);
    }
}

translate([R, L-R, 0]){
    rotate([0, 0, 90]){
        roundCorner(radius=R-WT, wallHeight=WH);
        translate([0, 0, WH-3])
            cornerFlange(radius=R-WT-1.5);
        translate([0, 0, 3.25])
        rotate([0, 180, -90])
            cornerFlange(radius=R-WT-1.5);        
    }
}

translate([W-R, L-R, 0]){
    roundCorner(radius=R-WT, wallHeight=WH);
    translate([0, 0, WH-3])
            cornerFlange(radius=R-WT-1.5);
    translate([0, 0, 3.25])
    rotate([0, 180, -90])
        cornerFlange(radius=R-WT-1.5);
}

// side walls
union(){
    translate([R, L-WT, 0])
        cube([W-(2*R), WT, WH]); 
    
    translate([R-.25, L-WT, 3.25])
    rotate([-90, 0, 270])
        flange(length=W-(R*2)+.5);
    
    translate([W-R+.25, L-WT, WH-3])
    rotate([90, 0, 270])
        flange(length=W-(R*2)+.5);
}

difference(){
    union(){
        translate([0, R-.25, 0])
            cube([WT, L-(2*R)+.5, WH]);
        
        translate([WT, R-.25, 3.25])
        rotate([-90, 0, 0])
            flange(length=L-(R*2)+.5);
        
        translate([WT, L-R+.25, WH-3])
        rotate([90, 0, 0])
            flange(length=L-(R*2)+.5);
    }
    leftWallCutout();
}

difference(){
    union(){
        translate([W-WT, R-.25, 0])
            cube([WT, L-(2*R)+.5, WH]);
        
        translate([W-WT, L-R+.25, 3.25])
        rotate([-90, 0, 180])
            flange(length=L-(R*2)+.5);
        
        translate([W-WT, R-.25, WH-3])
        rotate([90, 0, 180])
            flange(length=L-(R*2)+.5);
    }
    rightWallCutout();
}
