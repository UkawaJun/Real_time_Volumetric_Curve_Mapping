shader_type spatial;
render_mode cull_disabled,specular_schlick_ggx;

uniform vec3 p1;
uniform vec3 p2;
uniform vec3 p3;
uniform vec3 p4;
uniform vec3 p0;

//映射区间		x-(-1 - 1)

//允许操作
uniform float Lsize = 1.0 ;
uniform vec3 bSize = vec3(1,1,1);
uniform vec3 color1 = vec3(1.0,0.0,0.0);
uniform vec3 color2 = vec3(0.0,0.0,1.0);
uniform vec3 RIM_METALLIC_ROUGHNESS = vec3(0.2,0.0,1.0);
// x y z   x
vec3 map(vec3 location)
{	//转化为 x	0-1		-1 - 1		-1 - 1
	vec3 result;
	result = vec3((location.x+bSize.x)/2.0,location.y/bSize.y,location.z/bSize.z);
	//x 转化为贝塞尔参数	yz转化为贝塞尔的补充
	//使用了x把点均匀至曲线上，y则均匀至竖直方向
	// y的方法是由d1 -d2的斜率的倒数的负数得到
	//z方向上的垂直则是由 cross（x,y）
	return result;
}

void vertex() {
	//初始化init 偏移量  设定右下角为0，0  为了让x轴称为贝塞尔变换的关键点
	
	vec3 p_0 = VERTEX;
	//////////////////////
	
	vec3 pt = map(VERTEX);
	
			////Bezier3D(pt);
	vec3 rp = vec3(0.0);
	//求贝塞尔值，法线
	do
	{
			vec3 p = pt;
			vec3 result = vec3(0.0);
			p.x*=0.99;
			p.x += 0.005;
			vec3 d1 = (p2-p1)*p.x + p1;
			vec3 d2 = (p3-p2)*p.x + p2;
			vec3 d3 = (p4-p3)*p.x + p3;
			
			
			
			vec3 t1 = (d2-d1)*p.x + d1;
			vec3 t2 = (d3-d2)*p.x + d2;
			
			vec3 c1 = (t2-t1)*p.x + t1;
			
			
			vec3 t0 = c1;
			
			//构建向量组： 
			vec3 p4_d3 = (d3-p4);
			vec3 p1_d1 = (d1-p1);
			//vec3 d2_d3 = (p1-p2);
			//vec3 d2_d1 = (p4-p3);
			vec3 sz =  normalize(cross(p4_d3,p1_d1));
			c1 += normalize(sz*p.z)*Lsize;
			
			vec3 sy = normalize(cross(sz,d3-d1));
			
			c1 += normalize(sy*p.y)*Lsize;
			
			NORMAL = normalize(c1- t0);
			result = c1;
			//result -= p0;
			rp = result;
	}while(false);
			////Bezier3D(pt);
			
	//////////////////////
	VERTEX = vec3(rp.x,rp.y,rp.z);
	//对插值变换结果
	//VERTEX = p_0*abs(sin(0.2*TIME)) + vec3(rp.x,rp.y,rp.z)*(1.0-abs(sin(0.2*TIME)));
	
	
	
	COLOR = vec4(color1*(1.0-pt.x) + color2*(pt.x),1.0);
}

void fragment() {
// Output:0
ALBEDO = COLOR.xyz;


RIM = RIM_METALLIC_ROUGHNESS.x/10.0;
METALLIC = RIM_METALLIC_ROUGHNESS.y;
ROUGHNESS = RIM_METALLIC_ROUGHNESS.z;
}

void light() {
// Output:0

}