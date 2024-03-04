// float PI = 3.14159265359f;
//
// float gaussian(float strength, float pos) {
//     return (1.0f / sqrt(2.0f * PI * strength * strength)) * exp(-(pos * pos) / (2.0f * strength * strength));
// }
float3 gaussianblur(float3 input, float strength, float Radius)
{
    float weights[5] = { 0.1216f, 0.2716f, 0.3838f, 0.2716f, 0.1216f };
    float3 SampleBlur = float3(0.0, 0.0, 0.0);

    for (int i = -2; i <= 2; ++i)
    {
        float offset = i * Radius * strength; 
        float3 sampleColour = input + float3(offset, 0, 0);
        SampleBlur += sampleColour * weights[i + 2];
    }

    return SampleBlur;
}


#ifndef Kuwahara_INCLUDED
#define Kuwahara_INCLUDED


void Kuwahara_float(float3 input, float strength, float Radius, float ColourSteps, out float3 blur )
{
    float weights[5] = { 0.1f, 0.2f, 0.4f, 0.2f, 0.1f };
    float3 SampleBlur = float3(0.0, 0.0, 0.0);
    float2 blurDirection = normalize(float2(0.5, 1.0)); 

    for (int i = -2; i <= 2; ++i)
    {
        float offset = i * Radius * strength; 
        float2 sampleOffset = offset * blurDirection; 
        float3 sampleColour = input + float3(sampleOffset, 0); 
        SampleBlur += sampleColour * weights[i + 2];
    }

    // float3 pass1 = gaussianblur(input, 0.5, 2);
    // float3 pass2 = gaussianblur(input, 0.5, 1);
    // float GaussianMix = lerp( pass1, pass2, 0.6);
    //mix GaussianMix with SampleBlur
    // blur = lerp(SampleBlur, GaussianMix, 0.1);
    blur = SampleBlur;
    // blur = GaussianMix;

    int colourSteps = int(ColourSteps);
    if (ColourSteps > 0)
    {
        float3 posterized = floor(blur * colourSteps) / colourSteps;
        blur = posterized;
    }
}

#endif 