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

half luminance(half3 col)
{
    return dot(col, half3(0.22, 0.707, 0.071));
}

half3 applyHue(half3 color, half hue)
{
    float angle = radians(hue);
    float3 k = float3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(angle);
    return color * cosAngle + cross(k, color) * sin(angle) + k * dot(k, color) * (1 - cosAngle);
}

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

#endif
