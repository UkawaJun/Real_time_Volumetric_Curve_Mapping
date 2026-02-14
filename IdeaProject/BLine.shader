shader_type spatial;
render_mode specular_schlick_ggx;

uniform vec2 uv;
uniform float Lsize = 1.0 ;

uniform vec3 p3= vec3(0,0,6);
uniform vec3 p1 = vec3(5,0,5);
uniform vec3 p2 = vec3(-5,0,-5);
uniform vec3 offset	= vec3(5,0,-5);

vec3 bezielPoint(float t)
{
	t = t>1.0?1.0:(t<0.0?0.0:t);

	vec3 d1 = (p1-p3)*t +p3;
	vec3 d2 = (p3-p2)*t +p2;
	vec3 result = (d1 - d2)*t + d2;
	
	return result;
}
float fun(float x)
	{
	float r = float(pow(x,2.0));
	float newX = x/abs(p1.x-p2.x);
	float c = bezielPoint(newX).z;
	return c;
		}
float get_PointValue(vec3 a)
{
	
	float result = 0.0f;
	
	vec2 size = vec2(abs(p1.x - p2.x),abs(p1.z-p2.z))/2.0;
	vec2 center = vec2(p1.x + p2.x,p1.z+p2.z)/2.0;
	result = (a.z -center.y)/size.y;
	return Lsize*result;
}
	
void vertex() {
	//初始化init 偏移量  设定右下角为0，0  为了让x轴称为贝塞尔变换的关键点
	
	vec3 p_0 = VERTEX;
	VERTEX += vec3(offset.x,0,0);
	
	//
	
	
	vec3 outs = p_0;
	outs.z = fun(VERTEX.x)+get_PointValue(p_0);
	

	

	
	VERTEX = outs;
	VERTEX -= vec3(0,0,0);

}

void fragment() {
// Output:0
ALBEDO = vec3(0.6,0.2,0.5);
METALLIC = 0.6;
ROUGHNESS = 0.2;
}

void light() {
// Output:0

}
