---
layout: post
title: "Blender Baking"
description: ""
category: [3D-model]
tags: [blender, 3d]
---

# Shader Editor

3 types of shader map:

- normal map: 新增 Shader Nodes, Image Texture (Orc Map), Normal Map. Render to `Bake` in `Cycles` engine
- cavity : `Shift+A` input, Geometry. Pointiness.
- cavity : `Shift+A` converter, Color Ramp. 在中間, 選擇 黑 白 調整
- cavity : Bake Type: Diffuse, 不要 bake from Multires, 不要 direct, indirect checkbox (Contributions)
- AO (ambient occlusion): input, Ambient Occlusion, color > base color. 選擇 AO texture image 後 Bake
- color: texture image 選擇要的顏色， `Shift+A` color, mix color, mix type: Multiply. (Color + AO) to (ColorMultiply)
- color: (Previous + Cavity) to (colorMixType: Overlay) to (Principled BSDF)
- 兩個 color Mixer 都開 Factor:1.00


- add-ons: `Node Wrangler` installed
- 選擇 `World`, node: `Background`, `Ctrl+T`, 帶出一系列 env texture nodes*3

## Baking Selected to Active

- baking 用在有 multires + mirror 時候不行，要先移除 mirror
- 先複製目標obj, 多一個 obj HP (High Poly), 原來的 obj 移除 multires, 所有 obj 都做 shade smooth
- 先選中 obj, 再 `Shift+LMB` 選中 obj HP, (深橘色是 selected, 淺橘色是 active), `Ctrl` 可以反轉
- Render > Bake, 取消 `Bake from multires`, 選中 `Selected to Active` (Shift 最後選中的是 active)
- Bake Type to "Normal"
- Bake 後見到明顯黃色是突出部位有問題

## Baking the Armour Normals

- Bake "loincloth" 時候有直角切面問題 (Texture images 上有明顯深紫色)，增加 lowPoly obj 的 levelsOfViewport 0 to 1, apply 再 bake
- Bake 時候最好不要連上 normal map to Principled BSDF

## Baking the Armour Cavity Maps

- 先取消 "boots toe caps HP" 的 material, 再建立新的。
- 建立 node: Input.Geometry, Pointiness to BSDF.BaseColor
- 調整 low poly 的 object material, 加上 ImageTexture(Orc Armour Cavity), non-color, 指向新增的 image (Orc Armour Cavity)
- Bake 選擇 BakeType:Diffuse, 不選 Contributions的 direct,indirect. 開始 bake

## Baking the Armour Ambient Occlusion Maps

- AO 與形狀和周邊的關係有關，是否 High Poly 較不重要
- 可以從 low Poly 直接製作。
- 新增 image
- 複製 cavity node 成爲 AO node (image texture)
- 增加 Input.AmbientOcclusion node, link color to BSDF.BaseColor
- `M` 可以 mute node, 比較 node 的效果。AO 的效果其實不明顯，也許不用做也可以
- 因爲只用 LowPoly obj, 取消 bake.SelectToActive
- `Ctrl + Shift` + `RMB` 將要做 color mix 的兩個 node 拉出來 (color + AO)
- File > External Data > Automatically Pack Resources. 圖片就會跟着 *.blender 檔案儲存了
- 給牙齒另一組 material, 共用 Armour color 的圖片.

## Texture Painting the Orc

- 打開 "Texture Paint" tab
- `Shift+X` 可在 3D viewport 中滴選顏色
- 如果 paint 時候有 lag, 可能是 mesh (faces) 太多，調低 multires 的 "Level Viewport" 試試看
- 將基底色加入 color palette, 對小突起，上方照亮加上微亮色調。加上血色於眼,脣,指甲等周邊。

## Metallic Maps

