PShape momie;
PShape oeilGauche;
PShape oeilGauche1;
PShape oeilDroit;
PShape oeilDroit1;
PShape corps;
PShape tete;
PShape brasDroit;
PShape brasGauche;
PShape mainGauche;
PShape mainDroite;
PImage textureBandage;


void setup(){
  size(900, 1300, P3D); 
  textureBandage = loadImage("bandage.jpg");

  momie = createShape(GROUP);
  
  // Création du corps
  corps = createShape();
  corps.beginShape(QUAD_STRIP); // Commence à dessiner des quadrilatères en bande
  corps.noStroke(); // On désactive les contours des formes pour un rendu plus propre
  for (int i=0; i<64; i++){ // On parcourt les sections verticales du corps
    for (int j=-5; j<=5; j++){ // On parcourt les sections horizontales du corps
      // Angles pour les sommets du QUAD_TRIP
      float b = j/5.0*PI; // On définit les coordonnées x et y des sommets du quad_strip qui se trouvent à l'avant
      float b1 = (j+1)/5.0*PI; // On définit les coordonnées x et y des sommets du quad_strip qui se trouvent à l'arrière de ceux définis par b (j+1) permet de faire cette modfication 
      
      //On définit deux rayons pour la forme tronconique 
      //Grace au deux rayons la fonction vertex peut connecter les sommets de la section actuelle et de la section suivante en créant des quadrilatères, ce qui donnent l'apparence d'un cylindre.
      float R = 8+1*cos((i-32)*PI/32.0);
      corps.fill(127+127*noise(i+j), 63+191*noise(i+j), 31+223*noise(i+j)); // Pour définir la couleur du tron pour chaque section
      corps.vertex(R*cos(b), R*sin(b), i); //Sommets des points avant qui seront reliés avec vertex
      R = 8+1*cos((i-31)*PI/32.0); // Rayon du corps
      corps.vertex(R*cos(b1), R*sin(b1), (i+1)); // Sommet des points arrieres qui seront reliés puis dessinés avec la fonction vertex
    }
  }
  corps.endShape();  
  momie.addChild(corps);
  
  
  // Création de la tête
  tete = createShape();
  tete.beginShape(QUAD_STRIP);  // Pour dessiner des quadrilatères en bande pour la tête
  tete.noStroke();
  for(int i = 64; i<84; i++){ // Parcours les sections verticales de la tête
    for (int j=-5; j<=5; j++){ // Parcours les sections horizontales de la tête
      float b = j/5.0*PI; // On définit les angles pour les sommets du QUAD_STRIP
      float b1 = (j+1)/5.0*PI;
      tete.fill(130+130*noise(i+j), 62+190*noise(i+j), 25+225*noise(i+j)); // Pour la couleur de la tete
      float R = 10+2*cos((i-54)*PI/10.0); // Cela sert à former les bandelettes et donner la forme
      //On en définit deux pour que vertex puisse connecter la section actuelle de la suivante
      tete.vertex(R*cos(b), R*sin(b), i);
      R = 10+2*cos((i-53)*PI/10.0);
      tete.vertex(R*cos(b1), R*sin(b1), (i+1));
    }
  }
  tete.endShape();
  momie.addChild(tete);
  
  
  
  //Création des yeux
  oeilDroit = createShape(SPHERE,2.5);
  oeilDroit.setStroke(color(255));
  oeilDroit1 = createShape(SPHERE,1);
  oeilDroit1.setStroke(color(0)); // Pour l'épaisseur des traits
  oeilDroit.translate(5, 10+2*cos((80-54)*PI/10.0), 80); // On positionne le globe occulaire blanc au bon endroit
  oeilDroit1.translate(5, 10+2*cos((80-54)*PI/10.0)+2, 80+0.5); // On positionne l'intérieur de l'oeil noir au bon endroit
  momie.addChild(oeilDroit); // On ajoute l'oeil droit   au groupe de la momie
  momie.addChild(oeilDroit1); 
  
  // Pareil que l'oeil droit
  oeilGauche = createShape(SPHERE,2.5);
  oeilGauche.setStroke(color(255));
  oeilGauche1 = createShape(SPHERE,1);
  oeilGauche1.setStroke(color(0));
  oeilGauche.translate(-5, 10+2*cos((80-54)*PI/10.0), 80);
  oeilGauche1.translate(-5, 10+2*cos((80-54)*PI/10.0)+2, 80+0.5);
  momie.addChild(oeilGauche);
  momie.addChild(oeilGauche1); 
  
  
  
  //Partie pour le bras gauche
  brasGauche=createShape();
  brasGauche.beginShape(QUAD_STRIP); // Commence à dessiner des quadrilatères en bande pour le bras gauche
  brasGauche.noStroke();
  for(int i = 0; i<84/3; i++){ // On parcourt les sections verticales du bras gauche
    for(int j = -5; j<=5; j++){ // On parcourt les sections horizontales du bras gauche
      float A = j/5.0*PI; // Définit les angles pour les sommets du QUAD_STRIP
      float A1 = (j+1)/5.0*PI;
      float r = 4+1*cos((32)*PI/32.0); // Rayon du bras
      brasGauche.fill(127+127*noise(i+j), 63+191*noise(i+j), 31+223*noise(i+j)); // Couleur
      brasGauche.vertex(8+r*sin(A), 8+i, 60+r*cos(A)); // On crée les sommets pour les QUAD_STRIP
      brasGauche.vertex(8+r*sin(A1), 8+(i+1), 60+r*cos(A1));
    }
  }
  brasGauche.endShape();
  momie.addChild(brasGauche);
  
  
  
  //Partie pour le bras droit
  brasDroit = createShape();
  brasDroit.beginShape(QUAD_STRIP);
  brasDroit.noStroke();
  for(int i = 0; i<84/3; i++){
    for(int j = -5; j<=5; j++){ 
      float A = j/5.0*PI;
      float A1 = (j+1)/5.0*PI;
      float r = 4+1*cos((32)*PI/32.0);
      brasDroit.fill(127+127*noise(i+j), 63+191*noise(i+j), 31+223*noise(i+j));
      brasDroit.vertex(-8+r*sin(A), 8+i, 60+r*cos(A));
      brasDroit.vertex(-8+r*sin(A1), 8+(i+1), 60+r*cos(A1));
    }
  }
  brasDroit.endShape();
  momie.addChild(brasDroit);
  
 
  
  //Partie pour la main droite
  mainDroite = loadShape("hand2.obj"); // On charge le modèle de la main avec loadShape() à partir d'un fichier .obj
  mainDroite.setTexture(textureBandage);
  mainDroite.rotateX(PI/2); // On tourne la main sur l'axe X pour la placer dans le bon sens
  mainDroite.rotateZ(PI); // On tourne la main sur l'axe Y pour la placer dans le bon sens
  mainDroite.translate(-4,30,57); // On la déplace au bon endroit
  momie.addChild(mainDroite);
  
  
  // Partie pour la main gauche
  mainGauche = loadShape("hand2.obj");
  mainGauche.setTexture(textureBandage);
  mainGauche.rotateX(PI/2);
  mainGauche.rotateZ(PI);
  mainGauche.translate(12, 30, 57);
  momie.addChild(mainGauche);

} 



void draw() {
  translate(width / 2, height / 2, 700); // On place la momie au centre de la fenêtre de dessin
  rotateX(PI / 2.5); // Fait pivoter la momie autour de l'axe X
  //rotateX(PI/3 + 0.01 * frameCount % TWO_PI/6);
  background(0, 0, 0);
  shape(mainDroite, 0, 0); // Dessine les mains droite et gauche de la momie séparément
  shape(mainGauche, 0, 0);
  shape(momie, 0, 0);  // Dessine le reste de la momie (corps, tête, yeux, bras)
}
