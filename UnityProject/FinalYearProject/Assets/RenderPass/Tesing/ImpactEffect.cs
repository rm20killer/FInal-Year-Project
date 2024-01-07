using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ImpactEffect : ScriptableRendererFeature
{
    Material compositeMaterial;
    [System.Serializable]
    public class MyFeatureSettings
    {
        public bool IsEnabled = true;
        public RenderPassEvent WhenToInsert = RenderPassEvent.AfterRendering;
        public Shader shader;
    }
    
    public MyFeatureSettings settings = new MyFeatureSettings();

    RTHandle renderTextureHandle;
    ImpactEffectRenderPass impactEffectRenderPass;

    public override void Create()
    {
        compositeMaterial = CoreUtils.CreateEngineMaterial(settings.shader);
        impactEffectRenderPass = new ImpactEffectRenderPass(
            "ImpactEffectRenderPass",
            settings.WhenToInsert,
            compositeMaterial
        );
    }
    
    public override void SetupRenderPasses(ScriptableRenderer renderer, in RenderingData renderingData) {
        impactEffectRenderPass.Setup(renderer.cameraColorTargetHandle);

    }
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (!settings.IsEnabled)
        {
            return;
        }
        renderer.EnqueuePass(impactEffectRenderPass);
        
        renderer.EnqueuePass(impactEffectRenderPass);
    }
}
