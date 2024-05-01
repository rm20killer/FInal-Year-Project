using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class BloomPass : ScriptableRenderPass
{
    public ComputeShader bloomShader;
    float threshold;
    float iterations;
    string profilerTag = "BloomPass";
    RenderTargetIdentifier cameraTex;
    RenderTextureDescriptor CameraSettings;
    RenderTextureDescriptor temp;
    RTHandle tempIDHandle;
    public BloomPass(RenderPassEvent renderPassEvent, ComputeShader bloomShader, float threshold, float iterations)
    {
        this.renderPassEvent = renderPassEvent;
        this.bloomShader = bloomShader;
        this.threshold = threshold;
        this.iterations = iterations;
        tempIDHandle = RTHandles.Alloc(cameraTex, "TempHandler_BloomPass" );
        CameraSettings = new RenderTextureDescriptor();       

    }
    
    public void Setup(RenderTargetIdentifier cameraTex)
    {
        this.cameraTex = cameraTex;
    }
    
    public override void Configure(CommandBuffer cmd, RenderTextureDescriptor cameraTextureDescriptor)
    {
        CameraSettings = cameraTextureDescriptor;
        // CameraSettings.enableRandomWrite = true;
    }

    public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
    {
        
        int thresholdkernel = bloomShader.FindKernel("ThresholdStep");
        CommandBuffer cmd = CommandBufferPool.Get(profilerTag);
        
        cmd.GetTemporaryRT(tempIDHandle.GetInstanceID(), CameraSettings);
        CameraSettings.height /= 2;
        CameraSettings.width /= 2;
        cmd.SetComputeTextureParam(bloomShader, thresholdkernel, "Source", cameraTex);
        cmd.SetComputeTextureParam(bloomShader, thresholdkernel, "Result", tempIDHandle);
        
        cmd.SetComputeIntParam(bloomShader, "width", CameraSettings.width);
        cmd.SetComputeIntParam(bloomShader, "height", CameraSettings.height);

        
        cmd.DispatchCompute(bloomShader, thresholdkernel, CameraSettings.width / 8, CameraSettings.height / 8, 1);
        cmd.Blit(tempIDHandle, cameraTex);
        
        
        cmd.ReleaseTemporaryRT(tempIDHandle.GetInstanceID());
        context.ExecuteCommandBuffer(cmd);
        CommandBufferPool.Release(cmd);
        
    }
}
