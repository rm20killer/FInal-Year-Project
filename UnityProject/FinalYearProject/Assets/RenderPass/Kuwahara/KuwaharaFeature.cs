using System.ComponentModel;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class KuwaharaFeature : ScriptableRendererFeature
{
    Material compositeMaterial;
    [System.Serializable]
    public class MyFeatureSettings
    {
        public bool IsEnabled = true;
        public RenderPassEvent WhenToInsert = RenderPassEvent.AfterRendering;
        public Shader shader;
        
        public float radius;
        public float strength;
        [Description ("The number of steps to take when calculating the colour Set to 0 for no colour change")] public float colour_Steps;
    }
    
    public MyFeatureSettings settings = new MyFeatureSettings();

    RTHandle renderTextureHandle;
    ImpactEffectRenderPass impactEffectRenderPass;
    private static readonly int Radius = Shader.PropertyToID("_Radius");
    private static readonly int Strength = Shader.PropertyToID("_Strength");
    private static readonly int ColourSteps = Shader.PropertyToID("_ColourSteps");

    public override void Create()
    {
        compositeMaterial = CoreUtils.CreateEngineMaterial(settings.shader);
        compositeMaterial.SetFloat(Radius, settings.radius);
        compositeMaterial.SetFloat(Strength, settings.strength);
        compositeMaterial.SetFloat(ColourSteps, settings.colour_Steps);
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
