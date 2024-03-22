using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class MoebiusRenderFeature : ScriptableRendererFeature
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
    MoebiusRenderPass MoebiusRenderPass;

    public override void Create()
    {
        compositeMaterial = CoreUtils.CreateEngineMaterial(settings.shader);
        MoebiusRenderPass = new MoebiusRenderPass(
            "MoebiusRenderPass",
            settings.WhenToInsert,
            compositeMaterial
        );
    }
        
    public override void SetupRenderPasses(ScriptableRenderer renderer, in RenderingData renderingData) {
        MoebiusRenderPass.Setup(renderer.cameraColorTargetHandle);
    }
    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (!settings.IsEnabled)
        {
            return;
        }
        renderer.EnqueuePass(MoebiusRenderPass);
    }
}
