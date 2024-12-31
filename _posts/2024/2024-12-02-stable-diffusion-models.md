---
layout: post
title: "Stable Diffusion notes"
description: ""
category: [computer-vision]
tags: [stable-diffusion, ai]
---

# Stable Diffusion Model Parameters

SD 1.5

[DreamShaper XL (Turbo)](https://civitai.com/models/112902?modelVersionId=351306): 
- CFG scale:2, 
- 4-8 sampling steps
- sampler, scheduler: `DPM++ SDE Karras`

[RealVis 5.0]
- Use Lightning models with DPM++ SDE Karras / DPM++ SDE sampler, 
- 4-6 steps and 
- CFG Scale 1-2