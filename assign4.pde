int b, tX, tY;

// for game frames
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState;

// for blood
final int TOTAL_BLOOD = 200;
int blood;

// for fighter moving
float x;
float y;
float speed = 5;
boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

//for enemy moving
float eX = 0, eY = floor(random(400));
float spacingX = 61;
float spacingY = 61;
float circle = 0;
int numEnemy = 5;
float[]Circle1EnemyX = new float[numEnemy];
float[]Circle1EnemyY = new float[numEnemy];
float[]Circle2EnemyX = new float[numEnemy];
float[]Circle2EnemyY = new float[numEnemy];
float[]Circle3EnemyX = new float[numEnemy];
float[]Circle3EnemyY = new float[numEnemy];

// images
PImage startOneImg, startTwoImg;
PImage endOneImg, endTwoImg;
PImage backgroundFormerImg, backgroundLaterImg;
PImage fighterImg, treasureImg, enemyImg, hpImg, shootImg;
PImage [] imgFlame;
int nbrFlame = 5;
int imgFlameFrame = 0;

void setup(){
  size(640, 480);
  
  gameState = GAME_START;
  b = 0;
  eX = 0;
  eY = floor(random(400));
  tX = floor(random(550));
  tY = floor(random(400));    
  x = width*3/4;
  y = floor(random(400));    
  blood = 40;
  
//enemy management  
  for(int i = 0; i < numEnemy; i++){
    Circle1EnemyX[i] = i*spacingX; Circle1EnemyY[i] = 0;
    Circle2EnemyX[i] = i*spacingX; Circle2EnemyY[i] = i*spacingY;
    Circle3EnemyX[i] = i*spacingX;
    if(i <= 2){Circle3EnemyY[i] = i*spacingY;}
    else if(i == 3){Circle3EnemyY[i] = 2*i*spacingY;}
    else{Circle3EnemyY[i] = 0;}
  }

//image loading
  startOneImg = loadImage("img/start1.png");
  startTwoImg = loadImage("img/start2.png");
  endOneImg = loadImage("img/end1.png");
  endTwoImg = loadImage("img/end2.png");
  hpImg = loadImage("img/hp.png");
  fighterImg = loadImage("img/fighter.png");
  treasureImg = loadImage("img/treasure.png");
  enemyImg = loadImage("img/enemy.png");
  shootImg = loadImage("img/shoot.png");
  backgroundFormerImg = loadImage("img/bg1.png");
  backgroundLaterImg = loadImage("img/bg2.png");

//image flames
  imgFlame = new PImage[nbrFlame];
  for(int i=0; i<nbrFlame; i++){imgFlame[i] = loadImage("img/flame"+(i+1)+".png");}
}

