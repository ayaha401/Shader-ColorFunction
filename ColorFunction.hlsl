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

#endif
