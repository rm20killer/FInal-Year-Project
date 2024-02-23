
/**
 * \brief https://en.wikipedia.org/wiki/Gaussian_function 
 * \param x distance from the center
 * \param strength srength of the blur
 * \return the weight of the blur with the given distance and strength
 */
float Gaussian(float x, float strength)
{
    //find the weight of the blur using a curve
    return 1.0 / (sqrt(2.0 * 3.1415926 * strength * strength))
        * exp(-(x * x) / (2.0 * strength * strength));
}

//! Too slow for real-time use
void gaussianblur_float(float3 input, float strength, out float3 blur)
{
    //initialize the blur and total weight
    blur = float3(0.0, 0.0, 0.0);
    float totalWeight = 0.0;
    
    float radius = strength * 3.0;

    //loop through a square of pixels around the center 
    for (float y = -radius; y <= radius; y++)
    {
        for (float x = -radius; x <= radius; x++)
        {
            //calculate the weight of the blur
            float2 offset = float2(x, y);
            float weight = Gaussian(distance(float2(0, 0), offset), radius / 3.0);

            //add the weighted input to the blur
            blur = blur + input * weight;
            totalWeight = totalWeight + weight;
        }
    }

    //normalize the blur
    blur = blur/ totalWeight;
    
}
