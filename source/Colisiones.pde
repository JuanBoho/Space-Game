//------------------------------- COLISIONES -------------------------------------------

// 1. Evalúa si hay colisión entre dos cuerpos, con nombres. (ej de clase)
boolean contacto( FContact contact, String cuerpoA, String cuerpoB ) {

  boolean colisionan = false;
  FBody uno = contact.getBody1();
  FBody dos = contact.getBody2();
  String nombreA = uno.getName();
  String nombreB = dos.getName();

  if ( nombreA != null && nombreB != null ) {

    if ( 
      ( cuerpoA.equals( nombreA ) && cuerpoB.equals( nombreB ) ) ||
      ( cuerpoB.equals( nombreA ) && cuerpoA.equals( nombreB ) )  
      ) {
      colisionan = true;
    }
  }
  return colisionan;
}

// 2. Evalúa el fin del juego : colisión del personaje con otros cuerpos del mundo
boolean evalfin (FBody cuerpo) {
  boolean juego_fin = false;

  if ( cuerpo.getName().equals("enem_arma") ) { // si hay colisión con arma (sensor), considerarla solo si el escudo está activo (# impactos > 2)
    Enemigo enemTemp = (Enemigo) cuerpo.getParent(); // Devuelve objeto FCompound para evaluar impactos restantes.
    if ( enemTemp.impactos > 2 ) {
      juego_fin = true;
    }
  }

  if ( cuerpo.getName().equals("enem_cuerpo") || // Si colisiona con el cuerp del enemigo u obstacúlos.
    cuerpo.getName().equals("obstaculo") ||
    cuerpo.getName().equals("obstaculo_dos") ) {

    juego_fin = true;
  }
  return juego_fin;
}

// 3. Contact Started
void contactStarted( FContact colision ) {

  /******************************* CAUSAN FIN DE JUEGO **********************************/
  FBody otro = null;
  if (colision.getBody1() == personaje) {
    
    otro = colision.getBody2();
    
    if ( evalfin(otro) ) {
      s_fin.play(); //Sonido Fin de juego
      juego.pantalla_actual = 2; // pantalla fin del juego
      println("pierde con " + otro.getName());
    }
    
  } else if (colision.getBody2() == personaje) {
    
    otro = colision.getBody1();

    if ( evalfin(otro) ) {
      s_fin.play();
      juego.pantalla_actual = 2;
      println("pierde con " + otro.getName());
    }
  }

  /********************************** DISPAROS ***************************************/

  // Bala - EnemigoCuerpo
  if ( contacto(colision, "bala", "enem_cuerpo") ) {

    FBody uno = colision.getBody1();
    FBody dos = colision.getBody2();

    if ( uno.getName().equals("enem_cuerpo") && dos.getName().equals("bala") ) {
      Enemigo enemTemp = (Enemigo) uno.getParent(); //Devuelve objeto FCompound para evaluar impactos restantes.
      enemTemp.impactos -= 1;
      enemTemp.evaluaEstado(); // Evalúa estado enemigo según # de impactos.
      laserCol(dos, uno); // evalua tipo de laser correspondiente a colisión y lo dibuja
    }

    if ( uno.getName().equals("bala") && dos.getName().equals("enem_cuerpo") ) {
      Enemigo enemTemp = (Enemigo) dos.getParent();
      enemTemp.impactos -= 1;
      enemTemp.evaluaEstado(); 
      laserCol(uno, dos);
    }
  }

  // Bala - EnemigoArma
  if ( contacto(colision, "bala", "enem_arma") ) {
    FBody uno = colision.getBody1();
    FBody dos = colision.getBody2();

    if ( uno.getName().equals("enem_arma") && dos.getName().equals("bala") ) {
      Enemigo enemTemp = (Enemigo) uno.getParent();
      if ( enemTemp.impactos > 1) {
        enemTemp.impactos -= 1;
        enemTemp.evaluaEstado();
        laserCol(dos, uno);
      }
    }

    if ( uno.getName().equals("bala") && dos.getName().equals("enem_arma") ) {
      Enemigo enemTemp = (Enemigo) dos.getParent();
      if ( enemTemp.impactos > 1) {
        enemTemp.impactos -= 1;
        enemTemp.evaluaEstado();
        laserCol(uno, dos);
      }
    }
  }

  // Bala - Obstáculo
  if ( contacto(colision, "bala", "obstaculo") ) {
    FBody uno = colision.getBody1();
    FBody dos = colision.getBody2();

    lsr_anim(uno.getX(), uno.getY(), true, 4); // Anima laser en colisión

    world.remove(uno);
    world.remove(dos);
  }

  //-----------------Bala - obstáculo_dos--------------------------
  if ( contacto(colision, "bala", "obstaculo_dos") ) {
    FBody dos = colision.getBody2();
    world.remove(dos);
  }

  /******************************* CAUSAN REACCIONES FÍSICAS **********************************/

  // Obstáculo - Enemigo
  if ( contacto(colision, "obstaculo", "enem_arma") || contacto(colision, "obstaculo", "enem_cuerpo") ) {
    FBody uno = colision.getBody1();
    FBody dos = colision.getBody2();

    if ( uno.getName().equals("enem_arma") || dos.getName().equals("enem_arma") ) {
      Enemigo enemTemp = (Enemigo) uno.getParent();
      enemTemp.muerto = true;
      //world.remove(enemTemp);
    }

    if ( dos.getName().equals("enem_cuerpo") || dos.getName().equals("enem_cuerpo") ) {
      Enemigo enemTemp = (Enemigo) dos.getParent();
      enemTemp.muerto = true;
      //world.remove(enemTemp);
    }
  }
}
