﻿#ifndef SOBELOUTLINE_INCLUDED
#define SOBELOUTLINE_INCLUDED

/**
 * \brief apply a sobel edge detection to a colour
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
}
#endif