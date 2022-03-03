
class Enemigo extends FCompound {

  String tipoEnemigo;
  PImage forma, escudo;
  int impactos;
  boolean muerto;

  Enemigo() {
    super();
  }

  void init(String tipo_) {
    setName("enemigo");
    tipoEnemigo = tipo_;
    muerto = false;
  }

  void dibuja() { // Dibuja el tipo de enemigo
    if (tipoEnemigo.equals("A")) {
      enemA();
    }
    if (tipoEnemigo.equals("B")) {
      enemB();
    }
  }

  void enemA() {
    //Crea cuerpo y escudo de enemigo A

    PImage forma = enemigoA;
    PImage escudo = escudo1;

    // Cuerpo Enemigo
    FBox cuerpoA = new FBox(40, 40);
    cuerpoA.attachImage(forma);
    cuerpoA.setVelocity(0, 100);
    cuerpoA.setName("enem_cuerpo");
    cuerpoA.setParent(this);

    // Arma enemigo
    FCircle arma_A = new FCircle(120);
    arma_A.setPosition(cuerpoA.getX(), cuerpoA.getY());
    arma_A.setVelocity(0, 10);
    arma_A.setName("enem_arma");
    arma_A.attachImage(escudo);
    arma_A.setParent(this);
    arma_A.setSensor(true); // Escudos son sensor por conveniencia para evaluar colisiones


    addBody(arma_A);
    addBody(cuerpoA);
    setGrabbable(false);
    impactos = 4;
  }

  void enemB() {
    //Crea cuerpo y escudo de enemigo B

    // Imágenes
    PImage forma = enemigoB;
    PImage escudo = escudo2;

    // Cuerpo Enemigo
    FBox cuerpoB = new FBox(50, 50);
    cuerpoB.attachImage(forma);
    cuerpoB.setDamping(0.1);
    cuerpoB.setName("enem_cuerpo");
    cuerpoB.setParent(this);

    // Arma Enemigo
    FCircle arma_B = new FCircle(120);
    arma_B.setPosition(cuerpoB.getX(), cuerpoB.getY());
    arma_B.setVelocity(0, 10);
    arma_B.setAngularVelocity(15);
    arma_B.setDamping(0.1);
    arma_B.setName("enem_arma");
    arma_B.attachImage(escudo);
    arma_B.setParent(this);


    addBody(arma_B);
    addBody(cuerpoB);
    setName("enemigo");
    setGrabbable(false);
    impactos = 6;
  }

  void evaluaEstado() {
    // Modifica el estado y apariencia del enemigo según el número de impactos (disparos) que recibe. 
    
    FBody arma = (FBody) this.getBodies().get(0);
    FBody cuerpo = (FBody) this.getBodies().get(1);

    if (!this.muerto) {
      switch(impactos) {
      case 0:
        muerto = true;
        println("muerto");
        break;
      case 1:
        if (tipoEnemigo.equals("A")) cuerpo.attachImage(enemigoA_dam);
        if (tipoEnemigo.equals("B")) cuerpo.attachImage(enemigoB_dam);
        break;
      case 2:
        // Hace invisible el escudo como solución alternativa. (borrarlo causaba muchos problemas al evaluar colisiones)
        arma.dettachImage();
        arma.setNoStroke();
        arma.setNoFill();
        break;
      case 3:
        if (tipoEnemigo.equals("A")) arma.attachImage(escudo1_dam);
        if (tipoEnemigo.equals("B")) arma.attachImage(escudo1_dam);
        println("3");
        break;
      case 4:
        if (tipoEnemigo.equals("B")) arma.attachImage(escudo1);
        break;
      case 5:
        if (tipoEnemigo.equals("B")) arma.attachImage(escudo2_dam);
        println("5");
        break;
      default:
        break;
      }
    }
  }

  String tipoEnem() {
    return tipoEnemigo;
  }
}
