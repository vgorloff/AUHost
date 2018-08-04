//
//  VULevelMeter.Shaders.metal
//  WLUI
//
//  Created by Volodymyr Gorlov on 20.11.15.
//	 Copyright (c) 2012 Vlad Gorlov. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ColoredNoAlphaVertex {
	float4 position [[position]];
	float3 color;
};

struct Uniforms{
	float4x4 projectionMatrix;
};

vertex ColoredNoAlphaVertex
vertex_line(const device packed_float2 *position [[ buffer(0) ]],
            const device packed_float3& color [[ buffer(1) ]],
            const device Uniforms&  uniforms [[ buffer(2) ]],
            unsigned int vid [[ vertex_id ]])
{
   float4x4 proj_Matrix = uniforms.projectionMatrix;
   ColoredNoAlphaVertex vert;
   vert.position = proj_Matrix * float4(position[vid], 0.0, 1.0);
   vert.color = color;
   return vert;
}

fragment float4
fragment_line(ColoredNoAlphaVertex vert [[stage_in]]) {
	return float4(vert.color, 1.0) ;
}
