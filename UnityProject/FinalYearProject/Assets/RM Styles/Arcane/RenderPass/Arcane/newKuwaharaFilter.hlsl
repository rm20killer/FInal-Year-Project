
void Kuwahara_float(float2 uv, float2 texelSize, float radius, float edgeSharpness, out float3 colour)
{

    int regionHalfSize = floor(radius); 
    float3 tempColour = float3(0, 0, 0);
    float totalVariance = 0.0;
    
    // Sobel Gradient Calculation
    const float3 sobelX[3] = { 
        float3(-1.0, 0.0, 1.0), 
        float3(-2.0, 0.0, 2.0), 
        float3(-1.0, 0.0, 1.0)  
    };

    const float3 sobelY[3] = { 
        float3(-1.0, -2.0, -1.0), 
        float3(0.0, 0.0, 0.0), 
        float3(1.0, 2.0, 1.0)  
    };
    

    float gx = 0.0; 
    float gy = 0.0;
    
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {

            float3 TextureSample = SHADERGRAPH_SAMPLE_SCENE_COLOR(uv + float2(x, y) * texelSize);
            float sample = TextureSample.r;
            gx += sample * sobelX[x + 1][y + 1];
            gy += sample * sobelY[x + 1][y + 1];
        }
    }

    float2 gradient = normalize(float2(gx, gy)); 
    float2 perpendicularDir = normalize(float2(-gradient.y, gradient.x));

    colour = float3(perpendicularDir.x, perpendicularDir.y, 0.0);
    for (int i = -regionHalfSize; i <= regionHalfSize; i++) {
        for (int y = -regionHalfSize; y <= regionHalfSize; y++) {
    
            float2 tlUV = uv + perpendicularDir * texelSize; //topLeft
            float2 trUV = uv + perpendicularDir * texelSize; //topRight
            float2 blUV = uv + perpendicularDir * texelSize; //bottomLeft
            float2 brUV = uv + perpendicularDir * texelSize; //bottomRight
            
    
            float3 tl = SHADERGRAPH_SAMPLE_SCENE_COLOR(tlUV); 
            float3 tr = SHADERGRAPH_SAMPLE_SCENE_COLOR(trUV);
            float3 bl = SHADERGRAPH_SAMPLE_SCENE_COLOR(blUV);
            float3 br = SHADERGRAPH_SAMPLE_SCENE_COLOR(brUV);
            
            float3 mean = (tl + tr + bl + br) * 0.25; 
            float3 diff = float3(abs(mean.r - tl.r), abs(mean.g - tl.g), abs(mean.b - tl.b));
            float variance = dot(diff, diff) * 0.25;          
            
            if (variance < totalVariance) {
                totalVariance = variance;
                tempColour = mean;
            }
        }
    }

    
    colour = float3 (tempColour.r, tempColour.g, tempColour.b);
}



#define Kuwahara2
#ifdef Kuwahara2
void Kuwahara2_float(UnityTexture2D tex, float2 uv, float radius, float edgeSharpness, out float3 OutColour)
{
    radius = 4;
    float3 mean[4] = {
        float3( 0, 0, 0 ),
        float3( 0, 0, 0 ),
        float3( 0, 0, 0 ),
        float3( 0, 0, 0 )
    };

    float3 sigma[4] = {
        float3( 0, 0, 0 ),
        float3( 0, 0, 0 ),
        float3( 0, 0, 0 ),
        float3( 0, 0, 0 )
    };
    float2 start[4] = { { -radius * .5, -radius * .5},{ -radius * .5, 0 },{ 0, -radius * .5},{ 0, 0 } };
    float2 pos;
    float3 col;
    for (int k = 0; k < 4; k++) {
        for (int i = 0; i <= radius; i++) {
            for (int j = 0; j <= radius; j++) {
                pos = float2(i, j) + start[k];
                col = tex2D(tex,uv.xy + uint2(pos.x, pos.y));
                mean[k] += col;
                sigma[k] += col * col;
            }
        }
    }
    float sigma2;

    float n = pow(radius + 1, 2);
    float3 colour = tex2D(tex,uv.xy);
    float min = 1;

    for (int l = 0; l < 4; l++) {
        mean[l] /= n;
        sigma[l] = abs(sigma[l] / n - mean[l] * mean[l]);
        sigma2 = sigma[l].r + sigma[l].g + sigma[l].b;

        if (sigma2 < min) {
            min = sigma2;
            colour.rgb = mean[l].rgb;
        }
    }
    
    OutColour = colour;
}

#endif



// void Kuwahara2_float(UnityTexture2D tex, float2 uv, float radius, float edgeSharpness, out float3 OutColour)
// {
//     float2 texSize = tex.texelSize.xy;
//     float3 result = float3(0,0,0);
//
//     // int windowWidth = ceil(radius * 2);
//     // int windowHeight = ceil(radius * 2);
//     int windowWidth = 2;
//     int windowHeight = 2;
//
//     float2 dirX = float2(1.0, 0.0) * texSize;
//     float2 dirY = float2(0.0, 1.0) * texSize;
//     for (int y = -windowHeight / 2; y <= windowHeight / 2; y++) 
//     {
//         for (int x = -windowWidth / 2; x <= windowWidth / 2; x++) 
//         {
//             float2 offset = float2(x, y);
//
//             float4 topLeft = tex2D(tex, uv + offset * dirX - offset * dirY);
//             float4 topRight = tex2D(tex, uv + offset * dirX + offset * dirY);
//             float4 bottomLeft = tex2D(tex, uv - offset * dirX - offset * dirY);
//             float4 bottomRight = tex2D(tex, uv - offset * dirX + offset * dirY);
//             
//             float3 meanTL = (topLeft.rgb) / 2.0; 
//             float3 meanTR = (topRight.rgb) / 2.0;
//             float3 meanBL = (bottomLeft.rgb) / 2.0;
//             float3 meanBR = (bottomRight.rgb) / 2.0;
//
//             //https://en.wikipedia.org/wiki/Variance
//             float varianceTL = dot(topLeft.rgb - meanTL.rgb, topLeft.rgb - meanTL.rgb);
//             float varianceTR = dot(topRight.rgb - meanTR.rgb, topRight.rgb - meanTR.rgb);
//             float varianceBL = dot(bottomLeft.rgb - meanBL.rgb, bottomLeft.rgb - meanBL.rgb);
//             float varianceBR = dot(bottomRight.rgb - meanBR.rgb, bottomRight.rgb - meanBR.rgb);
//
//             float minVariance = min(min(varianceTL, varianceTR), min(varianceBL, varianceBR)); 
//             float3 selectedMean;
//
//             if (minVariance == varianceTL)
//             {
//                 selectedMean = meanTL;
//             }  
//             else if (minVariance == varianceTR)
//             {
//                 selectedMean = meanTR;
//             } 
//             else if (minVariance == varianceBL)
//             {
//                 selectedMean = meanBL;
//             }  
//             else
//             {
//                 selectedMean = meanBR;
//             }
//
//             result = selectedMean;
//         }
//     }
//
//     OutColour = result.rgb;
// }