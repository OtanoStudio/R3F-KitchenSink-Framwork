// generate a random grid
vec4 uvRandomGrid( 
    vec2 uv, vec2 gridSize 
)
{

vec2 grid = uv * gridSize; // creates a grid of size x & y of the vec2 size
vec2 gridId = floor( grid ); // creates a vec2 of the column and row of the grid
vec3 gridUV = fract( grid ); // creates the uv for each cell

return vec4( gridId, gridUV ); // return vec4 so x,y = grid column/row & z,w = cell uv[0,1]

}

/*
example usage

vec4 grid = uvRandomGrid( uv, vec2( 10.0 ) );
float randomCell = noiseRandom( grid.xy );

*/