#version 120

uniform sampler2D gcolor;
uniform sampler2D colortex4;
uniform sampler2D colortex5;

uniform float viewWidth;
uniform float viewHeight;

varying vec2 texcoord;

#define NATIVE_RES   // Native GB resolution

// 0 = none, 1 = bars, 2 = fullscreen gameboy, 3 = normal gameboy
#define OVERLAY_METHOD 0   // Enable and change overlays [0 1 2 3]			--2

// --vec3 darkestGreen = vec3(15.0f, 56.0f, 15.0f) / 255.0f;
// --vec3 darkGreen = vec3(48.0f, 98.0f, 48.0f) / 255.0f;
// --vec3 lightGreen = vec3(139.0f, 172.0f, 15.0f) / 255.0f;
// --vec3 lightestGreen = vec3(155.0f, 188.0f, 15.0f) / 255.0f;
vec3 shaderColours[8];


vec2 resolution = vec2(viewWidth, viewHeight);							// --vec2 resolution = vec2(viewWidth, viewHeight);
vec2 GBRes = vec2(160.0f*1.5, 144.0f*1.5);							// --vec2 GBRes = vec2(160.0f, 144.0f);
float pixelSize = resolution.y / GBRes.y;							//float pixelSize = 1;

float roundToNearest(float number, float nearest) {
	return floor(number / nearest) * nearest;
}

float avgVec3(vec3 vector) {
	return (vector.x + vector.y + vector.z) * 0.33333; 
}

void main() {
	shaderColours[0] = vec3(56.0f, 56.0f, 56.0f) / 255.0f;					
	shaderColours[1] = vec3(56.0f + 20, 56.0f + 20, 56.0f + 20) / 255.0f;	

	shaderColours[2] = vec3(98.0f, 98.0f, 98.0f) / 255.0f;					
	shaderColours[3] = vec3(98.0f + 20, 98.0f + 20, 98.0f + 20) / 255.0f;	
	
	shaderColours[4] = vec3(172.0f, 172.0f, 172.0f) / 255.0f;
	shaderColours[5] = vec3(139.0f + 20, 172.0f + 20, 172.0f + 20) / 255.0f;
	
	shaderColours[6] = vec3(188.0f, 188.0f, 188.0f) / 255.0f;
	shaderColours[7] = vec3(188.0f + 20, 188.0f + 20, 188.0f + 20) / 255.0f;


	vec2 newCoords = texcoord;
	
	#ifdef NATIVE_RES
		newCoords = vec2(floor(newCoords.x / ((pixelSize / resolution.x))) * ((pixelSize / resolution.x)), floor(newCoords.y / (1.0f / GBRes.y)) * (1.0f / GBRes.y));
	#endif

	vec4 color = texture2D(gcolor, newCoords);
	float brightness = avgVec3(color.rgb);

	// --if(brightness <= 0.25f) {
	// --	color.rgb = darkestGreen;
	// --} else if(brightness <= 0.5f) {
	// --	color.rgb = darkGreen;
	// --} else if(brightness <= 0.75f) {
	// --	color.rgb = lightGreen;
	// --} else {
	// --	color.rgb = lightestGreen;
	// --}
	
	if (color.rgb.x <= 0.25f) {
	    color.rgb.x = shaderColours[0].x;
	} else if (color.rgb.x <= 0.35f) {
	    color.rgb.x = shaderColours[1].x;
	} else if (color.rgb.x <= 0.45f) {
	    color.rgb.x = shaderColours[2].x;
	} else if (color.rgb.x <= 0.5f) {
	    color.rgb.x = shaderColours[3].x;
	} else if (color.rgb.x <= 0.65f) {
	    color.rgb.x = shaderColours[4].x;
	} else if (color.rgb.x <= 0.75f) {
	    color.rgb.x = shaderColours[5].x;
	} else if (color.rgb.x <= 0.85f) {
	    color.rgb.x = shaderColours[6].x;
	} else {
	    color.rgb.x = shaderColours[7].x;
	}

	if (color.rgb.y <= 0.25f) {
	    color.rgb.y = shaderColours[0].y;
	} else if (color.rgb.y <= 0.35f) {
	    color.rgb.y = shaderColours[1].y;
	} else if (color.rgb.y <= 0.45f) {
	    color.rgb.y = shaderColours[2].y;
	} else if (color.rgb.y <= 0.5f) {
	    color.rgb.y = shaderColours[3].y;
	} else if (color.rgb.y <= 0.65f) {
	    color.rgb.y = shaderColours[4].y;
	} else if (color.rgb.y <= 0.75f) {
	    color.rgb.y = shaderColours[5].y;
	} else if (color.rgb.y <= 0.85f) {
	    color.rgb.y = shaderColours[6].y;
	} else {
	    color.rgb.y = shaderColours[7].y;
	}

	if (color.rgb.z <= 0.25f) {
	    color.rgb.z = shaderColours[0].z;
	} else if (color.rgb.z <= 0.35f) {
	    color.rgb.z = shaderColours[1].z;
	} else if (color.rgb.z <= 0.45f) {
	    color.rgb.z = shaderColours[2].z;
	} else if (color.rgb.z <= 0.5f) {
	    color.rgb.z = shaderColours[3].z;
	} else if (color.rgb.z <= 0.65f) {
	    color.rgb.z = shaderColours[4].z;
	} else if (color.rgb.z <= 0.75f) {
	    color.rgb.z = shaderColours[5].z;
	} else if (color.rgb.z <= 0.85f) {
	    color.rgb.z = shaderColours[6].z;
	} else {
	    color.rgb.z = shaderColours[7].z;
	}						
	
	// black bars
	#if OVERLAY_METHOD == 1
		vec4 overlay = texture2D(colortex5, texcoord.xy * vec2(1.0f, -1.0f));
		if(overlay.a > 0.1f) {
			color = vec4(0.0f, 0.0f, 0.0f, 1.0f);
		}
		
	// normal gameboy
	#elif OVERLAY_METHOD == 2
		vec4 overlay = texture2D(colortex4, texcoord.xy * vec2(1.0f, -1.0f));
		if(overlay.a > 0.1f) {
			color = vec4(vec3(overlay.rgb), 1.0f);
		}
		
	// fullscreen gameboy
	#elif OVERLAY_METHOD == 3
		vec4 overlay = texture2D(colortex5, texcoord.xy * vec2(1.0f, -1.0f));
		if(overlay.a > 0.1f) {
			color = vec4(vec3(overlay.rgb), 1.0f);
		}

	#endif

/* DRAWBUFFERS:0 */
	gl_FragData[0] = color;
}
