class Obstaculo extends FBox
{
  String tipo;
    
  Obstaculo(float _w, float _h, String _tipo)
  {
    super(_w, _h);
    tipo = _tipo;
  }
  
  void init(float _x, float _y)
  {
    if (tipo.equals("A"))
    {
      setDamping(0.01);
      setGrabbable(false);
      setDensity(14);
      setVelocity(random(80,120),80);
      setName("obstaculo");
      attachImage(loadImage("meteorito.png"));
    }
    else if (tipo.equals("B"))
    {
      setVelocity(random(40,80), 40);
      setDensity(24);
      setDamping(0.1);
      setGrabbable(false);
      setName("obstaculo_dos");
      setStatic(false);
      attachImage(loadImage("planeta.png"));
      
    }
    setPosition(_x, _y);
    setRotatable(true);
  }
  
  void actualizar(){
    setVelocity(0,80);      
  }
}
