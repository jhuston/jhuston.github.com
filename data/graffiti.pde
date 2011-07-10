/**
 * Follow 1. 
 * Based on code from Keith Peters (www.bit-101.com). 
 * 
 * A line segment is pushed and pulled by the cursor.
 */

ArrayList circles;
int BG = 0;
int[] branch= new int[6];
int num = 1;
float angle = 30;
int diam = 15;
int diam2;
color myC;
boolean splatter=true;
boolean single = true;
float myXvector;
float myYvector;
void setup() {
  ellipseMode(CENTER);
  size(800, 800);
  smooth(); 
  background(BG);
  circles = new ArrayList();
  cursor(CROSS);
for(int i=5;i>=0;i--){
  branch[i]=(int)random(30);
}
}

void draw() {
  
//  background(255);
 if(keyPressed){
   if(key == 'c' || key =='C'){
   background(BG);
   }
   if(key == 's' || key =='S'){
   splatter = !splatter;
   println(splatter);
   }
   if(key =='p' || key=='P'){
     noLoop();
   }
 
 }
 if(mousePressed==true){
 myC = color(255,random(100),random(150),50);
//      myC = color(0,0,0,255);
    myXvector = (mouseX-pmouseX);
    myYvector = (mouseY-pmouseY);
  if(splatter == true){
    circles.add(new Circle(mouseX,mouseY+5,diam,myXvector,myYvector,myC,(int)random(40)+20));
  } 
}

 //if(circles.size()>20){circles.remove(0);}
   for(int i=circles.size()-1; i >=0; i--){
      Circle circle = (Circle) circles.get(i);
      circle.update();
      circle.display();
      
      if((circle.age<=1)||(circle.ypos<30)||(circle.ypos>height-30)||(circle.xpos>width-30)||(circle.xpos<30)){
        circle.flower(circle.xpos,circle.ypos);
        circles.remove(i);
      }         
  } 
 // println(circles.size());

}

void keyPressed(){
 if(key == 'v' || key == 'V'){
  save("actionSketch"+num+".png");
  num +=1;
 } 
}
class Circle{
  float xpos;
  float ypos;
  float xVector;
  float yVector;
  float diameter;
  color c;
  float px2,py2;
  int age;
  
  
  Circle(float tempXpos, float tempYpos, float tempDiameter,float tempXvector,float tempYvector, color tempC, int tempAge){
    xpos = tempXpos;
    ypos = tempYpos;
    diameter = tempDiameter;
    c = tempC;
    xVector = tempXvector%5;
    yVector = tempYvector%5;
    px2 = tempXpos;
    py2 = tempYpos;
    age = tempAge;
  }
  
  void display(){
    stroke(255);
    strokeWeight(1+random(2));
//    line(px2-2,py2-2,xpos-2,ypos-2);
    line(px2,py2,xpos,ypos);
    noStroke();
    fill(myC);
    ellipse(xpos,ypos,diameter,diameter);
    px2= xpos;
    py2= ypos;
    if(age==30){
//    flower(xpos,ypos);
    }
  }
  
  void flower(float px,float py){
    diam2=(int)random(10);
    angle =0;
    stroke(255,100);
    strokeWeight(1);
    fill(0,random(255),random(150),150);
     // ellipse(px,py,10,10);
    for(int i =0;i<=6;i++){
      angle -=60;
      px = px+(cos(radians(angle))*diam2);
      py = py+(sin(radians(angle))*diam2);
       ellipse(px,py,diam2,diam2);   
    
    }
  }
  
  void update(){
    age -= 1;
    xpos = xpos+(-2+random(4))+xVector;
    ypos = ypos+(-2+random(4))+yVector;
    diameter = abs((diameter)-(random(.5)));

}
}