vec3 colorContrast( vec3 color, float contrast )
{

    float midPoint = pow( 0.5, 2.2 );

    return ( color - midPoint ) * contrast + midPoint;
    
}

vec3 colorContrast( vec3 color, float contrast, float threshold ) 
{
    float gray = dot( color, vec3( 0.299, 0.587, 0.114 ) );
    
    float adjustedGray = threshold + ( gray - threshold ) * contrast;
    
    adjustedGray = clamp( adjustedGray, 0.0, 1.0 );
    
    return vec3(adjustedGray);

}