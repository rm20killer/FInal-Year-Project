#ifdef LIGHTING_CEL_SHADER
#define LIGHTING_CEL_SHADER

#ifndef SHADERGRAPH_PREVIEW
struct SurfaceVariales {
    float3 Normal; 
    float Smoothness;
    float3 viewDir;
    float Shininess;
};

float3 CalcCelShading(light light, SurfaceVariales surface)
{
    float3 diffuse = saturate(dot(normal, light.direction));
    float3 halfDir = SafeNormalize(light.direction + surface.view);
    float specular = pow(saturate(dot(surface.Normal, halfDir), s.Shininess) * diffuse * surface.Smoothness
    return light.Colour * (diffuse + specular);
}

void LightingCelShaded_float(float3 Normal, float Smoothness, float3 view out float3 colour)
{
#if defined(SHADERGRAPH_PREVIEW)
    Direction = normalize(float3(0.5f, 0.5f, 0.25f));
    colour = float3(1.0f, 1.0f, 1.0f);
    DistanceAtten = 1.0f;
    ShadowAtten = 1.0f;
#else
    SurfaceVariales surface;
    surface.Smoothness = Smoothness;
    surface.Normal = Normal;
    surface.viewDir = SafeNormalize(view);
    surface.Shininess = exp2(10.0f * surface.Smoothness+1.0f);


    Light light = GetMainLight();
    colour = CalcCelShading(light, surface);
#endif
}

#endif