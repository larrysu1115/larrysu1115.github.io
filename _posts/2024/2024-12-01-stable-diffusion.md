---
layout: post
title: "Stable Diffusion notes"
description: ""
category: [computer-vision]
tags: [stable-diffusion, ai]
---

# Stable Diffusion

- Text to image
- Image to image
- width, height: 寬高畫素 應 符合使用的 model
- CFG scale: 與 prompt 符合的程度 (SD1.5, SDXL 建議 5 ~ 12), 不同 model 可能有不同要求
- Text decoder
- Text encoder
- VAE decoder: 將 SD 模型生成的訊息轉換爲 圖片
- VAE encoder: 將 圖片 轉換爲 SD模型理解的訊息
- Sampling steps
- Denoising: 將充滿雜訊的畫面去除雜訊，留下符合需要的畫面
- Seed: 產生充滿雜訊的亂數種子

## Prompt 結構

- 最前 和 最後 的 提詞 重要性大。可用 (something:1.2) 格式來改變權重
- .View Angle: Portrait, Close-up, Shot from a birds eye angle
- Medium: 圖片的風格, 如 oil painting, watercolor
- Subject: 主體如, an old man sitting in the park
- .Subject Detail: long hair, metal armor, ... (SD對顏色敏感，要小心使用)
- .Subject Rendering: Unreal Engine, Octane render, Blender 3
- .Background:
- .Background detail: butterfly, dust, mushrooms
- .Lighting: Cinematic Lighting, Volumetric Lighting, Soft Light,  Studio Lighting, Backlighting
- Detail: high detail, photoreal, Canon DSLR, ...
- Resolution: 4k, 8k, UltraHD, high resolution
- .Artist: 藝術家風格。最好符合畫家的 medium, subject。放在 prompt 最前 或 最後

---

-- 占比例語法，猴子的頭髮 70% 是藍色。 a monkey, [blue::0.7] pink hair 

## In-Painting (局部重畫)

- text-to-image 產出圖片後, 按下 send-to-inpaint 進行後製
- 在 inpaint tab, 選擇 inpaint area: "Only masked"
- width, height: 1024x1024
- Sampling method, schedule type 與產原圖相同
- Denoising strength: 0.95 (儘可能與原圖如不同)
- brush 塗要重畫的區域, 調整 prompt 爲該部位的說明
- 按下 generate, 產生的局部圖。
- 局部圖大致佈局可以但是太模糊，按下 send-to-inpaint
- 降低 denoising:0.75, WxH:1024x1024 重畫讓結果更清晰, 按下 send-to-inpaint
- 降低 denoising:0.65, WxH:1024x1024 重畫讓結果更清晰, 按下 send-to-inpaint
- 直到 denoising:0.35 左右爲止
- 最後 send-to-img-to-img, 降低 denoising:0.25, 使用原來全圖的 prompt, 再次 generate
- 完成

## extension: openOutPaint (畫大圖)

- 安裝 extension: out-paint
- webui-user.bar, COMMANDLINE_ARGS=... 加上 --api，重啓
- 產出圖後，send-to 新出現的頁籤 openOutPaint
- 可以擴大圖，brush 局部重畫，選擇不同的 model, 參數, ...

## 清晰 4x-UltraSharp by Kim2091

- 下載 [4x-UltraSharp](https://openmodeldb.info/models/4x-UltraSharp)
- TAB: extra, upscaler 1 選擇 4x-UltraSharp，按下 generate
- 之後可以到 image-to-image inpaint 做局部調整
- denoise 0.55, 低到 0.2 也可能

## ControlNet

- 安裝 extension: controlnet
- pose website: https://ca.pinterest.com/, search "sitting pose"

All-in-One for SDXL
https://huggingface.co/xinsir/controlnet-union-sdxl-1.0/tree/main


## 控制人物姿勢

## tips

- 利用 script: X/Y/Z plot 一次畫出各種參數的結果進行比較，語法: `15-30[3]` 從15開始到30之間產生 3 份
- Hires.fix 可以提高 解析度。denoising `0.5` 即可，太高圖片會與原圖不同。upscaler: `SwinIR 4x`
- 一些不同的 model checkpoint 需要搭配指定的 LoRA, ControlNet, VAE 使用
- LoRA: epi_noiseoffset2, 點擊後出現 `<lora:epi_noiseoffset2:2>` 放入 prompt 中位於細節後，調整權重到 `<xxx:2>`
- Text Inversion: ng_deepNegative_v1_7 避免錯誤手指, 點擊後出現 `ng_deepnegative_v1_75t` 放到 negative 首位
- VAE: 使用 fantasy_world model 產出圖有些灰, 使用 VAE: vae-ft-mse-840000-ema 後色彩鮮豔正常
- Samplers: 

## Negative Prompts

```
(worst quality, low quality:1.4), logo, text, monochrome, Deformity, Twisted limbs, Incorrect proportions, Ugliness, Ugly limbs, Deformed arm, Deformed fingers, Three hands, Deformed hand, 4 fingers, 6 fingers, Deformed thigh, Twisted thigh, Three legs, Deformed foot, Twisted foot, Terrible foot, 6 toes, 4 toes, Ugly foot, Short neck, Curved spine, Muscle atrophy, Bony, Facial asymmetry, Excess fat, Awkward gait, Incoordinated body, Double chin, Long chin, Elongated physique, Short stature, Sagging breasts, Obese physique, Emaciated

```

# Resources

- [SDXL artist list](https://stablediffusion.fr/artists)
- 查詢各類畫作[ARC Museum](https://www.artrenewal.org/Museum/Search)
- promptomania [SD Prompt Builder](https://promptomania.com/stable-diffusion-prompt-builder/)
- 其他人用 AI 畫出的圖, 找靈感調參數 [KREA](https://www.krea.ai/home), [openart](https://openart.ai/discovery), [lexica](https://lexica.art/)
- [CheetSheet](https://flaxen-art-b20.notion.site/SDXL-Resolution-Cheat-Sheet-8eac1d174416438b903c127b50dc1a54)
- 模型下載 [civitai](https://civitai.com/)
