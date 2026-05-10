const halfFigureEight = ( t ) => 
{
    
  const a = t * Math.PI
  const scale = 1.0 / (1.0 + Math.sin(a) ** 2);

  return [
    Math.cos(a) * scale,
    Math.sin(a) * Math.cos(a) * scale,
    0
  ];

}