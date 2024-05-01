using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class SpiderverseRendererFeature : ScriptableRendererFeature
{
    Material compositeMaterial;
    [System.Serializable]
    public class MyFeatureSettings
    {
        public bool IsEnabled = true;
        public RenderPassEvent WhenToInsert = RenderPassEvent.AfterRendering;
        public Shader shader;
        
        [Header("Chromatic Aberration")]
        public float intensity;
        public Vector2 offset;
        public float constrast;
        public float fallOff;
        
        [Header( "Outline Detection")]
        public float OutlineSize;
    }
    
    public MyFeatureSettings settings = new MyFeatureSettings();

    RTHandle renderTextureHandle;
    spiderverseRenderPass spiderverseRenderPass;

    public override void Create()
    {
        compositeMaterial = CoreUtils.CreateEngineMaterial(settings.shader);
        spiderverseRenderPass = new spiderverseRenderPass(
            "SpiderverseRenderPass",
            settings.WhenToInsert,
            compositeMaterial
        );
    }
        
    public override void SetupRenderPasses(ScriptableRenderer renderer, in RenderingData renderingData) {
        spiderverseRenderPass.Setup(renderer.cameraColorTargetHandle);
    }
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (!settings.IsEnabled)
        {
            return;
        }
        renderer.EnqueuePass(spiderverseRenderPass);
    }
}