void draw(){
  background(0);
  
//game start  
  switch(gameState){   
    case GAME_START:
    image(startTwoImg, 0, 0);
    if(mouseX > 209 && mouseX < 453 && mouseY > 380 && mouseY < 413){        
      if(mousePressed){gameState = GAME_RUN;}
      else{image(startOneImg, 0, 0);}
    }   
 } 
//game run
  switch(gameState){
    case GAME_RUN:    
//background    
    b += 2; b %= 1280;
    image(backgroundFormerImg,b,0);
    image(backgroundLaterImg,b-640,0);
    image(backgroundFormerImg,b-1280,0);    
    
//treasure    
    image(treasureImg,tX,tY);  
    if(x+51 >= tX && x <= tX+41){
      if(y+51 >= tY && y <= tY+41){
         blood += 20;
         tX = floor(random(550)); tY = floor(random(400));
      }
    }
    
//fighter
    image(fighterImg, x, y);  
    if (upPressed) {y -= speed;}
    if (downPressed) {y += speed;}
    if (leftPressed) {x -= speed;}
    if (rightPressed) {x += speed;}   
//boundary detection
    if (x < 0){x = 0;}
    if (x > width-61){x = width - 61;}
    if (y < 0){y = 0;}
    if (y > height-61){y = height - 61;}
    
//enemy    
  for(int i = 0; i < 5; i++){
    if(circle % 3 == 0){
      image(enemyImg, eX+i*spacingX, eY);
      for(int n = 0; n < numEnemy; n ++){
        if(x+61 >= eX+Circle1EnemyX[n] && x <= eX+Circle1EnemyX[n]+61 &&
           y+51 >= eY+Circle1EnemyY[n] && y <= eY+Circle1EnemyY[n]+61){
          blood -= 40;
          image(imgFlame[imgFlameFrame], x-15, y-30);
          imgFlameFrame++;
          if(imgFlameFrame >=5){imgFlameFrame = 4;}
        }
      }
    }else if(circle % 3 == 1){
      image(enemyImg, eX+i*spacingX, eY-i*spacingY);
      for(int n = 0; n < numEnemy; n ++){
        if(x+61 >= eX+Circle2EnemyX[n] && x <= eX+Circle2EnemyX[n]+61 &&
           y+51 >= eY-Circle2EnemyY[n] && y <= eY-Circle2EnemyY[n]+61){
          blood -= 40;
          image(imgFlame[imgFlameFrame], x-15, y-30);
          imgFlameFrame++;
          if(imgFlameFrame >=5){imgFlameFrame = 4;}
        }
      }
      if(eY < 244){eY = 244;}
    }else{
      if(i <= 2){
        image(enemyImg, eX+i*spacingX, eY+i*spacingY);
        image(enemyImg, eX+i*spacingX, eY-i*spacingY);        
      }else if(i == 3){
        image(enemyImg, eX+i*spacingX, eY+spacingY);
        image(enemyImg, eX+i*spacingX, eY-spacingY);        
      }else{
        image(enemyImg, eX+i*spacingX, eY);
      }
      for(int n = 0; n < numEnemy; n ++){
        if(x+61 >= eX+Circle3EnemyX[n] && x <= eX+Circle3EnemyX[n]+61){
          if(y+51 >= eY-Circle3EnemyY[n] && y <= eY-Circle3EnemyY[n]+61 ||
             y+51 >= eY+Circle3EnemyY[n] && y <= eY+Circle3EnemyY[n]+61){
            blood -= 40;
            image(imgFlame[imgFlameFrame], x-15, y-30);
            imgFlameFrame++;
            if(imgFlameFrame >=5){imgFlameFrame = 4;}
          }
        }
      }
      if(eY < 122){eY = 122;}
      if(eY > 297){eY = 297;}
    }
    eX += 1;
    if(eX >= width){
      circle++;
      eX = -305; eY = random(400);
    }
  }
  
//blood
  fill(#ff0000);
  rect(8, 4, blood, 17);
  image(hpImg,0,0);  
  if(blood >= TOTAL_BLOOD){blood = TOTAL_BLOOD;} 
  if(blood <= 0){
    gameState = GAME_OVER;
    blood = 40;
  }
}
//game over
  switch(gameState){ 
    case GAME_OVER:
      image(endTwoImg, 0, 0);
      if(mouseX > 216 && mouseX < 425 && mouseY > 316 && mouseY < 341){        
        if(mousePressed){
          gameState = GAME_START;
          eX = 0;
          eY = floor(random(400));            
          tX = floor(random(550));
          tY = floor(random(400));    
          x = width*3/4;
          y = floor(random(400));
        }else{image(endOneImg, 0, 0);}
      }          
   }  
}
   
void keyPressed() {
  if (key == CODED) { // detect special keys 
    switch (keyCode) {
      case UP:
        upPressed = true;
        break;
      case DOWN:
        downPressed = true;
        break;
      case LEFT:
        leftPressed = true;
        break;
      case RIGHT:
        rightPressed = true;
        break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch (keyCode) {
      case UP:
        upPressed = false;
        break;
      case DOWN:
        downPressed = false;
        break;
      case LEFT:
        leftPressed = false;
        break;
      case RIGHT:
        rightPressed = false;
        break;
    }
  }
}
