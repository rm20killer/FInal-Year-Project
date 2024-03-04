﻿float SampleQuadrant(Texture2D MainTex, float4 MainTex_Size, float2 uv, int x1, int x2, int y1, int y2, float n)
{
    float luminance_sum = 0.0f;
    float luminance_sum2 = 0.0f;
    float3 col_sum =  float3(0,0,0);

    [loop]
    for (int x = x1; x <= x2; ++x) {
        [loop]
        for (int y = y1; y <= y2; ++y) {
            float3 sample = tex2D(MainTex, float4(uv + float2(x, y) / MainTex_Size.xy, 0, 0)).rgb;
            float l = dot(sample, float3(0.299f, 0.587f, 0.114f));
            luminance_sum += l;
            luminance_sum2 += l * l;
            col_sum += saturate(sample);
        }
    }

    float mean = luminance_sum / n;
    float std = abs(luminance_sum2 / n - mean * mean);

    return float4(col_sum / n, std);
}

void KuwaharaFilter_float(Texture2D MainTex, float4 MainTex_Size,float2 uv, float radius, vector offset, out float3 Out)
{
    
    #ifdef SHADERGRAPH_PREVIEW
    Out = float3(1,0,0);
    #else
    uint seed = 0;
    float Range = (radius * 2) + 1;
    int minKernelSize = floor(Range);
    int maxKernelSize = ceil(Range);
    float t = frac(Range);
    
    float windowSize = 2.0f * maxKernelSize + 1;
    int quadSize = ceil(windowSize / 2);
    int numSamples = quadSize * quadSize;

    float4 q1 = SampleQuadrant(MainTex,MainTex_Size, uv, -minKernelSize, 0, -minKernelSize, 0, numSamples);
    float4 q2 = SampleQuadrant(MainTex,MainTex_Size, uv, 0, minKernelSize, -minKernelSize, 0, numSamples);
    float4 q3 = SampleQuadrant(MainTex,MainTex_Size, uv, 0, minKernelSize, 0, minKernelSize, numSamples);
    float4 q4 = SampleQuadrant(MainTex,MainTex_Size, uv, -minKernelSize, 0, 0, minKernelSize, numSamples);


    float minstd = min(q1.a, min(q2.a, min(q3.a, q4.a)));
    int4 q = float4(q1.a, q2.a, q3.a, q4.a) == minstd;
    
    float4 result1 = 0;
    if (dot(q, 1) > 1)
        result1 = saturate(float4((q1.rgb + q2.rgb + q3.rgb + q4.rgb) / 4.0f, 1.0f));
    else
        result1 = saturate(float4(q1.rgb * q.x + q2.rgb * q.y + q3.rgb * q.z + q4.rgb * q.w, 1.0f));

    windowSize = 2.0f * maxKernelSize + 1;
    quadSize = int(ceil(windowSize / 2.0f));
    numSamples = quadSize * quadSize;

    q1 = SampleQuadrant(MainTex,MainTex_Size, uv, -minKernelSize, 0, -minKernelSize, 0, numSamples);
    q2 = SampleQuadrant(MainTex,MainTex_Size, uv, 0, minKernelSize, -minKernelSize, 0, numSamples);
    q3 = SampleQuadrant(MainTex,MainTex_Size, uv, 0, minKernelSize, 0, minKernelSize, numSamples);
    q4 = SampleQuadrant(MainTex,MainTex_Size, uv, -minKernelSize, 0, 0, minKernelSize, numSamples);
    float4 result2 = 0;
    if (dot(q, 1) > 1)
        result2 = saturate(float4((q1.rgb + q2.rgb + q3.rgb + q4.rgb) / 4.0f, 1.0f));
    else
        result2 = saturate(float4(q1.rgb * q.x + q2.rgb * q.y + q3.rgb * q.z + q4.rgb * q.w, 1.0f));

    Out = lerp(result1, result2, t);
    
    #endif
    
}



void Kuwahara_float(float3 input, float strength, float Radius, out float3 filteredColor )
{
    filteredColor = float3(0, 0, 0);
    float2 resolution = float2(1920, 1080); // assuming SCREEN_WIDTH and SCREEN_HEIGHT are defined

    int radius = int(Radius);
    float area = (2 * radius + 1) * (2 * radius + 1);

    float3 mean[4];
    float3 variance[4];

    for (int i = 0; i < 4; ++i)
    {
        mean[i] = float3(0, 0, 0);
        variance[i] = float3(0, 0, 0);
    }

    for (int y = -radius; y <= radius; ++y)
    {
        for (int x = -radius; x <= radius; ++x)
        {
            float3 sampleColor = input + float3(x * strength, y * strength, 0);

            float quadrantIndex = 0;
            if (x >= 0 && y >= 0) quadrantIndex = 0;
            else if (x < 0 && y >= 0) quadrantIndex = 1;
            else if (x >= 0 && y < 0) quadrantIndex = 2;
            else quadrantIndex = 3;

            mean[int(quadrantIndex)] += sampleColor;
            variance[int(quadrantIndex)] += sampleColor * sampleColor;
        }
    }

    for (int i = 0; i < 4; ++i)
    {
        mean[i] /= area;
        variance[i] = (variance[i] - area * mean[i] * mean[i]) / area;
    }

    float minVariance = variance[0].r + variance[0].g + variance[0].b;
    int minIndex = 0;

    for (int i = 1; i < 4; ++i)
    {
        float varianceSum = variance[i].r + variance[i].g + variance[i].b;
        if (varianceSum < minVariance)
        {
            minVariance = varianceSum;
            minIndex = i;
        }
    }

    filteredColor = mean[minIndex];
}