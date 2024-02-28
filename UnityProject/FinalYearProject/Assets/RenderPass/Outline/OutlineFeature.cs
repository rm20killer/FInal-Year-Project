using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class OutlineFeature : ScriptableRendererFeature
{
    Material compositeMaterial;
    
    [System.Serializable]
    public class OutlineSettings
    {
        public bool IsEnabled = true;
        public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRendering;
        public Shader OutlineShader;
        public float OutlineSize;
    }
    
    public OutlineSettings settings = new OutlineSettings();
    
    RTHandle renderTextureHandle;
    OutlineRenderPass renderPass;
    
    
    public override void Create()
    {
        compositeMaterial = CoreUtils.CreateEngineMaterial(settings.OutlineShader);
        compositeMaterial.SetFloat("_OutlineSize", settings.OutlineSize);
        
        renderPass = new OutlineRenderPass("OutlinePass", settings.renderPassEvent,compositeMaterial );
    }
    public override void SetupRenderPasses(ScriptableRenderer renderer, in RenderingData renderingData) {
        renderPass.Setup(renderer.cameraColorTargetHandle);

    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if (!settings.IsEnabled)
        {
            return;
        }
        renderer.EnqueuePass(renderPass);
    }
}