- `Ctrl + Tab` 切換回各種 mode (object mode), 再選擇別的 obj 再進入 paint mode
- `Alt + Q` 可以不切換回 object mode, 就選中別的 obj
- 增加一個 image:OrcArmourMetalic, 連到 BSDF.metallic, 純白 #FFF fill paint 物件讓整個金屬件有光澤
- Color palette 下有 options.Bleed, 決定畫在 map 上的邊緣多寬
- 肩部護甲的 horn, 下半部底座是金屬。先在 edit mode 選中 (link by seam), 切回 paint mode, 使用上方小圖標 "Paint Mask" (小白方形後有鏤空框)

## Roughness Maps

- 類似 metallic maps, 使用 non-color image
- edit mode `Ctrl + I`, invert selection, 可以選中 horn 中的上角部位

## Using Texture Brushes

- "Texture Paint" 中的 brush, 有 "Texture" / "Texture Mask" 是不同的。
- 在 tools 中的 "Texture" 新建一個，再到 次級菜單 "Texture", 選擇 texture image, 使用 color:white or darker.. 配上合適的 strength
- [texture site](https://freepbr.com)
- We just need Albedo texture map
- `Ctrl + Shift + LMB` 選中 shader editor 中的 node, 可以獨立看該 node 的效果。點回 BSDF 回到原來呈現

## Using Stencil Brushes

- pexels.com 
- tool, texture, mapping: "Stencil". `RMB` 移動模板圖， `Shift + RMB` 放大縮小 `Ctrl + RMB` 旋轉

## Brush Blend Modes

- 再用 皮革 stencil brush 畫上靴子。
- Brush Settings > Blend:Mix 下拉有許多選擇 darken... 我們將用 screen / multiply (使用時要移掉 texture image)
- Brush Settings > Blend:screen 製作邊緣磨損有點橘色高亮
- Brush Settings > Blend:multiply 製作暗沉磨損

## 9.9 PBR Workflow Options

- `T` 隱藏左側 tool panel / 復原
- add-ons `Node Wrangler` 有安裝的話，可以快速設定 PBR 
- 先選中 Principle BSDF, 按下 `Ctrl + Shift + T`, Principle Texture Setup
- 一次性修改許多 node 的屬性: 先選中許多 node, 再按住 `Alt` 進行修改。
- Texture Coordinate.UI > Mapping.Vector 加上 *.Flat 會造成腰帶垂直的部分材質貼圖問題，改成 Object to Mapping.Vector, 第二層所有 node 的 Projection 從 Flat 改成 Box
- 但是這個方法不用 UV map, 所以導出時候容易沒辦法導出材質的圖。
- UV map 用的是 flat projection

## 9.12 Joining Our Materials

- 要給簡單 material 設定的皮帶設定上 複雜(AO+Cavity+Colour)material
- object mode 中，先陸續選中 `Shift + LMB` 各個皮帶 ，最後選中複雜 material 的物件。 `Ctrl + L`, link materials
- 在 texture paint 中 fill 着色, cavity:gray (mix:Overlay), AO:white (mix:Multiply)
- 然後把牙齒上色 imageTexture:colour

## 9.13 Fill Brush & Blend Modes

- 嘗試 fill brush 的各種 blend: mix, color, screen, 搭配 strength 的效果

## 9.14-15 Adjuest Roughness Maps

- draw on imageTexture:Roughness, 畫色將 saturation 降低到0
- 選擇 Brush(左上), tool(右側菜單第一), texture mask, 新建一個
- 到 texture(右側菜單) 中，選擇 type:Clouds, 試試看各種不同參數
- 畫黑色在 roughness 上就是較光亮
- 爲皮帶的邊緣磨損 修改 roughness map, 用 cloud + 白色 畫，避免畫到另一條可以先 取消 modifier:solidify (realtime)

## 9.16 Cleaning the Cavity Map

- 使用 "clone" 工具(左上)，清除 cavity 的小白線，按住 `Ctrl + MBL` 錨定複製來源點，再進行塗抹

## 9.17 Cavity Map to Roughness

- 爲身體作出 roughness map, 可以從 cavity map 進行 黑白reverse
- 複製 shader editor 的 cavity node 連到 BSDF.Roughness, 連接線中間插入 Color.InvertColor
- 在複製出的 cavity(roughness) node 後再加上 colorRamp node, 連到後面的 color.InvertColor
- `Ctrl + Shift + LMB` 選中 node, 可以只顯示到該node的效果
- 如果想將  cavity(roughness) node 加上 colorRamp, invertColor 後的結果複製一份，再進行針對 roughness 的局部塗改
- 新增一個 imageTexture "Orc Rough", Non-Color.
- 將  cavity(roughness) node 加上 colorRamp, invertColor 後的輸出連到 BSDF 上準備進行 bake, (Diffuse)

## 10.2 Setting Up the Rig

- `Shift + S` cursor to world origin
- add-on "rigify", `Shift + A` add armature.human
- data.ViewportDisplay enable "In Front"
- 如果有 reset scale, 記得要 `Ctrl + A` apply scale
- delete face bones, `Alt + LMB` 找到最後重疊的一塊 "face" bone

- 調整 bone 匹配位置
- 手指部分, 開啓 snap(上方磁鐵), 設定爲 volume. Transform Pivot Point: Median Point
- 如果其他bone干擾，可以 `Ctrl + I` 反選中其他, `H`: hide, `Alt + H`: unhide
- 記得用 box select 來拖動，避免單選圓球，讓指頭之間的連接脫離
- 確認手指的 roll 是正確的。Item > Transform > Tail : Roll。 右側 Data > Viewport Display > 選中顯示 Axes
- Axes 的 X 應該大約指向身後，會決定手指捲起的方向

## 10.3 Parenting the Rig

- object mode 選中 metarig, 確認 scale = 1.0, object center 在地面中間。 Data > Rigify > `Generate Rig`
- 產生 rig 後，就不再需要 metarig 了
- 新產生的 rig 再選中 Viewport display > In front
- 在 parenting 前，先確認各部位沒有 shrinkwrap modifier (apply it)
- parenting: 選中所有可見物件, 最後再 `Shift` 選中 armature 爲 active object. `Ctrl + P` Armature Deform.withAutomaticWeights

## 10.4 Weight Painting

- 頭左右轉動時候，下巴沒有跟著轉
- 在 pose mode, `A` 選所有bones, `Alt+R`, `Alt+G` 復位
- 到 data, bone collections, hide all bones.
- DEF 是 deform bones, 可視化
- 回到 object mode, 先選 DEF bones, 再選 object body (active)
- 到 weight paint mode, `Alt + LMB` 選中不同的 DEF bone, 看到顏色 weight
- 頭大骨下的 DEF-spine.005 對下巴有權重，造成影響。到右方 `N` 菜單.Tool.Options.Auto Normalize 選中，可以塗大骨時修正 spine.005 的權重

## 10.5 Shoulder Armour

- 將把肩甲 attach to empty
- 在 object mode 中，`Shift + RMB` 在肩甲上方中心 3D cursor
- `Shift + A` empty.arrows, scale 調整大小後, `Ctrl + A` apply scale to 1.0
- 先選中 肩甲, 再選中 empty.arrows, 然後 `Ctrl + P` parent, object 
- 然後 attach empty to bone: [obj mode] 選中 empty, 再 rig。 到 [edit mode] 選中 DEF bone (利用 `Alt + LMB`)
- 回到 [obj mode], `Ctrl + P` parent, 使用 "bone" 的方式， 完成 肩甲 的 attach。
- 這裡使用 empty.arrows 不是最好的辦法，只是因爲目前對 rig 瞭解不夠。比較好的是新增一個 bone.
 
## 10.6 Lighting

- render.Film.Transparent 取消勾選可以去掉 HDRI 的背景干擾，但仍保留 HDRI 的光線照明
- add "area light", data.Power to "50W", color to slightly yellow
- 常見的光設定(Studio lights): key light 小部位較強光 + fill light 大面積的柔光 + backlight 後方下偏上照,可嘗試不同顏色
- 把 shader editor (world) 的 background.Strength 降到 0.1, 留下一點 HDRI 光

- 調整好 pose 後, select all bones, `I` to add a key frame
- `Ctrl + Alt + 0` lock camera

