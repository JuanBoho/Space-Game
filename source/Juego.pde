class Juego {

  Juego() {
  }

  int pantalla_actual = 0;
  int tiempo = 0; 
  float puntos = 0;
  boolean ui_click = false;

  void init() {
    puntos = 0;
    tiempo = 2; // var para iniciar conteo de puntos
    pantalla_actual = 1;
    world.add(personaje);
    world.add(mira);
  }

  void display() {
    // Dibuja estados según var pantalla_actual
    switch( pantalla_actual) {
    case 0:
      pantallaInicio();
      break;

    case 1:
      pantallaJuego();
      break;

    case 2:
      pantallaFin();
      break;

    default:
      texto("Error!", width * 0.5, height * 0.5, 70, false);
      println("Error en asignación de pantalla. pantalla_actual = ", pantalla_actual);
      juego.ui_click = false;
      break;
    }
  }


  //--------------------------------PANTALLAS DE JUEGO------------------------------------------

  void pantallaInicio() {
    //Pantalla de Inicio: Muestra instrucciones, créditos y opción iniciar Juego.

    push();
    background(fondo_inicio);

    //Botón de inicio
    texto("INICIAR", width/2, height * 0.60, 20, true);

    pop();
    juego.ui_click = false;
  }


  void pantallaJuego() {
    // Pantalla del juego

    background(fondo_juego);

    personaje.control(tiempo);
    world.step();
    world.draw();
    borrarElementos();
    atraer();

    //Creo enemigos
    if ( tiempo % 360 == 0 ) {
      Enemigo enemigo = new Enemigo();
      enemigo.init("A");
      enemigo.dibuja();
      enemigo.setPosition( random(22, width-25), random(-25, 0));
      world.add(enemigo);
    }

    if ( tiempo % 660 == 0 ) {
      Enemigo enemigo = new Enemigo();
      enemigo.init("B");
      enemigo.dibuja();
      enemigo.setPosition( random(22, width-25), random(-25, 0));
      world.add(enemigo);
    }

    if ( tiempo % 860 == 0 ) {
      Obstaculo obs_A = new Obstaculo(80, 80, "A");
      obs_A.init(random(25, width-25), random(-25, 100));
      world.add(obs_A);
    }

    if ( tiempo % 1260 == 0 ) {
      Obstaculo obs_B = new Obstaculo(160, 160, "B");
      obs_B.init(random(25, width-25), random(-25, 100));
      world.add(obs_B);
    }


    actualiza_obs();
    tiempo += 1;
    puntaje();
    juego.ui_click = false;
  }


  void pantallaFin() {
    //Muestra pantalla de fin con el puntaje alcanzado y opción reinicio

    push();
    background(fondo_fin);

    texto("Puntaje", width * 0.50, height * 0.35, 15, false); //imprime texto

    texto(str(round(puntos)), width * 0.50, height * 0.60, 100, false);

    texto("REINICIO", width / 2, height * 0.80, 20, true);
    pop();

    juego.ui_click = false;
  }

  //-------------------------------- FUNCIONES JUEGO ------------------------------------------

  void reinicio() {
    //Reinicia juego

    ArrayList <FBody> cuerpos_juego = world.getBodies();
    juego.ui_click = false;
    //Borro los objetos del juego
    if (cuerpos_juego.size() > 0) {
      for (FBody cuerpo : cuerpos_juego) {
        world.remove(cuerpo);
      }
    }

    juego.init(); // Reinicio juego
  }

  void puntaje() {
    //Control de puntos

    puntos += tiempo * 0.0002;
    push();
    stroke(230, 230, 30);
    strokeWeight(2);
    noFill();
    rect(10, 10, 150, 50, 10);
    pop();
    texto(" " + round(puntos), width * 0.10, height * 0.07, 15, false);
  }

  //----------------INTERFAZ-------------------------

  void texto(String texto_, float posx_, float posy_, int tamano_, boolean hover_) {
    // Crea texto (texto, posición, medidas del contenedor, tamañofuente, y parametro hover_) 
    // hover_ = true : cambia estética del texto y cursor
    textAlign(CENTER);
    fill(230, 230, 30);


    if (hover_) {
      if (dist(mouseX, mouseY, posx_, posy_) < 50) {
        fill(230, 30, 30);
        cursor(HAND);
        if (juego.ui_click) {
          s_inicio.play(); //Sonido Inicio
          juego.reinicio();
        }
      } else {
        cursor(ARROW);
      }
    }

    textSize(tamano_);
    text(texto_, posx_, posy_);
  }
}
