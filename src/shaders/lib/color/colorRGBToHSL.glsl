vec3 colorRGBToHSL( vec3 color ) 
{

    float maxColor = max(max(color.r, color.g), color.b);
    float minColor = min(min(color.r, color.g), color.b);
    float delta = maxColor - minColor;
    
    float l = ( maxColor + minColor ) / 2.0;
    
    
    float s = 0.0;
    if ( delta != 0.0 ) 
    {
        s = (l < 0.5) ? delta / ( maxColor + minColor ) : delta / ( 2.0 - maxColor - minColor );
    }
    
    
    float h = 0.0;

    if ( delta != 0.0 ) 
    {
        if ( maxColor == color.r ) 
        {
            h = ( color.g - color.b ) / delta + ( color.g < color.b ? 6.0 : 0.0 );
        } else if  (maxColor == color.g ) 
        {
            h = ( color.b - color.r ) / delta + 2.0;
        } else 
        {
            h = ( color.r - color.g ) / delta + 4.0;
        }

        h /= 6.0;

    }
    
    return vec3(h, s, l);

}