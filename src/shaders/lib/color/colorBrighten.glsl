vec3 colorBrighten( vec3 color, float factor, int type )
{
    vec3 colorRtn = vec3( 1.0 );

    switch( type )
    {
        case 0: // expotential
            colorRtn = 1.0 - exp( -color * factor );
        break;

        case 1: // power requires factor be less than 1.0
            colorRtn = pow( color, ( factor >= 1.0 ? vec3( 0.9 ) : vec3( factor ) ) );
        break;
        
        case 2: // parabolic
            colorRtn = color + ( 1.0 - color ) * color * factor;
        break;

        default: // exponential
            colorRtn = 1.0 - exp( -color * factor );
        break;

    }

    return colorRtn;
    
}