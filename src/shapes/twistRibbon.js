import { Vector4 } from "three";

export const twistRibbon = ( t ) => 
{

    const y = ( t - 0.5 ) * 20.0; 

    const x = Math.sin( t * Math.PI ) * 4.0;

    const z = ( 1.0 - Math.sin( t * Math.PI ) ) * -5.0;

    const tilt = Math.cos( t * Math.PI ) * 0.8;

    return new Vector4( x, y, z, tilt );

};