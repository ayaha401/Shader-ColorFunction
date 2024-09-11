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

#endif
