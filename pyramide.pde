int etage = 0; // declaration de la variable globale pour les étages
int anim = 0;
int iposX = 1;
int iposY = 0;
int posX = iposX;
int posY = -6;
int dirX = 0;
int dirY = 1;
int odirX = 0;
int odirY = 1;
int WALLD = 1;
boolean inLab = true;
boolean animT=false;
boolean animR=false;

int[] LAB_SIZE = {23, 17, 11, 5}; // Les longueur des labs respectivement
int ETAGE_MAX = 4;
char lab [][][] = new char[4][][];
char walls [][][][] = new char[4][][][];

PShape[] laby0 = new PShape[4]; // On crée un array de PShape representant nos labyrinthes empilés
PShape[] ceiling0 = new PShape[4];
PShape[] ceiling1 = new PShape[4];
PShape sand;
PImage stoneTexture;
PImage sandTexture;

void setup() {
  size(1000, 1000, P3D);
  pixelDensity(2);
  randomSeed(2);
  stoneTexture = loadImage("stones.jpg");
  sandTexture = loadImage("sand.jpg");
  for (int n = 0; n < 4; n++) {
    lab[n] = new char[LAB_SIZE[n]][LAB_SIZE[n]];
    walls[n] = new char[LAB_SIZE[n]][LAB_SIZE[n]][4];
  }
  int remaining = 0;
  for (int n = 0; n < ETAGE_MAX; n++) {
    for (int j=0; j<LAB_SIZE[n]; j++) {
      for (int i=0; i<LAB_SIZE[n]; i++) {
        walls[n][j][i][0] = 0;
        walls[n][j][i][1] = 0;
        walls[n][j][i][2] = 0;
        walls[n][j][i][3] = 0;
        if (j%2==1 && i%2==1) {
          lab[n][j][i] = '.';
          remaining ++;
        } else
          lab[n][j][i] = '#';
      }
    }
    int ghostX = 1;
    int ghostY = 1;
    while (remaining > 0) {
      int prevGhostX = ghostX;
      int prevGhostY = ghostY;
      int randomDirection = floor(random(0, 4));
      if      (randomDirection == 0 && ghostX > 1)          ghostX -= 2;
      else if (randomDirection == 1 && ghostY > 1)          ghostY -= 2;
      else if (randomDirection == 2 && ghostX < LAB_SIZE[n] - 2) ghostX += 2;
      else if (randomDirection == 3 && ghostY < LAB_SIZE[n] - 2) ghostY += 2;

      if (lab[n][ghostY][ghostX] == '.') {
        remaining--;
        lab[n][ghostY][ghostX] = ' ';
        lab[n][(ghostY+prevGhostY)/2][(ghostX+prevGhostX)/2] = ' ';
      }
    }

    lab[n][0][1] = ' ';
    lab[n][LAB_SIZE[n]-2][LAB_SIZE[n]-1] = ' ';


    for (int j=1; j<LAB_SIZE[n]-1; j++) {
      for (int i=1; i<LAB_SIZE[n]-1; i++) {
        if (lab[n][j][i]==' ') {
          if (lab[n][j-1][i]=='#' && lab[n][j+1][i]==' ' &&
            lab[n][j][i-1]=='#' && lab[n][j][i+1]=='#')
            walls[n][i][j-1][0] = 1;// bout de couloir vers le haut
          if (lab[n][j-1][i]==' ' && lab[n][j+1][i]=='#' &&
            lab[n][j][i-1]=='#' && lab[n][j][i+1]=='#')
            walls[n][j+1][i][3] = 1;// bout de couloir vers le bas
          if (lab[0][j-1][i]=='#' && lab[n][j+1][i]=='#' &&
            lab[n][j][i-1]==' ' && lab[n][j][i+1]=='#')
            walls[n][j][i+1][1] = 1;// bout de couloir vers la droite
          if (lab[n][j-1][i]=='#' && lab[n][j+1][i]=='#' &&
            lab[n][j][i-1]=='#' && lab[n][j][i+1]==' ')
            walls[n][j][i-1][2] = 1;// bout de couloir vers la gauche
        }
      }
    }


    float wallW = width/LAB_SIZE[0];
    float wallH = height/LAB_SIZE[0];

    ceiling0[n] = createShape();
    ceiling1[n] = createShape();

    ceiling1[n].beginShape(QUADS);
    ceiling0[n].beginShape(QUADS);

    laby0[n] = createShape();
    laby0[n].beginShape(QUADS);
    laby0[n].texture(stoneTexture);
    ceiling0[n].texture(stoneTexture);
    ceiling1[n].texture(stoneTexture);
    laby0[n].noStroke();
    for (int j=0; j<LAB_SIZE[n]; j++) {
      for (int i=0; i<LAB_SIZE[n]; i++) {
        if (lab[n][j][i]=='#') {

          laby0[n].fill(i*25, j*25, 255-i*10+j*10);
          if (j==0 || lab[n][j-1][i]==' ') {
            laby0[n].normal(0, -1, 0);
            for (int k=0; k<WALLD; k++)
              for (int l=-WALLD; l<WALLD; l++) {
                laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, k/(float)WALLD*stoneTexture.width, (0.5+l/2.0/WALLD)*stoneTexture.height);

                laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+l/2.0/WALLD)*stoneTexture.height);

                laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);

                laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, k/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);
              }
          }

          if (j==LAB_SIZE[n]-1 || lab[n][j+1][i]==' ') {
            laby0[n].normal(0, 1, 0);
            for (int k=0; k<WALLD; k++)
              for (int l=-WALLD; l<WALLD; l++) {
                laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, (k+0)/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+(l+0)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, (k+0)/(float)WALLD*stoneTexture.width, (0.5+(l+0)/2.0/WALLD)*stoneTexture.height);
              }
          }

          if (i==0 || lab[n][j][i-1]==' ') {
            laby0[n].normal(-1, 0, 0);
            for (int k=0; k<WALLD; k++)
              for (int l=-WALLD; l<WALLD; l++) {
                laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, (k+0)/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+(l+0)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, (k+0)/(float)WALLD*stoneTexture.width, (0.5+(l+0)/2.0/WALLD)*stoneTexture.height);
              }
          }

          if (i==LAB_SIZE[n]-1 || lab[n][j][i+1]==' ') {
            laby0[n].normal(1, 0, 0);
            for (int k=0; k<WALLD; k++)
              for (int l=-WALLD; l<WALLD; l++) {
                laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, (k+0)/(float)WALLD*stoneTexture.width, (0.5+(l+0)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+(l+0)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, (k+1)/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);
                laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, (k+0)/(float)WALLD*stoneTexture.width, (0.5+(l+1)/2.0/WALLD)*stoneTexture.height);
              }
          }
          ceiling1[n].noStroke();
          ceiling1[n].fill(32, 255, 0);
          ceiling1[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50, 0, 0);
          ceiling1[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50, 100, 0);
          ceiling1[n].vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50, 100, 100);
          ceiling1[n].vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50, 0, 100);
        } else {
          laby0[n].fill(192); // ground
          laby0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2, -49, 0, 0);
          laby0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2, -49, 100, 0);
          laby0[n].vertex(i*wallW+wallW/2, j*wallH+wallH/2, -49, 100, 100);
          laby0[n].vertex(i*wallW-wallW/2, j*wallH+wallH/2, -49, 0, 100);
          ceiling0[n].noStroke();
          ceiling0[n].fill(32); // top of walls
          ceiling0[n].vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50, 0, 0);
          ceiling0[n].vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50, 100, 0);
          ceiling0[n].vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50, 100, 100);
          ceiling0[n].vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50, 0, 100);
        }
      }
    }




    laby0[n].endShape();
    ceiling0[n].endShape();
    ceiling1[n].endShape();
  }
  // Desert
  sand  = createShape();
  sand.beginShape(QUADS);
  sand.texture(sandTexture);
  sand.fill(25, 25, 25);
  sand.noStroke();
  float wallW = width / LAB_SIZE[0];
  float wallH = height / LAB_SIZE[0];
  for (int j = -4 * LAB_SIZE[0]; j < 4 *  LAB_SIZE[0]; j++) {
    for (int i = -4 * LAB_SIZE[0]; i < 4 * LAB_SIZE[0]; i++) {
      sand.vertex(i * wallW, j * wallH, -50, 0, 0);
      sand.vertex((i + 1) * wallW, j * wallH, -50, 100, 0);
      sand.vertex((i + 1) * wallW, (j + 1) * wallH, -50, 100, 100);
      sand.vertex(i * wallW, (j + 1) * wallH, -50, 0, 100);
    }
  }
  sand.endShape();
}
void draw() {
  background(192);
  sphereDetail(6);
  if (anim>0) anim--;
  float wallW = width/LAB_SIZE[0];
  float wallH = height/LAB_SIZE[0];

  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  noLights();
  stroke(0);
  for (int j=0; j<LAB_SIZE[etage]; j++) {
    for (int i=0; i<LAB_SIZE[etage]; i++) {
      if (lab[etage][j][i]=='#') {
        fill(i*25, j*25, 255-i*10+j*10);
        pushMatrix();
        translate(50+i*wallW/8, 50+j*wallH/8, 50);
        box(wallW/10, wallH/10, 5);
        popMatrix();
      }
    }
  }
  pushMatrix();
  fill(0, 255, 0);
  noStroke();
  translate(50+posX*wallW/8, 50+posY*wallH/8, 50);
  sphere(3);
  popMatrix();

  stroke(0);

  perspective(2*PI/3, float(width)/float(height), 1, 1000);
  if (animT)
    camera((posX-dirX*anim/20.0)*wallW+ wallW * etage, (posY-dirY*anim/20.0)*wallH+ wallH * etage, -15+2*sin(anim*PI/5.0) + etage * 100,
      (posX-dirX*anim/20.0+dirX)*wallW + wallW * etage, (posY-dirY*anim/20.0+dirY)*wallH + wallH * etage, -15+4*sin(anim*PI/5.0) + etage * 100, 0, 0, -1);
  else if (animR)
    camera(posX*wallW+ wallW * etage, posY*wallH + wallH * etage, -15 + etage * 100,
      (posX+(odirX*anim+dirX*(20-anim))/20.0)*wallW+wallW*etage, (posY+(odirY*anim+dirY*(20-anim))/20.0)*wallH+wallH*etage, -15-5*sin(anim*PI/20.0) + etage * 100, 0, 0, -1);
  else {
    camera(posX*wallW + etage * wallW, posY*wallH + etage * wallH, -15 + etage * 100,
      (posX+dirX)*wallW+wallW * etage, (posY+dirY)*wallH+ wallH * etage, -15 + etage * 100, 0, 0, -1);
  }
  if (isInLab()) {
    lightFalloff(0.0, 0.01, 0.0001);
    pointLight(255, 255, 255, posX*wallW + etage * wallW, posY*wallH + etage * wallH, 15 + etage * 100);
  } else {
    lightFalloff(0.0, 0.05, 0.0001);
    pointLight(255, 255, 255, posX*wallW, posY*wallH, 15);
  }

  noStroke();
  for (int j=0; j<LAB_SIZE[etage]; j++) {
    for (int i=0; i<LAB_SIZE[etage]; i++) {
      pushMatrix();
      translate(i*wallW + etage * wallW, j*wallH + etage * wallH, etage * 100);
      if (lab[etage][j][i]=='#') {
        beginShape(QUADS);
        if (walls[etage][j][i][3]==1) {
          pushMatrix();
          translate(0, -wallH/2, 40);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          } else {
            fill(128);
            sphere(15);
          }
          popMatrix();
        }

        if (walls[etage][j][i][0]==1) {
          pushMatrix();
          translate(0, wallH/2, 40);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          } else {
            fill(128);
            sphere(15);
          }
          popMatrix();
        }

        if (walls[etage][j][i][1]==1) {
          pushMatrix();
          translate(-wallW/2, 0, 40);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          } else {
            fill(128);
            sphere(15);
          }
          popMatrix();
        }

        if (walls[etage][j][i][2]==1) {
          pushMatrix();
          translate(0, wallH/2, 40);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            sphere(5);
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          } else {
            fill(128);
            sphere(15);
          }
          popMatrix();
        }
      }
      popMatrix();
    }
  }
  for (int n = 0; n < ETAGE_MAX; n++) {
    pushMatrix();
    translate(n * wallW, n * wallH, n * 100);
    shape(laby0[n], 0, 0);
    if (inLab)
      shape(ceiling0[n], 0, 0);
    else
      shape(ceiling1[n], 0, 0);
    popMatrix();
  }
  if (!isInLab()) {
    shape(sand, posX - width / 2, posY - height / 2);
  }
}


