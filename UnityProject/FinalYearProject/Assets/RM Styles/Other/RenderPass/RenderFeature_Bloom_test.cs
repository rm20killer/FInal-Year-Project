using UnityEngine;
using UnityEngine.Rendering.Universal;
public class RenderFeature_Bloom_test : ScriptableRendererFeature
{
    [System.Serializable]
    public struct BlooomSettings
    {
        public RenderPassEvent Event;
        public ComputeShader bloomShader;
        public float threshold;
        public float iterations;
    }
    
    public BlooomSettings settings = new BlooomSettings();
    BloomPass bloomPass;
    
    public override void Create()
    {
        bloomPass = new BloomPass(settings.Event, settings.bloomShader, settings.threshold, settings.iterations);
        // bloomPass.renderPassEvent = settings.Event;
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        if(settings.bloomShader == null)
        {
            Debug.LogError("Missing Bloom Shader");
            return;
        }
        
        bloomPass.Setup(renderer.cameraColorTarget);
        renderer.EnqueuePass(bloomPass);
    }
}