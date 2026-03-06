// gets the world uv relative to an orthographic camera, use render texture to blend with terrain
// from minionsart https://www.patreon.com/posts/shader-graph-for-81985104

vec2 getWorldUV(
    vec3 worldPosition,
    vec3 orthoCamPos, 
    float orthoCamSize
) 
{

    vec2 uv = worldPosition.xz - orthoCamPos.xz;
    uv = uv / (orthoCamSize * 2.0);
    uv += 0.5;

    return uv;

}