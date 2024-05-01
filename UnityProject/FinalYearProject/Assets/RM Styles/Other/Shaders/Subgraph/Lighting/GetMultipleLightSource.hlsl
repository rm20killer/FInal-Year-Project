void GetMultipleLightSource_float(float3 SpecColor, half Smoothness, float3 WorldPosition, float3 WorldNormal, float3 WorldView,
    out float3 Diffuse, out float3 Specular)
{
    Diffuse = 0;
    Specular = 0;

    #ifndef SHADERGRAPH_PREVIEW
        Smoothness = exp2(10 * Smoothness + 1);
        WorldNormal = normalize(WorldNormal);
        WorldView = SafeNormalize(WorldView);
        int pixelLightCount = GetAdditionalLightsCount();
        for (int i = 0; i < pixelLightCount; ++i)
        {
            Light light = GetAdditionalLight(i, WorldPosition);
            float3 attenuatedLightColor = light.color * (light.distanceAttenuation * light.shadowAttenuation);
            diffuseColor += LightingLambert(attenuatedLightColor, light.direction, WorldNormal);
            specularColor += LightingSpecular(attenuatedLightColor, light.direction, WorldNormal, WorldView, float4(SpecColor, 0), Smoothness);
        }
    #endif

    Diffuse = diffuseColor;
    Specular = specularColor;
}