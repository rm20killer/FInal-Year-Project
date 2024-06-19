using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering.Universal;
using UnityEngine.UI;


[ExecuteAlways]
public class RenderFeatureScript : MonoBehaviour
{
    [System.Serializable]
    public struct RenderFeatureToggle
    {
        public ScriptableRendererFeature feature;
        public bool isEnabled;
    }
    
    [SerializeField]
    private List<RenderFeatureToggle> renderFeatures = new List<RenderFeatureToggle>();
    [SerializeField]
    private UniversalRenderPipelineAsset pipelineAsset;
 
    public ScriptableRendererFeature moebiusFeature;
    public ScriptableRendererFeature LineArtFeature;
    public ScriptableRendererFeature ColourSwapFeature;
    public ScriptableRendererFeature SpiderVerseFeature;
    public ScriptableRendererFeature KuwaharaFeature;
    private void Update()
    {
        foreach (RenderFeatureToggle toggleObj in renderFeatures)
        {
            toggleObj.feature.SetActive(toggleObj.isEnabled);
        }
    }
    
    public bool GetFeatureEnabled(ScriptableRendererFeature feature)
    {
        foreach (RenderFeatureToggle toggleObj in renderFeatures)
        {
            if (toggleObj.feature == feature)
            {
                return toggleObj.isEnabled;
            }
        }
        return false;
    }
    
    public void MoebiusEnabled(bool enableds)
    {
        ActiveFeature(moebiusFeature, enableds);
    }
    
    public void MoebiusEnabled(Toggle toggle)
    {
        ActiveFeature(moebiusFeature, toggle.isOn);
    }
    public void LineArtEnable(bool enableds)
    {
        ActiveFeature(LineArtFeature, enableds);
    }
    
    public void LineArtEnable(Toggle toggle)
    {
        ActiveFeature(LineArtFeature, toggle.isOn);
    }
    
    public void ColourSwapEnable(bool enableds)
    {
        ActiveFeature(ColourSwapFeature, enableds);
    }
    
    public void ColourSwapEnable(Toggle toggle)
    {
        ActiveFeature(ColourSwapFeature, toggle.isOn);
    }
    
    public void SpiderVerseEnable(bool enableds)
    {
        ActiveFeature(SpiderVerseFeature, enableds);
    }
    
    public void SpiderVerseEnable(Toggle toggle)
    {
        ActiveFeature(SpiderVerseFeature, toggle.isOn);
    }
    
    public void KuwaharaEnable(bool enableds)
    {
        // Debug.Log("KuwaharaEnable");
        ActiveFeature(KuwaharaFeature, enableds);
    }
    
    public void KuwaharaEnable(Toggle toggle)
    {
        ActiveFeature(KuwaharaFeature, toggle.isOn);
    }
    
    public void ActiveFeature(ScriptableRendererFeature feature, bool enabled)
    {
        for (int i = 0; i < renderFeatures.Count; i++)
        {
            if (renderFeatures[i].feature == feature)
            {
                RenderFeatureToggle toggleObj = renderFeatures[i];
                toggleObj.isEnabled = enabled;
                renderFeatures[i] = toggleObj; // Update the original struct in the list
                return;
            }
        }
        renderFeatures.Add(new RenderFeatureToggle { feature = feature, isEnabled = enabled });
    }
}