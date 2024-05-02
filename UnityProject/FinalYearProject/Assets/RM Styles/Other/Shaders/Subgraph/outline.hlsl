#ifndef SOBEL_INCLUDED
#define SOBEL_INCLUDED


//https://en.wikipedia.org/wiki/Sobel_operator
static float sobelYMatrix[9] = {
    1,2,1,
    0,0,0,
    -1,-2,-1
};

static float sobelXMatrix[9] = {
    1,0,-1,
    2,0,-2,
    1,0,-1
};


static float2 sobelSamplePoints[9] = {
    float2(-1,1),float2(0,1),float2(1,1),
    float2(-1,0),float2(0,0),float2(1,1),
    float2(-1,-1),float2(0,-1),float2(1,-1),
};


/**
 * \brief Use a sobel edge detection on the depth of a scene to get the edges
 * \param uv The uv coordinate to sample the depth
 * \param thickness the thickness of the sample
 * \param edge the resulting edge value
 */
void DepthSobel_float(float2 uv, float thickness, out float edge)
{
    float2 sobel = float2(0,0);

    //Loop through the sobel matrix and sample the depth
    [unroll] for (int i = 0; i < 9; i++)
    {
        // float2 samplePoint = sobelSamplePoints[i];
        // float2 UV = uv + sobelSamplePoints[i] * thickness
        float depth = SHADERGRAPH_SAMPLE_SCENE_DEPTH(uv + sobelSamplePoints[i] * thickness);
		sobel += depth * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    //Get the length of the sobel edge
    edge = length(sobel);
};

/**
 * \brief Use a sobel edge detection on the normal of a scene to get the edges
 * \param uv The uv coordinate to sample the normal
 * \param thickness the thickness of the sample
 * \param edge the resulting edge value
 */
void NormalSobel_float(float2 uv, float thickness, out float edge)
{
    float2 sobel = float2(0,0);

    //Loop through the sobel matrix and sample the depth
    [unroll] for (int i = 0; i < 9; i++)
    {
        float normal = SHADERGRAPH_SAMPLE_SCENE_NORMAL(uv + sobelSamplePoints[i] * thickness);
        sobel += normal * float2(sobelXMatrix[i], sobelYMatrix[i]);
    }
    //Get the length of the sobel edge
    edge = length(sobel);
};




/**
 * old function use DepthSobel_float and NormalSobel_float instead for better results
 * \brief Use a sobel edge detection on a texture to get the edges
 * \param input colour to sample
 * \param OutlineThreshold the threshold to determine if the edge is an outline
 * \param OutlineWidth the width of the outline
 * \param edge the resulting edge value
 */
void sobeloutline_float(float4 input, float OutlineThreshold, float OutlineWidth, out float3 edge)
{
    const float gx[9] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};
    const float gy[9] = {-1, -2, -1, 0, 0, 0, 1, 2, 1};

    float3x3 pixel_matrix;
    for (int row = -1; row <= 1; ++row)
    {
        for (int col = -1; col <= 1; ++col)
        {
            float offset = sqrt(col * col + row * row) * OutlineWidth;
            float4 neighbor_colour = input + float4(offset, offset, offset, 0.0);
            pixel_matrix[row + 1][col + 1] = neighbor_colour.rgb;
        }
    }


    float gx1 = 0.0;
    float gy1 = 0.0;
    for (int i = 0; i < 3; ++i)
    {
        for (int j = 0; j < 3; ++j)
        {
            gx1 += pixel_matrix[i][j] * gx[i * 3 + j];
            gy1 += pixel_matrix[i][j] * gy[i * 3 + j];
        }
    }

    float gradientMagnitude = sqrt(gx1 * gx1 + gy1 * gy1);
    edge = step(OutlineThreshold, gradientMagnitude);
};
#endif