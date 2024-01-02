
/**
 * \brief Because you can't change gradient colours outside the shader graph, this code is a workaround to sample a gradient.
 * By allowing you to specify the gradient colours and locations, then using lerp to get the colour at a specific input value depending on the location.
 * shitty workaround but it better than having specific gradients for all shaders.
 * \param input location to sample the gradient at
 * \param colour1 
 * \param colour2 
 * \param colour3 
 * \param colour4 
 * \param colour5 
 * \param location1 location of colour1
 * \param location2 location of colour2
 * \param location3 location of colour3
 * \param location4 location of colour4
 * \param location5 location of colour5
 * \param Out the output colour
 */
void sampleGradient_float(float input,
    float4 colour1, float4 colour2, float4 colour3, float4 colour4, float4 colour5,
    float location1, float location2, float location3, float location4, float location5,
    out float4 Out)
{
    float4 output = 0;
    if(input < location1)
    {
        output = colour1;
        return;
    }
    if(input < location2)
    {
        float t = (input - location1) / (location2 - location1);
        output = lerp(colour1, colour2, t);
    }
    else if(input < location3)
    {
        float t = (input - location2) / (location3 - location2);
        output = lerp(colour2, colour3, t);
    }
    else if(input < location4)
    {
        float t = (input - location3) / (location4 - location3);
        output = lerp(colour3, colour4, t);
    }
    else if(input < location5)
    {
        float t = (input - location4) / (location5 - location4);
        output = lerp(colour4, colour5, t);
    }
    else
    {
        output = colour5;
    }

    Out = output;
}