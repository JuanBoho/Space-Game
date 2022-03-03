/* -------------
 #TODO
 gameplay:
 2. Imágenes para lasercol (escudo, expl per, explo asteroide)
 5. mejorar control: amortiguar mapping y luego damping(?
 
 ----------
 */


void atraer() {
  //Atrae los enemigos a la posición del personaje
  ArrayList <FBody> cuerpos = world.getBodies();
  for (FBody c : cuerpos ) {
    if ( c.getName().equals("obstaculo") ) {
      float dx = personaje.getX() - c.getX();
      float dy = personaje.getY() - c.getY();
      c.addForce(dx * 0.4, dy * 0.4);
    }
    if ( c.getName().equals("obstaculo_dos") ) {
      float dx = personaje.getX() - c.getX();
      float dy = personaje.getY() - c.getY();
      c.addForce(dx * 0.6, dy * 0.6);
    }
    if ( c.getName().equals("enemigo") ) {
      float dx = personaje.getX() - c.getX();
      float dy = personaje.getY() - c.getY();
      Enemigo tempEnemigo = (Enemigo) c; 
      float ratio = (tempEnemigo.impactos > 1) ? 1.5 : 2.0; // Si el enemigo pierde sus escudos, se acerca más rápido.
      c.addForce(dx * ratio, dy * ratio);
      c.addForce(dx * ratio, dy * ratio);
    }
  }
}


void actualiza_obs() {
  //Actualiza obs
  ArrayList <FBody> obstaculos = world.getBodies();
  for (FBody obs : obstaculos ) {
    if ( obs.getName().equals( "obstaculo") ) {
      obs.setVelocity(obs.getVelocityX(), 80);
    } else if ( obs.getName().equals( "obstaculo_dos") ) {
      obs.setVelocity(obs.getVelocityX(), 40);
    }
  }
}


void borrarElementos() {

  ArrayList <FBody> cuerpos = world.getBodies();
  for ( FBody este : cuerpos ) {
    String nombre = este.getName();
    if ( nombre != null ) {
      //Enemigo
      if ( nombre.equals("enemigo") ) {
        Enemigo tenem = (Enemigo) este;
        if (tenem.muerto) {
          world.remove(tenem);
        }
      }
      //balas
      if ( nombre.equals("bala") ) {
        if ( este.getX() > width + 10 || este.getX() < -10 || este.getY() > height + 10 || este.getY() < -10) {
          world.remove( este );
        }
      }
      if ( nombre.equals("balita") ) {
        float d = dist( personaje.getX(), personaje.getY(), este.getX(), este.getY() );
        if ( d > 180) {
          world.remove( este );
        }
      }
      //obstaculos
      if ( nombre.equals("obstaculo") || nombre.equals("obstaculo_dos") ) {
        if ( este.getX() > width + 120 || este.getX() < -120 || este.getY() > height + 120 || este.getY() < -120) {
          world.remove( este );
        }
      }
    }
  }
}


void laserCol(FBody laser_, FBody cuerpo_) {
  //Anima disparos
  float lsrX = laser_.getX();
  float lsrY = laser_.getY();

  switch(cuerpo_.getName()) {
  case "enem_cuerpo":
    lsr_anim(lsrX, lsrY, true, 6);
    break;

  case "enem_arma":
    lsr_anim(lsrX, lsrY, false, 3);
    break;
  }

  world.remove(laser_);
}


void lsr_anim( float x_, float y_, boolean inv, int num) {
  PImage prov_bal =  (inv) ? arma_reb : arma_reb_inv; // imagen del laser al rebotar (distinto en escudos y enemigos)

  for (int i = 0; i < num; i++) {
    FCircle bal = new FCircle(num);
    bal.setPosition(x_ + (i * 5), y_ + (i * 5) );
    bal.addImpulse(random(-150, 150), random(-300, 300));
    bal.setAngularVelocity(5);
    bal.setName("balita");
    bal.attachImage(prov_bal);
    world.add(bal);
  }
}
