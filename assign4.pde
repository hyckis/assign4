int b, tX, tY, sX, sY;

// for game frames
final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState;

//for shoot
boolean shootOut = false;
final int X = 0, Y = 1, STATE = 2, FLAME_TIME = 3;
final int OUT = 0, IN = 1;
float[][]e = new float[5][3];

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
int [] enemyState = new int [5];
final int LIVE = 0, EXPLODE = 1, DEAD = 2;

// images
PImage startOneImg, startTwoImg;
PImage endOneImg, endTwoImg;
PImage background1Img, background2Img;
PImage fighterImg, treasureImg, enemyImg, hpImg, shootImg;
//for flames
PImage [] imgFlame;
int nbrFlame = 5;
int imgFlameFrame = 0;
int flameTime;

void setup(){
  size(640, 480);
  
  gameState = GAME_START;
  b = 0;
  eX = 0; eY = floor(random(400));
  tX = floor(random(550)); tY = floor(random(400));    
  x = width*3/4; y = floor(random(400));    
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
  for(int i = 0; i < 3; i++){enemyState[i] = 0;}
  for(int i = 0; i < 5; i++){for(int j = 0; j < 3; j++){e[i][j] = 0;}}

//image loading
  startOneImg = loadImage("img/start1.png"); startTwoImg = loadImage("img/start2.png");
  endOneImg = loadImage("img/end1.png"); endTwoImg = loadImage("img/end2.png");
  hpImg = loadImage("img/hp.png");
  fighterImg = loadImage("img/fighter.png");
  treasureImg = loadImage("img/treasure.png");
  enemyImg = loadImage("img/enemy.png");
  shootImg = loadImage("img/shoot.png");
  background1Img = loadImage("img/bg1.png"); background2Img = loadImage("img/bg2.png");

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
    break;
//game run
    case GAME_RUN:    
//background    
    b += 2; b %= 1280;
    image(background1Img,b,0);
    image(background2Img,b-640,0);
    image(background1Img,b-1280,0);    
    
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
      enemyState[i] = LIVE;
      image(enemyImg, eX+i*spacingX, eY);
      for(int n = 0; n < numEnemy; n ++){
//fighter bump into enemy
        if(x+61 >= eX+Circle1EnemyX[n] && x <= eX+Circle1EnemyX[n]+61 &&
           y+51 >= eY+Circle1EnemyY[n] && y <= eY+Circle1EnemyY[n]+61){
          blood -= 40;
          image(imgFlame[imgFlameFrame], x-15, y-30);
          imgFlameFrame++;
          if(imgFlameFrame >=5){imgFlameFrame = 4;}
          enemyState[i] = EXPLODE;
        }
//shoot bump into enemy        
        if(e[n][STATE] == IN && 
           e[n][X]+31 >= eX+Circle1EnemyX[n] && e[n][X] <= eX+Circle1EnemyX[n]+61 &&
           e[n][Y]+27 >= eY+Circle1EnemyY[n] && e[n][Y] <= eY+Circle1EnemyY[n]+61){
        enemyState[i] = EXPLODE;
        e[n][STATE] = OUT;
        }
      }
    }else if(circle % 3 == 1){
      enemyState[i] = LIVE;
      image(enemyImg, eX+i*spacingX, eY-i*spacingY);
      for(int n = 0; n < numEnemy; n ++){
//fighter bump into enemy
        if(x+61 >= eX+Circle2EnemyX[n] && x <= eX+Circle2EnemyX[n]+61 &&
           y+51 >= eY-Circle2EnemyY[n] && y <= eY-Circle2EnemyY[n]+61){
          blood -= 40;
          image(imgFlame[imgFlameFrame], x-15, y-30);
          imgFlameFrame++;
          if(imgFlameFrame >=5){imgFlameFrame = 4;}
          enemyState[i] = EXPLODE;
        }
//shoot bump into enemy        
        if(e[n][STATE] == IN && 
           e[n][X]+31 >= eX+Circle2EnemyX[n] && e[n][X] <= eX+Circle2EnemyX[n]+61 &&
           e[n][Y]+27 >= eY+Circle2EnemyY[n] && e[n][Y] <= eY+Circle2EnemyY[n]+61){
        enemyState[i] = EXPLODE;
        e[n][STATE] = OUT;
        }
      }
      if(eY < 244){eY = 244;}
    }else{
      enemyState[i] = LIVE;
      if(i <= 2){
        image(enemyImg, eX+i*spacingX, eY+i*spacingY);
        image(enemyImg, eX+i*spacingX, eY-i*spacingY);        
      }else if(i == 3){
        image(enemyImg, eX+i*spacingX, eY+spacingY);
        image(enemyImg, eX+i*spacingX, eY-spacingY);        
      }else{
        image(enemyImg, eX+i*spacingX, eY);
      }
//fighter bump into enemy
      for(int n = 0; n < numEnemy; n ++){
        if(x+61 >= eX+Circle3EnemyX[n] && x <= eX+Circle3EnemyX[n]+61){
          if(y+51 >= eY-Circle3EnemyY[n] && y <= eY-Circle3EnemyY[n]+61 ||
             y+51 >= eY+Circle3EnemyY[n] && y <= eY+Circle3EnemyY[n]+61){
            blood -= 40;
            image(imgFlame[imgFlameFrame], x-15, y-30);
            imgFlameFrame++;
            if(imgFlameFrame >=5){imgFlameFrame = 4;}
            enemyState[i] = EXPLODE;
          }
        }
//shoot bump into enemy        
        if(e[n][STATE] == IN && 
           e[n][X]+31 >= eX+Circle3EnemyX[n] && e[n][X] <= eX+Circle3EnemyX[n]+61 &&
           e[n][Y]+27 >= eY+Circle3EnemyY[n] && e[n][Y] <= eY+Circle3EnemyY[n]+61){
        enemyState[i] = EXPLODE;
        e[n][STATE] = OUT;
        }
      }
      if(eY < 122){eY = 122;}
      if(eY > 297){eY = 297;}
    }
//enemyState = EXPLODE
    for(int n = 0; n < imgFlameFrame; n++){
      if(enemyState[i] == EXPLODE){
        if(circle % 3 == 0){image(imgFlame[n], eX+Circle1EnemyX[n], eY+Circle1EnemyY[n]);}
        else if(circle % 3 == 1){image(imgFlame[n], eX+Circle2EnemyX[n], eY+Circle2EnemyY[n]);}
        else{image(imgFlame[n], eX+Circle3EnemyX[n], eY+Circle3EnemyY[n]);}
      }
    }
      
    eX += 1;
    if(eX >= width){
      circle++;
      eX = -305; eY = random(400);
      enemyState[i] = LIVE;
    }
  }
  
//shoot  
  if(shootOut){
    for(int i = 0; i < 5; i++){
      if(e[i][STATE] == OUT){
        e[i][STATE] = IN; e[i][X] = x - 30; e[i][Y] = y + 15;
        shootOut = false;
        break;
      }
    }
  }
  for(int i = 0; i < 5; i++){
    if(e[i][STATE] == IN){
      image(shootImg, e[i][X], e[i][Y]);
      e[i][X] -= speed;
    }
    if(e[i][X] < -30){e[i][STATE] = OUT;}
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
  break;
  
//game over  
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
          circle = 0;
        }else{image(endOneImg, 0, 0);}
      }
      break;
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
  if(key == ' '){
    shootOut = true;
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
  if(key == ' '){
    shootOut = false;
  }
}
