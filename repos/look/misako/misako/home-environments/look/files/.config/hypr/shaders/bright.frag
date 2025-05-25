precision mediump float;

varying vec2 v_texcoord;
uniform sampler2D tex;

const float shadow_gamma = 0.40;     // < 1.0 lifts shadows
const float contrast_strength = 0.0; // push contrast after lifting
const float lift_limit = 0.1;        // max lift based on luminance

const vec3 luma_weights = vec3(0.2126, 0.7152, 0.0722);

vec3 applyContrast(vec3 color, float strength) {
    // push values away from 0.5
    return mix(color, (color - 0.5) * (1.0 + strength) + 0.5, strength);
}

void main() {
    vec4 texColor = texture2D(tex, v_texcoord);
    vec3 color = texColor.rgb;

    float luma = dot(color, luma_weights);

    // Apply gamma correction only for shadows
    float lift_factor = smoothstep(0.0, lift_limit, luma);
    vec3 lifted = mix(pow(color, vec3(shadow_gamma)), color, lift_factor);

    // slight contrast to avoid flat/milky look
    lifted = applyContrast(lifted, contrast_strength);

    // Clamp final color
    lifted = clamp(lifted, 0.0, 1.0);

    gl_FragColor = vec4(lifted, texColor.a);
}
