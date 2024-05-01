using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class spiderverseRenderPass : ScriptableRenderPass
{
    private string profilerTag;
    
    Material CompositeMaterial;
    RTHandle cameraColorTargetIdent;
    RenderTargetHandle tempTexture;

    private RenderTargetIdentifier source; 
    private RenderTargetIdentifier destination;
    private int tempRTId = Shader.PropertyToID("_SpiderverseTempRT");

    public spiderverseRenderPass(string profilerTag,
        RenderPassEvent renderPassEvent, Material compositeMaterial)
    {
        this.profilerTag = profilerTag;
        this.renderPassEvent = renderPassEvent;
        CompositeMaterial = compositeMaterial;
    }

    public void Setup(RTHandle cameraColorTargetIdent)
    {
        this.cameraColorTargetIdent = cameraColorTargetIdent;
    }

    public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
    {
        cmd.GetTemporaryRT(tempTexture.id, cameraTextureDescriptor);
    }


    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        var cmd = CommandBufferPool.Get(profilerTag);
        using (new ProfilingSample(cmd, profilerTag))
        {
            Render(cmd, ref renderingData);
        }

        context.ExecuteCommandBuffer(cmd);
        cmd.Clear();

        CommandBufferPool.Release(cmd);
    }

    private void Render(CommandBuffer cmd, ref RenderingData renderingData)
    {
        cmd.Blit(cameraColorTargetIdent, tempTexture.Identifier(), CompositeMaterial, 0);
        cmd.Blit(tempTexture.Identifier(), cameraColorTargetIdent);
    }

    public override void FrameCleanup(CommandBuffer cmd)
    {
        cmd.ReleaseTemporaryRT(tempRTId);
    }
}