import React from 'react'

export default function GrassUI( props ) 
{
  return (
    <section className='grassUI-container'>
      <nav className='error-nav'>
        {/* logo */}
        <img src="./images/os-logo.svg" alt="white blackletter O with pixelated edged and a underscore to it's bottom right" />
      </nav>
     <div className='errorArea'>
        <svg>
      <filter
        id="glass"
        x="-50%"
        y="-50%"
        width="200%"
        height="200%"
        primitiveUnits="objectBoundingBox"
      >
        <feImage
          
          x="-50%"
          y="-50%"
          width="200%"
          height="200%"
          result="map"
        />
        <feGaussianBlur in="SourceGraphic" stdDeviation="0.02" result="blur" />
        <feDisplacementMap
          id="disp"
          in="blur"
          in2="map"
          scale="0.8"
          xChannelSelector="R"
          yChannelSelector="G"
        ></feDisplacementMap>
      </filter>
    </svg>
        <p><span className='span-not-found'>Page Not Found</span></p>
        <h1 className='grassUI-title'>404</h1>
     </div>
        
    </section>
  )
}
