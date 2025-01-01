---
layout: post
title: "Blender notes"
description: ""
category: [3D-model]
tags: [blender, 3d]
---

# Blender Notes

blender 是一款開源的 3D 模型工具，這是學習這篇 [Blender 4.0 Beginner Donut Tutorial](https://www.youtube.com/playlist?list=PLjEaoINr3zgEPv5y--4MKpciLaoQYZB1Z) 之後的筆記

## Part 1 - interface

- vertices, edge, face
- `g`:move, `s`:scale, `r`:rotate

## Part 2

```
做一個圓環，圓滑邊緣，
進入編輯模式，單點拖動，區域拖動
選取 環狀線，scale-in 作出圓環邊內縮
```

- Shade Smooth, Flat: 讓物件邊緣圓滑, 選取物件右鍵菜單
- Subdivision Surface: 不增加額外 mesh 修圓滑 Silhouette 輪廓. 右側扳手(modifiers > generate > subdivision surface)
- Viewport: 編輯時帶 mesh 的模式
- Render: 產出結果的畫面

- Edit mode: `TAB` 可編輯 vertices
- move: `G` 拖拉點 grab
- scale: `S` scale
- Proportional editing: `O` 一次拖拉多點, scroll 改變 circle of influence
- Edge select: `ALT` 再選取線

## Part 3

```
複製出 上層糖霜 icing，
icing 物件加厚，去除 Z-fighting
snap 讓 icing 貼合 donut 物件
Select-More 隱藏內圈，再 區域拖拉 icing 製造不規則流體
extrude 延伸製造滴落效果
```

- Duplicate Object: `Shift-D` 複製物件
- Toggle X-Ray: 可以透視選取, 右上小按鈕
- Z-Fighting: Flickering 兩個平面重疊造成閃爍
- Solidify modifier: (modifiers > generate) 增加厚度 thickness, edge data 可改變邊緣角度
- modifier 顯示時機: 每個 modifier 右側小圖示
- snap: 讓不同物件彼此貼合，右上小磁鐵按鈕，可選貼近 face, grid, ...
- snap, face project: 讓貼合的面上其他點也移動貼合
- Select More, Less : `Ctrl +`, `Ctrl -`. 選取一行後，可以自動選取下一圈...
- hide: `h`, unhide `Alt h`
- X Y Z 軸線移動: 按 g 後，滑鼠中鍵
- extrude: 伸展. 選取兩點，按下 `e` 後拉下製造多出的兩點。

## Part 4

```
檢查修正有問題的點,
icing 滴落的點會更厚，使用 sculpt 工具在滴落終端 inflate
icing 的邊緣應該厚一點，使用 mask, mesh filter 均勻地 apply inflate 效果
```

- Shrinkwrap modifier: (modifiers > deform) 用滴管 eyedrop 工具使 icing 貼合 donut, 然後 apply 讓 modifier 在 mesh 生效
- 在 sculp 前，也將 solidify modifier apply
- 也將 Subdivision modifier apply, 增加可以 sculpt 的點。apply 時候只會用 viewport 的值，不管 render 的值。
- sculpt mode: 可選擇 `F` radius, `Shift F` strength. 也可選擇上方的 stroke method (default 是 space)
- sculpt > inflate/deflate `i`: 增加厚度.
- sculpt > grab `g`: 擠壓. 讓滴落的上方稍微收緊，符合自然滴落的液態
- sculpt > mask `m`: 隔離/選定局部. 將 strength 定爲 1. invert selection `Ctrl + I`
- Front faces only: mask > brush 勾選只塗單面，預設會塗雙面
- Isolation mode: `/` 只顯示選中的物件
- Mesh filter: 均勻地在沒有 mask 的部位應用。選擇上方的 filter type, 設定 strength, 左鍵點下物件後左右拖拉, 完成後鬆開左鍵。
- Smooth mask: (mask > smooth mask) 讓 mask 邊緣漸進式，apply filter 就不會在邊緣顯得突兀。
- Clear mask: (mask > clear mask) 清除 mask
- sculpt > smooth: 可以選定該工具，或直接按住 `Shift` 會變爲 smooth 工具的作用。

## Part 5 : Shading

```
加入底座平台，使用大理石材質 Image Texture, roughness (Non-Color), normal (Non-Color) 的材質貼圖。
利用 object parent 將 icing 與 donut 建立群組一起移動。
使用 shading 的 nodes 連接圖。
爲 donut 本體加入 image texture, 設定底色, 再用 texture paint 塗上邊緣發白一圈。
```

- Material: 給 donut, icing 基本底色。右側菜單, Base color, Roughness (0:平滑反光,1:粗糙)
- 底座: (Add > Mesh > Plane)
- object parent: group 群組移動多個物件。先選 child, 再 shift 加選 parent, 然後按 `Ctrl + P`. 要選擇 Object (Keep Transform)
- search 命令: `F3` 輸入要找的指令
- Image Texture: material, base color 左側的小圓點 按下，選擇 Image Texture
- Shading: 上方 tab (Shading), 會看到實際 material 的 nodes, 可以添加修改 nodes
- Hue/Saturation/Value node: 可以轉變顏色
- Roughness: 從 Principled BSDF 的 Roughness 左側小圓點 拉出線，新增 Image Texture, 選擇對應材質圖片, color space 要選擇 Non-Color
- Normal: 正交垂直的向量，會展現爲表面的不規則小突起。由 normal 左側小圓點拉出線，新增 Image Texture, 選擇對應材質圖片, color space 要選擇 Non-Color, 還需在中間加上 Normal Map node (Vector > Normal map)
- Full Screen: `Ctrl + Space`
- PBR Shader: Physically Based Rendering
- Texture Paint: 在右邊 material 先爲 donut 本體加上 Image Texture, new 建立新圖片，選擇填滿的顏色。上方 tab (Texture Paint), 選色，調色，在 donut 本體繪出側邊一圈略白色
- UV Unwrap
- 記得要在左側 `Image*` 按下 save, 才會存檔
- 左上角顯示 User Perspective (Local), Local 代表是 isolated mode `/`

## Part 6 : Geometry Nodes

```
```

- GeometryNode modifier: 上方選擇 tab Geometry Nodes, 選中 icing 後按 new, 會增加 modifier: GeometryNodes
- 利用 nodes system, 在 mesh 不變動的情況下，調整產出結果。
- Distribute Points on faces: 將 icing 物件變成表面多個點 (add > Point > )
- Join Geometry: (add > geometry) 將原來的 icing 物件 join 回來。注意連接點圖示較長，表示可以連接多條線，從 input 拉多第二條線進來。
- UV Sphere: add > mesh > UV Sphere, 因爲會很多 sprinkle, 物件給 segments:12, rings:8 就好, radius:0.01m
- 下方 Geometry nodes 面板，只會顯示目前選中的物件。可以用 圖針 釘住
- Instance on Points: 參考小圓點形狀。從右上 collection 將小圓點拖下到 Geometry Nodes 面板出現 node:Object Info, add > Instances
- 設定連線 DisPoints.Point > InstPoints.Point, ObjInfo.Geometry > InstPoints.Instance, InstPoints.Instances > JoinGeometry.Geometry
- Poisson Distribution: 太多點時候，會重疊的問題. 將 DistriPointsOnFaces 的 distribution method 從 random 改爲 Poisson Disk, 可以設定 distance min:0.013
- 漫佈的小店在 icing 正反面都有，徒耗效能。
- Weight Paint: 在 mesh 上畫出 weight 值，用來指導佈局。進入 weight paint mode.
- data: 右側菜單 data 可以見到 vertex group, 重新命名爲 sprinkle density
- Density Factor: 引用 weight. 將 node: DistriPoints.DensityFactor 點拉出，增加 named attribute, name 設定爲 sprinkle_density (vertex group)
- Weight Paint: negative paint 繪製時候按住 `Ctrl`
- Quick Zoom: `NumberPad . (period)`
- View Selected: `~`  + `3` 注意要在 viewport 圖示畫面內
- 將小點圓形進行 shade smooth
- exposing a value: 提取設定值讓複製出的物件可以各自設定。DistriPoints.DensityMax 拉到 GroupInput, 就多了 modifier 的設定值。再到 下方面板 Geometry Node 右側 Group 頁籤中設定名稱爲 Sprinkle Density
- 實際大小: 在 viewport 按 `n` 看到 properties
- 選擇所有: `a` for ALL
- 調整大小: 選擇 donut, icing, plane 進行 scale `s`, 如果按 `Ctrl` 會進行階段式的縮放，也可輸入數值。
- 注意到 `n` properties 顯示 scale: 0.1, 如果不 apply 就是經過 scale 處理
- apple scale: 選取要進行的物件，`Ctrl + A` 出現選單按下 apple scale.
- apply scale 後 density 到 20000, distance min 到 0.001 都需要再調整
- 增加 math node (add > utility > math > math), 將 density 乘以 200, 方便進行數值調整，不用處理 20000 的大數.

