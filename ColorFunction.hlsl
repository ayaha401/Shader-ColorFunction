#ifndef COLOR_FUNCTION
#define COLOR_FUNCTION

// モノクロ変換
float convertMonochrome(float3 rgbCol)
{
    return dot(rgbCol, float3(.299, .587, .114));
}

// RGBカラーからHSV色空間のV（明度）を計算
float getValueColor(float3 rgbCol)
{
    return max(max(rgbCol.r, rgbCol.g), rgbCol.b);
}

// V(明度)でRGBを調整する
float3 adjustRGBWithV(float3 rgb, float v)
{
    return rgb * v;
}

// HSVからRGBに変換する
float3 hsv2rgb(float3 c)
{
    float3 rgb = clamp(abs(fmod(c.x * 6.0 + float3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0, 0.0, 1.0);
    rgb = rgb * rgb * (3.0 - 2.0 * rgb);
    return c.z * lerp(float3(1.0, 1.0, 1.0), rgb, c.y);
}

// checkColorの要素のうち、1つでも1.0を超えるか、0以下ならエラーの色を出す
float4 isColorOutOfRange(float4 checkColor, float4 errorOverColor = float4(1.0, 0.0, 1.0, 1.0), float4 errorMinusColor = float4(1.0, 0.0, 1.0, 1.0))
{
    if (max(max(max(checkColor.r, checkColor.g), checkColor.b), checkColor.a) > 1.0)
    {
        return errorOverColor;
    }

    if (min(min(min(checkColor.r, checkColor.g), checkColor.b), checkColor.a) < 0.0)
    {
        return errorMinusColor;
    }

    return checkColor;
}

// 人間の視覚に基づいた輝度を計算する
// https://www.clonefactor.com/wordpress/program/unity3d/1513/
half luminance(half3 col)
{
    return dot(col, half3(0.22, 0.707, 0.071));
}

// Hueを変える
// https://www.clonefactor.com/wordpress/program/unity3d/1513/
half3 applyHue(half3 color, half hue)
{
    float angle = radians(hue);
    float3 k = float3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(angle);
    return color * cosAngle + cross(k, color) * sin(angle) + k * dot(k, color) * (1 - cosAngle);
}

// HSVとコントラストを変える
// Hは0がデフォルト、それ以外は0.5がデフォルト
// https://www.clonefactor.com/wordpress/program/unity3d/1513/
half3 applyHSVC(half3 color, half4 hsvc)
{
    float hue = 360.0 * hsvc.x;
    float saturation = hsvc.y * 2.0;
    float brightness = hsvc.z * 2.0 - 1.0;
    float contrast = hsvc.w * 2.0;

    half3 outputColor = color;
    outputColor = applyHue(outputColor, hue);
    outputColor = (outputColor - 0.5) * contrast + 0.5 + brightness;
    outputColor = lerp(luminance(outputColor), outputColor.rgb, saturation);
    
    return outputColor;
}

// 色をlerpで反転させるときに.5で全部灰色にならないようにする方法
// color : 色
// x : 0~1
// mode : 0 か 1 ソラリゼーションさせる方法が変わる
// https://suricrasia.online/blog/interpolatable-colour-inversion/
half3 solarInvert(half3 color, float x, half mode)
{
	float st = 1.0 - step(0.5, x);
	float isAType = step(0.5, mode);  // modeが1以上でA_TYPEになる
	half3 processedColor = lerp(color, 1.0 - color, isAType); // A_TYPEの時は反転
	half3 resultColor = abs((processedColor - st) * (2.0 * x + 4.0 * st - 3.0) + 1.0);
	return lerp(resultColor, 1.0 - resultColor, isAType); // A_TYPEモードなら結果色も反転させる
}

#endif
