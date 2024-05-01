# library of shaders for a game engine to achieve a stylized look

Created by: Roshan Manojkumar - p2657789

## File Structure
```
RM Styles
 - [Art styles]
    - Materials
        - .shadergraph
        - .mat
    - RenderPass
        - .shadergraph
        - .mat
    - Textures
        - Substance_mats
            - .sbsar
        - .png

```
All art styles are have a similar file structure.

For anything with a material, there will be a `.shadergraph` file and a `.mat` file. The `.shadergraph` file is the shader graph that is used to create the material. The `.mat` file is the material that is created from the shader graph.

For anything with a render pass, there will be a `.shadergraph` file and a `.mat` file. The `.shadergraph` file is the shader graph that is used to create the render pass. The `.mat` file is the material that is created from the shader graph.

## How to use

### Object Materials

1. Create a new material with the shader graph.
2. Modify the material to your liking.
3. Apply the material to the object.
4. Do this for all objects that you want to have the same material.

### Render Pass
1. create a new material with the shader graph.
2. Go to the render pipeline asset normally located in `Assets/Settings/URP-HighFidelity-Renderer.asset`.
3. Go to the renderer feature list and add the a new renderer feature called "Full Screen Pass Render Feature"
4. Give it name if you want to.
5. Assign the material to the pass material slot.
6. In the requirements section make sure "Depth", "Normal", "Color" are checked.
7. Edit the material to your liking.
8. Make sure the render pass is enabled in the renderer feature list.
