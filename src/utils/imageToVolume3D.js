import { RGBAFormat, LinearFilter, UnsignedByteType, ClampToEdgeWrapping, Data3DTexture } from 'three';

export function imageToVolume3D(
  image,
  rows,
  cols
)
{

  const depthSlices = cols * rows;

  const sliceWidth = image.width / cols;
  const sliceHeight = image.height / rows;

  const canvas = document.createElement('canvas');
  canvas.width = image.width;
  canvas.height = image.height;
  const ctx = canvas.getContext('2d');
  ctx.drawImage(image, 0, 0);

  const srcData = ctx.getImageData(0, 0, image.width, image.height).data;


  const volumeData = new Uint8Array( sliceWidth * sliceHeight * depthSlices * 4 );

 
for (let z = 0; z < depthSlices; z++) 
{

    const col = z % cols
    const row = Math.floor(z / cols)

    const startX = col * sliceWidth
    const startY = row * sliceHeight

    for (let y = 0; y < sliceHeight; y++) 
    {

        for (let x = 0; x < sliceWidth; x++) 
        {
        
            const srcX = startX + x;
            const srcY = startY + y;
            const srcIdx = (srcY * image.width + srcX) * 4;

            const dstIdx = (z * sliceWidth * sliceHeight + y * sliceWidth + x) * 4;

            volumeData[dstIdx + 0] = srcData[srcIdx + 0];
            volumeData[dstIdx + 1] = srcData[srcIdx + 1];
            volumeData[dstIdx + 2] = srcData[srcIdx + 2];
            volumeData[dstIdx + 3] = srcData[srcIdx + 3];

      }

    }

  }


  const texture3D = new Data3DTexture(
    volumeData,
    sliceWidth,
    sliceHeight,
    depthSlices
  )

  texture3D.format = RGBAFormat;
  texture3D.type = UnsignedByteType;
  texture3D.minFilter = LinearFilter;
  texture3D.magFilter = LinearFilter;
  texture3D.wrapS = ClampToEdgeWrapping;
  texture3D.wrapT = ClampToEdgeWrapping;
  texture3D.wrapR = ClampToEdgeWrapping;
  texture3D.needsUpdate = true;

  return texture3D;

}