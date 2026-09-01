bool intersectAABB(
    vec3 rayOrigin, 
    vec3 rayDir, 
    vec3 boxMin, 
    vec3 boxMax, 
    out float tNear, 
    out float tFar
) 
{

    vec3 invDir = 1.0 / rayDir;
    vec3 t0 = (boxMin - rayOrigin) * invDir;
    vec3 t1 = (boxMax - rayOrigin) * invDir;

    vec3 tmin = min(t0, t1);
    vec3 tmax = max(t0, t1);

    tNear = max(max(tmin.x, tmin.y), tmin.z);
    tFar = min(min(tmax.x, tmax.y), tmax.z);

    return tFar >= max(tNear, 0.0);

}