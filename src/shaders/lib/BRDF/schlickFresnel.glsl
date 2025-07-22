float schlickFresnel(
    float ndotv
) 
{

    const float clearcoat = 0.04;

    return clearcoat + ( 1.0 - clearcoat ) * pow( 1.0 - ndotv, 5.0 );

}

float schlickFresnel(
    float f0,
    float ndotv
) 
{

    const float clearcoat = f0;

    return clearcoat + ( 1.0 - clearcoat ) * pow( 1.0 - ndotv, 5.0 );

}

float schlickFresnelSpecular(
    float hdotv
) 
{

    return 0.04 + 0.96 * pow( 1.0 - hdotv, 5.0 );

}

float schlickFresnelSpecular(
    float hdotv,
    float f0
) 
{

    return f0 + 0.96 * pow( 1.0 - hdotv, 5.0 );

}

float schlickFresnelFast(
    float hdotv
) 
{

    float x = 1.0 - hdotv;
    float x2 = x * x;

    return 0.04 + 0.96 * x2 * x2 * x;

}

float schlickFresnelFast(
    float hdotv,
    float f0
) 
{

    float x = 1.0 - hdotv;
    float x2 = x * x;

    return f0 + 0.96 * x2 * x2 * x;

}

float schlickFresnelSG(
    float ndotv
) 
{

    return 0.04 + 0.96 * exp2( ( -5.55473 * ndotv - 6.98316 ) * ndotv );

}

float schlickFresnelSG(
    float ndotv,
    float f0
) 
{

    return f0 + 0.96 * exp2( ( -5.55473 * ndotv - 6.98316 ) * ndotv );

}