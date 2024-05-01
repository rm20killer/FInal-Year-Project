void Shadowmask_half(float2 lightmapUV, out half4 Shadowmask)
{
    float4 lightmapScaleOffset;
    #ifdef SHADERGRAPH_PREVIEW
        Shadowmask = half4(1,1,1,1);
    #else
        // lightmapUV.xy = lightmapUV.xy * lightmapScaleOffset.xy + lightmapScaleOffset.xw;
        Shadowmask = SAMPLE_SHADOWMASK(lightmapUV);
    #endif
}
