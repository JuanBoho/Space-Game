/*
-----------
 SPACE 3021
 -----------
 Juan Bohórquez, 2021.
 */

import oscP5.*;
import fisica.*;
import processing.sound.*;

Juego juego;
FWorld world;
Personaje personaje;
FCircle mira;

int tiempo;
float puntos;

PImage fondo_inicio, fondo_juego, fondo_fin;
PImage nave_per;
PImage escudo1, escudo1_dam, escudo2, escudo2_dam;
PImage enemigoA, enemigoA_dam, enemigoB, enemigoB_dam;
PImage arma_personaje, arma_reb, arma_reb_inv;
PImage ui_cursorA, ui_cursorB;

SoundFile s_laser, s_inicio, s_fin;

OscP5 oscP5;

float k_mano, manoX, manoY;
boolean mano_abierta, mano_cerrada;

PFont fuente;

void preLoad() { 
  /* Pre-carga de sonido e imagénes */
  //imgs
  nave_per = loadImage("personaje.png");
  arma_personaje = loadImage("arma_personaje.png");
  arma_reb = loadImage("arma_reb.png");
  arma_reb_inv = loadImage("arma_reb.png");
  arma_reb_inv.filter(INVERT);

  enemigoA = loadImage("enemA.png");
  enemigoA_dam = loadImage("enemA_dam.png");

  enemigoB= loadImage("enemB.png");
  enemigoB_dam = loadImage("enemB_dam.png");

  escudo1 = loadImage("enem_escudo1.png");
  escudo1_dam = loadImage("enem_escudo1_dam.png");
  escudo2 = loadImage("enem_escudo2.png");
  escudo2_dam = loadImage("enem_escudo2_dam.png");

  fondo_inicio = loadImage("pantalla_inicio.jpg");
  fondo_juego = loadImage("juego_fondo.png");
  fondo_fin = loadImage("pantalla_fin.jpg");
  ui_cursorA = loadImage("star1.png");
  ui_cursorB = loadImage("star2.png");

  // Sonidos
  s_laser = new SoundFile(this, "laser_.wav");
  s_inicio = new SoundFile(this, "iniciojuego_.wav");
  s_fin = new SoundFile(this, "lose_.wav");

  //Fuente
  fuente = createFont("kenvector_future.ttf", 100);
}

void setup() {
  size(1200, 600);

  preLoad();
  oscP5 = new OscP5(this, 12000);

  //Juego
  Fisica.init(this);
  world = new FWorld();
  world.setEdges(-30, -30, width + 30, height + 30);
  world.setGravity(0, 0);
  juego = new Juego();

  // Personaje
  personaje = new Personaje(40, 40);
  personaje.init(width/2, height/2);
  world.add(personaje);

  // Mira : Es objeto de física para control de mov.
  mira = new FCircle(40);
  mira.setPosition(width / 2, height * 0.25 );
  mira.setDamping(0.8);
  mira.setName("mira");
  mira.setGrabbable(false);
  mira.setSensor(true);
  world.add(mira);

  textFont(fuente);
}


void draw() {
  juego.display();
}

void mouseReleased() {
  // click para botones de interfaz (Inicio/reinicio)
  juego.ui_click = true;
}

void oscEvent(OscMessage m) {
  /* Recibo data de wekinator por osc*/

  if (m.addrPattern().equals("/wek/outputs")) {
    k_mano = m.get(0).floatValue(); // predicción de clasif. (gesto) de la mano
    if (k_mano == 1) {
      mano_abierta = true;
      mano_cerrada = false;
    }
    if (k_mano == 2) {
      mano_abierta = false;
      mano_cerrada = true;
    }
    // Valores en X e Y entre 0 y 1 para la posición de la mano en la ventana del handPoseOSC
    manoX = m.get(1).floatValue(); // 0: máx posición a la izquierda, 1: máx posición a la derecha
    manoY = m.get(2).floatValue(); // 0: máx posición arriba, 1: máx posición abajo
  } else {
    println("entra otro mensaje");
  }
}