boolean isInLab() {
  if (posX >= 0 && posX < LAB_SIZE[etage] - 1 && posY >= 0 && posY < LAB_SIZE[etage] - 1)
    inLab = true;
  else
    inLab = false;
  return inLab;
}

void keyPressed() {
  if (key=='l') inLab = !inLab;


  if (anim==0 && keyCode==38) {
    if (isInLab()) {
      if (posX+dirX == LAB_SIZE[etage] - 1 && posY+dirY ==  LAB_SIZE[etage] - 2 && etage < ETAGE_MAX && isInLab()) {
        // On est arrivés à la sortie donc on réinitialise tout et on monte d'un étage
        animT = true; // Pour l'animation de la translation
        animR = false ;// Pour l'animation de la rotation
        anim = 20;
        posX = iposX; // posX prend la postion initiale
        posY = iposY; // posY prend la postion initiale
        etage = etage + 1; // Incrementation de étage
        dirX = 0;
        dirY = 1;
        odirX = 0;
        odirY = 1;
      } else if (posX+dirX == 1 && posY+dirY ==  -1) {
        // On est arrivés à l'entrée donc on réinitialise tout et on monte d'un étage
        if (etage > 0) {
          animT = true; // Pour l'animation de la translation
          animR = true; // Pour l'animation de la rotation
          anim = 20;
          posX = LAB_SIZE[etage - 1] - 2; // posX prend la postion avant la montée
          posY =  LAB_SIZE[etage - 1] - 2; // posY prend la postion avant la montée
          etage = etage--; // On décrémente etage
        } else {
          posX+=dirX;
          posY+=dirY;
          anim=20;
          animT = true;
          animR = false;
        }
      } else if (lab[etage][posY+dirY][posX+dirX]!='#') {
        posX+=dirX;
        posY+=dirY;
        anim=20;
        animT = true;
        animR = false;
      }
    } else {
      posX+=dirX;
      posY+=dirY;
      if (isInLab() && (posY != 0 || posX != 1)) {
        posX -= dirX;
        posY -= dirY;
      } else {
        anim = 20;
        animT = true;
        animR = false;
      }
    }
  }
  if (anim==0 && keyCode==40) {
    if (isInLab()) {
      if (posX-dirX == LAB_SIZE[etage] - 1 && posY-dirY ==  LAB_SIZE[etage] - 2 && etage < ETAGE_MAX) {
        // On est arrivé à la sortie et donc on réinitialise tout mais avec l'incrémentation d'un étage.
        animT = true; // Pour l'animation de la translation
        animR = true; // Celle de la rotation
        anim = 20;
        posX = iposX; // Bien evidemment posX prend la postion initiale
        posY = iposY; // Bien evidemment posY prend la postion initiale
        etage = etage + 1; // Incrementation de étage
      } else if (posX - dirX == 1 && posY - dirY ==  -1) {
        // On est arrivé à l'entrée et donc on réinitialise tout mais avec l'incrémentation d'un étage.
        if (etage > 0) {
          animT = true; // Pour l'animation de la translation
          animR = true; // Celle de la rotation
          anim = 20;
          posX = LAB_SIZE[etage - 1] - 2; // Bien evidemment posX prend la postion avant la montée
          posY =  LAB_SIZE[etage - 1] - 2; // Bien evidemment posY prend la postion avant la montée
          etage = etage - 1; //decrementation de étage
        } else {
          posX-=dirX;
          posY-=dirY;
          anim=20;
          animT = true;
          animR = false;
        }
      } else if (lab[etage][posY-dirY][posX-dirX]!='#') {
        posX-=dirX;
        posY-=dirY;
        anim=20;
        animT = true;
        animR = false;
      }
    } else {
      posX-=dirX;
      posY-=dirY;
      if (isInLab() && (posY != 0 || posX != 1)) {
        posX += dirX;
        posY += dirY;
      } else {
        anim = 20;
        animT = false;
        animR = false;
      }
    }
  }

  if (anim==0 && keyCode==37) {
    odirX = dirX;
    odirY = dirY;
    anim = 20;
    int tmp = dirX;
    dirX=dirY;
    dirY=-tmp;
    animT = false;
    animR = true;
  }
  if (anim==0 && keyCode==39) {
    odirX = dirX;
    odirY = dirY;
    anim = 20;
    animT = false;
    animR = true;
    int tmp = dirX;
    dirX=-dirY;
    dirY=tmp;
  }
}
