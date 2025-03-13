float remap(float value, float min1, float max1, float min2, float max2) 
{

  return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
  
}

vec2 remap(vec2 value, vec2 min1, vec2 max1, vec2 min2, vec2 max2) 
{

    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);

}

vec3 remap(vec3 value, vec3 min1, vec3 max1, vec3 min2, vec3 max2) 
{

    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);

}

vec4 remap(vec4 value, vec4 min1, vec4 max1, vec4 min2, vec4 max2) 
{

    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);

}

mat2 remap(mat2 value, mat2 min1, mat2 max1, mat2 min2, mat2 max2) 
{

    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);

}

mat3 remap(mat3 value, mat3 min1, mat3 max1, mat3 min2, mat3 max2) 
{

    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);

}

mat4 remap(mat4 value, mat4 min1, mat4 max1, mat4 min2, mat4 max2) 
{

    return min2 + (value - min1) * (max2 - min2) / (max1 - min1);
    
}