
#ifndef GAUSSIANBLUR_INCLUDED
#define GAUSSIANBLUR_INCLUDED
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



/**
 * \brief blur a colour using a gaussian blur algorithm
 * \param input the input colour to blur
 * \param strength strength of the blur
 * \param Radius radius of the blur
 * \param blur the resulting blurred colour
 */
void gaussianblur_float(float3 input, float strength, float Radius, out float3 blur)
{
    float weights[5] = { 0.1216f, 0.2716f, 0.3838f, 0.2716f, 0.1216f };
    float3 SampleBlur = float3(0.0, 0.0, 0.0);

    for (int i = -2; i <= 2; ++i)
    {
        float offset = i * Radius * strength; 
        float3 sampleColour = input + float3(offset, 0, 0);
        SampleBlur += sampleColour * weights[i + 2];
    }

    blur = SampleBlur;
}

void gaussianblur1_float(float input, float strength, float Radius, out float blur)
{
    const float weights[5] = { 0.1216f, 0.2716f, 0.3838f, 0.2716f, 0.1216f };
    float sample_blur = 0.0;

    for (int i = -2; i <= 2; ++i)
    {
        const float offset = i * Radius * strength; 
        float3 sample_colour = input + offset;
        sample_blur  += sample_colour * weights[i + 2];
    }

    blur = sample_blur;
}


#endif 