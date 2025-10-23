float xorshift( inout uint seed ) 
{
    seed ^= seed << 13u;
    seed ^= seed >> 17u;
    seed ^= seed << 5u;

    return float(seed) * (1.0 / 4294967296.0);

}

float xorshift128( inout uvec4 state ) 
{
    uint t = state.w;
    uint s = state.x;
    state.w = state.z;
    state.z = state.y;
    state.y = s;
    
    t ^= t << 11u;
    t ^= t >> 8u;
    state.x = t ^ s ^ ( s >> 19u );
    
    return float( state.x ) * ( 1.0 / 4294967296.0 );

}