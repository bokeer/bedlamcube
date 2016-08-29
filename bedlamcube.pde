import controlP5.*;
ControlP5 cp5;
String textValue = "";

long[] solution=new long[13];
int[] coor=new int[52];
float angle1=0;
float angle2=0;
int part=0;
int time=0;
int waynum=1;
boolean pause=false;
boolean rotatemark=false;
color c1 = color(204, 153, 0);

BufferedReader reader;
String line;

void setup(){
long  a=0xffff1fff1L;
println(a);
size(900, 600, P3D);
//sphereDetail(12);
//noFill();
//background(204);
//camera(50, 35.0, 120.0, 50, 0,-30, 0.0, 1.0, 0.0);
//translate(50, 50, 0);
//rotateX(-PI/6);
//rotateY(PI/3);
//box(45);
reader = createReader("cube_solution.txt");
readdata1();
readdata2();
Resolve();
time=millis();
part=1;
   PFont font = createFont("arial",20);
   
   cp5 = new ControlP5(this);
   cp5.addTextfield("input 1~~19186")
     .setPosition(20,100)
     .setFont(font)
     .setSize(90,36)
     .setFocus(true)
     .setColor(color(255,0,0))
     ;
     //textFont(font);
}
void draw(){
  
  lights();
  background(0);
  
  pushMatrix();
  translate(-width/3, height/2, -1000);
  drawpart(part);
  popMatrix();
   
  pushMatrix(); 
  translate(width, height/2, -1000);
  drawposition(part);
  popMatrix();
  
  if(millis()-time>10000){
  c1=color(random(0, 255),random(0, 255),random(0, 255));  
  time=millis();
  part++;
  if(part==14)
  part=1;
  }
  fill(243,110,45);
  
  textSize(100);
  text(waynum, 360, 100); 


}
void drawpart(int part){
  
  // println(hex(c));
   rotateY(angle1);
   angle1+=PI/180;
   
  
  
   noStroke();
   fill(c1);
   int c=0+4*(part-1);
  for(int y=-2;y<2;y++) {
    int a=1;
  for(int z=-2;z<2;z++){
   for(int x=-2;x<2;x++){
       if((coor[c]&a)!=0){
        pushMatrix();
        translate(120*x, -120*y, -120*z);
        box(120);
        popMatrix();
       // println(1);
      }
      a=a<<1;
      // println("a:"+hex(a));
   }
  }
  c++;
 }
 
}


void drawposition(int num){
 // rotateY(0);
  //rotateX(0);
   rotateX(angle2/3);
   rotateY(angle2);
   if(angle2>PI/3)
   rotatemark=true;
   if(angle2<-PI/3)
   rotatemark=false;
  if(rotatemark==false)
   angle2+=PI/800;
  if(rotatemark==true)
   angle2-=PI/800;
  
  int count=0;
  int c=0+4*(num-1);
  for (int y = -2; y < 2; y++) {
    int a=1;
    for (int z = -2; z< 2; z++) {
      for (int x= -2; x< 2; x++) {
        
        if(count==0)
        stroke(255);
        else
        stroke(123);
        
        if((coor[c]&a)!=0){
        pushMatrix();
        translate(120*x, -120*y, -120*z);
        fill(c1);
       
        box(120);
        popMatrix();
        count++;
        // println(1);
        }else{
        pushMatrix();
        translate(120*x, -120*y, -120*z);
        noFill();
        box(120);
        popMatrix();
        count++;
        }
        a=a<<1;
      }
    }
     c++;
  }

}


void Resolve(){
  int c=0;
  for(int a=0;a<13;a++){
    for(int b=0;b<4;b++){
    coor[c]=(int)solution[a]&(0xffff);
    solution[a]=solution[a]>>16;
    print(hex(coor[c])+" ,");
    c+=1; 
    }
    print("\n\r");
  }
}

void keyReleased() {
   if (key ==' '){
   if(pause==false){
   noLoop();
   pause=true;
   }
   else{
   loop();
   pause=false;
   }
   println(pause);
   }
  
}
void mouseReleased(){
  if (mouseButton == LEFT){
    if(mouseX>20&&mouseX<110&&mouseY>100&&mouseY<136){
     ;
    }else{
      if(pause==false){
      noLoop();
      pause=true;
      }
      else{
      loop();
      pause=false;
      }
    println(pause);
    }
   }
   if (mouseButton == RIGHT){
     waynum++;
     if(waynum>19186)
      waynum=1;
      readdata1();
      readdata2();
      Resolve();
      println("waynum:"+waynum);
   } 
    
}
void readdata1(){
  try {
    line = reader.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if (line == null) {
    // Stop reading because of an error or file is empty
    noLoop();  
  }
}
void readdata2(){
    println(line);
    String[] pieces = split(line,",");
    for(int a=0;a<13;a++){
    println(pieces[a]);
    //solution[a]=Long.parseLong(pieces[a]);
      solution[a]=Long.parseUnsignedLong(pieces[a].substring(2, pieces[a].length() - 1), 16);
   }
 }


void controlEvent(ControlEvent theEvent) {
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
    int a=int(theEvent.getStringValue());        
    if(a>=1&&a<=19186){
    if(a!=waynum){
     waynum=a;
     reader = createReader("cube_solution.txt");
     for(int b=0;b<waynum;b++){
      readdata1();
      }
      readdata2();
      Resolve();
     } 
    }
    println("waynum:"+waynum);
  }
}