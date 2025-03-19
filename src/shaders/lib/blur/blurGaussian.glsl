vec4 blurGaussian(sampler2D tex, vec2 uv, vec2 resolution, float sigma) 
{

    vec4 color = vec4(0.0);
    float weightSum = 0.0;
    float kernel[5] = float[](0.06136, 0.24477, 0.38774, 0.24477, 0.06136);

    for (int i = -2; i <= 2; i++) 
    {

        for (int j = -2; j <= 2; j++) 
        {

            vec2 offset = vec2(i, j) / resolution;
            color += texture2D(tex, uv + offset) * kernel[i + 2] * kernel[j + 2];
            weightSum += kernel[i + 2] * kernel[j + 2];

        }

    }

    return color / weightSum;
    
}