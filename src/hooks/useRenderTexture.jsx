import { useFrame } from '@react-three/fiber'
import { useEffect, useRef } from 'react'
import { useFBO } from '@react-three/drei'
// hook to get a shared render target texture and register the mesh into the render loop for visiblity
// includes depth texture too

export function useRenderTexture(
    reference, // ref for element
    depth = false, // include depth texture or not
    hide = false, // hide reference during 1st render

) 
{
    const frameBuffer = useFBO( { depth: depth } )
    const refList = useRef( new Set() )
    const fboTextures = useRef( { scene: null, depth: null } ) 
    

    

    useEffect( () =>
    {

        refList.current.add( { mRef: reference, hide: hide } ) // add reference to the list of references

    }, [ reference, hide ] )

    useFrame( ( { scene, camera, gl } ) =>
    {
        
        refList.current.forEach( ( r ) =>
        {
            // hide only the ref that need to be hidden
            if( r.hide )
            {
                r.mRef.current.visible = false

                //console.log( r )
            }

        })

        // render to the render target
        gl.setRenderTarget( frameBuffer )
        gl.render( scene, camera )

        console.log( frameBuffer.texture )

        // assign textures
        fboTextures.current.scene = frameBuffer.texture
        fboTextures.current.depth = depth ? frameBuffer.depthTexture : null

        refList.current.forEach( ( r ) =>
        {
            // reveal the hidden refs
            if( r.hide )
            {
                r.mRef.current.visible = true
            }

        })

        gl.setRenderTarget( null )

        //console.log( fboTextures )

    })

  return (
    fboTextures.current
  )
}
