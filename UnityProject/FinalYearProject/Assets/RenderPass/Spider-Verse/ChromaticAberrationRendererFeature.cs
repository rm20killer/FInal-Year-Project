using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class ChromaticAberrationRendererFeature : ScriptableRendererFeature
{
    Material compositeMaterial;

    [System.Serializable]
    public class ChromaticSettings
    {
        public bool IsEnabled = true;
        public RenderPassEvent renderPassEvent; 
        public Shader chromaticAberrationShader;
        public float intensity;
        public Vector2 offset;
        public float constrast;
        public float fallOff;
        
    }
    public ChromaticSettings settings = new ChromaticSettings();
    
    RTHandle renderTextureHandle;
    ChromaticAberrationRenderPass renderPass;

    public override void Create()
    {
        compositeMaterial = CoreUtils.CreateEngineMaterial(settings.chromaticAberrationShader);
        compositeMaterial.SetFloat("_Intensity", settings.intensity); 
        compositeMaterial.SetVector("_Offset", settings.offset); 
        compositeMaterial.SetFloat("_Constrast", settings.constrast);
        compositeMaterial.SetFloat("_FallOff", settings.fallOff);
        
        renderPass = new ChromaticAberrationRenderPass("ChromaticAberrationPass", settings.renderPassEvent,compositeMaterial );
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