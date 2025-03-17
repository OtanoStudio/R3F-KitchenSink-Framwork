
vec3 colorRGBToOKLCH( vec3 rgb ) 
{
   
    vec3 linearRGB = vec3(
        rgb.r <= 0.04045 ? rgb.r / 12.92 : pow((rgb.r + 0.055) / 1.055, 2.4),
        rgb.g <= 0.04045 ? rgb.g / 12.92 : pow((rgb.g + 0.055) / 1.055, 2.4),
        rgb.b <= 0.04045 ? rgb.b / 12.92 : pow((rgb.b + 0.055) / 1.055, 2.4)
    );
    
    
    mat3 rgb_to_xyz = mat3(
        0.4124, 0.3576, 0.1805,
        0.2126, 0.7152, 0.0722,
        0.0193, 0.1192, 0.9505
    );

    vec3 xyz = linearRGB * rgb_to_xyz;
    
    mat3 xyz_to_lms = mat3(
        0.8189330101, 0.3618667424, -0.1288597137,
        0.0329845436, 0.9293118715, 0.0361456387,
        0.0482003018, 0.2643662691, 0.6338517070
    );

    vec3 lms = xyz * xyz_to_lms;
    
    
    vec3 lmsP = vec3(
        lms.x > 0.0 ? pow(lms.x, 0.3333333333333333) : -pow(-lms.x, 0.3333333333333333),
        lms.y > 0.0 ? pow(lms.y, 0.3333333333333333) : -pow(-lms.y, 0.3333333333333333),
        lms.z > 0.0 ? pow(lms.z, 0.3333333333333333) : -pow(-lms.z, 0.3333333333333333)
    );
    

    mat3 lmsp_to_oklab = mat3(
        0.2104542553, 0.7936177850, -0.0040720468,
        1.9779984951, -2.4285922050, 0.4505937099,
        0.0259040371, 0.7827717662, -0.8086757660
    );

    vec3 oklab = lmsP * lmsp_to_oklab;
    
    float L = oklab.x;
    float C = sqrt(oklab.y * oklab.y + oklab.z * oklab.z);
    float h = atan(oklab.z, oklab.y);
    
    h = h * 180.0 / 3.1415926535897932384626433832795;
    if (h < 0.0) h += 360.0;
    
    return vec3(L, C, h);
    
}