// requires uv to have resolution transform
// from https://mini.gmshaders.com/p/blur-philosophy
// all copy rights to the original author
vec4 blurGaussian(  sampler2D image, vec2 uv, vec2 texel ) 
{

    float w[9];
    w[0] = 0.080497596;
    w[1] = 0.078903637;
    w[2] = 0.074308647;
    w[3] = 0.067237244;
    w[4] = 0.058453252;
    w[5] = 0.048824260;
    w[6] = 0.039182387;
    w[7] = 0.030211641;
    w[8] = 0.022381334;

   vec4 tex_sum = texture2D( image, uv ) * w[0];
    float weight_sum = w[0];

    for( int x = 1; x <=8; x++ )
    {
	
	    tex_sum += texture2D(gm_BaseTexture, v_vTexcoord + vec2(x,0) * texel) * w[x];
	    tex_sum += texture2D(gm_BaseTexture, v_vTexcoord - vec2(x,0) * texel) * w[x];
	    weight_sum += w[x]*2.0;

    }

    vec4 tex_average = tex_sum / weight_sum;

    return tex_average;
    
}