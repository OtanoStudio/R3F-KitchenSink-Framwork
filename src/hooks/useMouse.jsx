import { useState, useEffect } from "react"


export default function useMouse()
{

    const [mousePosition, setMousePosition] = useState( { x: 0, y: 0 } )

    const updateMousePosition = ( e ) =>
    {

        setMousePosition( { x: e.clientX, y: e.clientY } )
 
    }


    useEffect( () =>
    {
        window.addEventListener( 'pointermove', updateMousePosition )

        return () =>
        {
            window.removeEventListener( 'pointermove', updateMousePosition )
        }

    },[] )

    return mousePosition

}