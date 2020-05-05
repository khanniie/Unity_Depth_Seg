using UnityEngine;
using UnityEngine.XR.ARFoundation;

public class PostEffect : MonoBehaviour
{
    
    [SerializeField] private Shader _shader;
    [SerializeField] private AROcclusionManager occlusionManager;
    private Material _material;

    void Awake()
    {
        _material = new Material(_shader);
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        // if we have an occlusion manager, we set the depth texture 
        // and the segmentation buffer (stencil) into our new material
        if(occlusionManager!=null){
            _material.SetTexture("_StencilTex",occlusionManager.humanStencilTexture);
            _material.SetTexture("_DepthTex",occlusionManager.humanDepthTexture);     
        }

        //send to be rendered
        Graphics.Blit(source, destination, _material);
    }

}