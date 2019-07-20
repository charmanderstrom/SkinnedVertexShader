#version 440

layout (location = 0) in vec3 vertex_position;
layout (location = 1) in vec3 vertex_normal;
layout (location = 2) in ivec4 vertex_ids;	// bone ids
layout (location = 3) in vec4 vertex_weights;	// bone weights
layout (location = 4) in vec2 vertex_texcoord;

out vec3 vs_position;
out vec2 vs_texcoord;
out vec3 vs_normal;

uniform mat4 ModelMatrix;
uniform mat4 ViewMatrix;
uniform mat4 ProjectionMatrix;

const int MAX_BONES = 100;
uniform mat4 bones[MAX_BONES];

void main()
{
	mat4 bone_transform = bones[vertex_ids[0]] * vertex_weights[0];
		bone_transform += bones[vertex_ids[1]] * vertex_weights[1];
		bone_transform += bones[vertex_ids[2]] * vertex_weights[2];
		bone_transform += bones[vertex_ids[3]] * vertex_weights[3];

	vec4 boned_position = bone_transform * vec4(vertex_position, 1.0); // transformed by bones
	vec4 normal_position = bone_transform * vec4(vertex_normal, 1.0);

	vs_position = vec3(ModelMatrix * boned_position);
	vs_texcoord = vec2(vertex_texcoord.x, vertex_texcoord.y*-1.f);
	vs_normal = vec3(ModelMatrix * normal_position);

	gl_Position = ProjectionMatrix * ViewMatrix * ModelMatrix * boned_position;
}
