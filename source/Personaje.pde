class Personaje extends FBox {

  Personaje(float w_, float h_) {
    super(w_, h_);
  }

  float velocidad = 1000; //para bala
  float angulo = radians(90);
  PImage nave;


  void init(float _x, float _y) {

    //Cuerpo Personaje
    nave = nave_per;
    setPosition(_x, _y);
    setRotatable(true);
    setDamping(0.8);
    setName("personaje");
    attachImage(nave);
  }

  void control(float tiempo_) {
    // Controla el movimiento del personaje y los disparos.

    // Mapeo pos de mano a proporción de ventana
    float posX = map(manoX, 0, 1, 0, width);
    float posY = map(manoY, 0, 1, 0, height);

    // Mapeo pos de mano a ratios de velocity para mover personaje
    float perX = map(manoX, 0, 1, -1, 1);
    float perY = map(manoY, 0, 1, -1, 1);

    //Ángulo personaje respecto a punto de disparo
    float dx =  posX - personaje.getX(); 
    float dy =  posY - personaje.getY();
    angulo = atan2(dy, dx);
    setRotation(angulo);

    
  if (mano_abierta) {
     // Mueve nave del personaje con velocity
     mira.attachImage(ui_cursorA);
     personaje.setVelocity(perX * 180, perY * 180);
     mira.attachImage(ui_cursorA);
     }

    /*-------------------- 
    // Control con mouse
    mira.attachImage(ui_cursorA);
    float perrX = map(mouseX, 0, width, -1, 1);
    float perrY = map(mouseY, 0, height, -1, 1);
    println(personaje.getX());
    personaje.setVelocity(perrX * 180, perrY * 180);
    ----------------------
    */

    if (mano_cerrada || mousePressed) {
      setVelocity(0, 0);
      if (tiempo_ % 10 == 0) {
        disparar();
      }
      //Mueve la mira y dispara. 
      mira.attachImage(ui_cursorB);
      float ddx =  posX - mira.getX();
      float ddy =  posY - mira.getY();
      mira.addForce(ddx * 140, ddy * 140);
      mira.setDamping(15);
    }
  }


  void disparar() {
    float factor = 0.02;
    float vx = velocidad * cos( angulo );
    float vy = velocidad * sin( angulo );

    FCircle bala = new FCircle( 5 );
    bala.setPosition( getX() + vx * factor, getY() + vy * factor);
    bala.setSensor(true);
    bala.attachImage(arma_personaje);
    bala.setName( "bala" );
    bala.adjustRotation(angulo);
    bala.setVelocity( vx, vy );
    world.add( bala );
    s_laser.play(); // Sonido disparo
  }
}
