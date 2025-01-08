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
製作參考 UV Sphere 作出的 sprinkles.
使用 Geometry Nodes: 
Distribute Points on faces > Join Geometry > Instance on Points
Weight Paint 控制出現的部位
Expose value: density 設定可讓複製出的不同物件有不同 sprinkle density
修正實際尺寸，scale 的縮放與 apply，添加 math 運算 node 調整太大的輸入值
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

## Part 7 : Long Sprinkles

```
增加3種長度，和一個彎曲的 sprinkles.
使用 bevel 斜角處理圓柱兩端圓弧
彎曲的圓柱，利用 modifier:SimpleDeform 處理
利用 collection 管理物件的群組
collection:long sprinkles 爲第二個 donut 的 geometryNode.DistriPoints 來源引用物件。
處理 geometryNode 的 rotation 平貼在表面
```

- 3D cursor: `Shift + 右鍵` 可以改變 3D cursor 的位置
- add cylinder: vertices: 12, radius: 0.001m, depth: 0.001m
- 太靠近 cylinder 會消失: 修正 `N` properties, tab:view, clip start 改爲 0.001 m.
- 加長 cylinder: scale z-axis
- bevel: 爲 cylinder 兩端增加圓弧 bevel(斜角). 在 edit mode 中按上方 Select mode: face select. `Ctrl + B` 增加 bevel, 如果 scroll 就會增加層更圓潤。 
- 增加 長/中 兩種長度 cylinder: `shift + D` duplicate, 選中上方 vertices `g` 拉長。
- 要先 apply scale, 下面的 bend 才會正常彎曲
- 增加 彎曲 bend cylinder: `Ctrl + R` 再 scroll 增加 cylinder 圓柱的 mesh 到 8 圈，使用 modifier:SimpleDeform, tab:Bend
- origin point: 每個物件的質量中心，關於旋轉/彎曲/... 都有關係。選中物件 > 右鍵 > Set Origin > Origin to Geometry
- Organize Collections: 增加 collection:sprinkles > Round,Long. 將對應物件移入。也可用 viewport 畫面選中物件, `m` move to collection
- 複製一個用長條 sprinkle 的 donut: 選中 icing + donut, `Shift + D` duplicate, 複製出的 donut 的 icing 的 geometry nodes 右邊顯示 2, 代表被 2 物件共用。點擊 `2` 可讓不再共用。
- 重新命名 modifier 的 geometry nodes 爲 round sprinkles, long sprinkles
- 修改 geometry nodes:long sprinkles, 注意圖釘不要釘住了，釘住永遠選定當時的物件的geo nodes.
- 將包含 long sprinkles 的 collection 拉入 Geometry nodes 面板上，以新出現的 collection info 替換掉之前的 object info. 此時出現在奇怪的上方位置，可以勾選 separate + reset children 修正。
- InstanceOnPoints 勾選 Pick Instance 才會選擇單一物件，而不是四個 long sprinkles 一起
- 接入 DistriPoints.Rotation 到 InstanceOnPoints.Rotation, 讓 sprinkle 垂直 donut 表面
- rotate long sprinkles 90度，就可以 平貼表面，記得需要 `Ctrl + a`, apply rotation 才會生效。
- DistriPoints.Rotation 到 InstanceOnPoints.Rotation 之間加入 Utilities > Rotation > "Rotate Rotation". 
- 將 rotate By 小圓點拉出，新增 Random Value, z 軸線的 max: tau (2*pi ~=6.28)
- 將 sprinkle 調整 scale 1.5 (InstanceOnPoints), max distance: 0.006 (DistribuPointsOnFaces)
- 按住左鍵下拉一次選中3個數，一起修改

## Part 8 : Render

```
讓 sprinkles 物件共享 material,
使用 shade.ColorRamp 的 constant 模式賦予不同固定色
colorRamp 同區段加上對應的 roughness, 金屬 屬性, 展現 金/銀 色。
render 實時 engine: EEVEE, 真光影:Cycles
```

- Link Materials: 讓多物件共享同一 material. 先選擇有要共享的物件，然後 `Shift + 左鍵` 逐一選擇其他來共享的物件， 
最後再選回有要共享的物件。 `Ctrl + L` link materials. 完成後可以見到被共享的 material 右側有數字代表被幾個共享。
- shade > object info node: 到 shading 下，add (input > object info) node, random 連到 base Color
- shade > color ramp node: add (converter > color ramp) node, 位於 random 與 base Color 中. 改變顏色，linear 換成 constant, `+` 多個區段不同顏色
- 金屬色澤: `Ctrl + Shift + D` 複製 color ramp node. 將 color 連到 Base Color, 右側 黃(金)白(銀)範圍設定爲白(1), 其他不要金屬色澤設定爲黑(0), 去除掉無用的區隔。
- 將 roughness 設定降低，光滑鏡面就有金屬材質感。
- render: `F12`
- camera view: `Numpad 0`
- fly mode (View > Navigation > Fly Navigation): 先選中 camera, 再按 `Shift ~`. 就可用 `WASD qe` 遊戲般控制視角，scroll 控制速度。設定好點擊左鍵完成。
- render engine: 右側菜單中，render 預設是 EEVEE
- 右側菜單 Scene Properties > Light Probes > Sphere Resolution 改到 4096 px
- Render props: Fast GI Approximation > Bias 調整值
- render engine: Cycles (offline render, path trace, ray traced)
- preference > system > cycle render > graphic card
- `alt + G` reset object to center
- icing 讓材質柔軟 materials > subsurface. weight=1.0, Radius 的預設值是給皮膚，這裡不適用，XYZ(RGB)都改成1, scale=0.005m (厚度)
- sprinkles 也做材質柔軟 scale=0.002m

## Part 9 : Layout

```
製作盤子，以 circle 開始，增加中間空心的圓面，
將外圈 extrude 拉伸出高起的多個外圈，
以 bevel 製作高起外圈直角的弧度，
增厚盤子 modifier:solidify，再 apply, 
邊緣也用 bevel 做圓弧合起，Clamp 可接合。再 merge by distance 去除重疊的點。
複製出多個 donut, 並給不同顏色的 icing.
盤子給上泛黃材質。
```

- vertical split: 到上方兩個 menu 交界，cursor 變不同的地方按右鍵，vertical split 畫面會分成左右兩個。
- 合併兩個畫面是在 交界 處，鼠標圖示不同的地方右鍵。或 畫面 右上角 拖動。
- 製作 plate 盤子
- `Z` 鍵會帶出各種模式選擇 wireframe, render, ...
- edit mode 選中的 face 應呈現半橘色。沒色就是空的沒有 face.
- 盤子 circle 中間圓面是空的。選中邊緣一圈，`f` 產生面。
- 增加直角上的斜角。使用 edge-select mode (不是 vertex-select), `Alt LeftMouse`, `Shift` 選中要增加 bevel 的數個圈圈，`Ctrl + b`一起增加
- 盤子沒有厚度。增加 modifier:solidify, 厚度 0.004m
- 先 apply solidify。盤子最邊緣用斜角合起。選中兩側 edge 兩圈, `Ctrl + b` 增加斜角，`scroll` 增加面，注意下方提示 `Clamp` 讓兩個變貼合不重疊上。
- merge by distance, 到 edit mode, 選中物件所有點 `A`, 按下 merge `M`, 選擇 by distance, 會看到下方 幾百個 vertices 被 merge 的訊息。
- 要做 merge by distance 是因爲上面做了 bevel 合併 edge, 有些點會在同樣的地方。
- 將盤子放到平臺貼合
- `Ctrl + Alt + 0` 將 camera 設定爲目前的 view
- 選中 icing + donut, `Shift + D` duplicate, 上移 再 rotate 貼合堆疊。
- 複製處的 donut, rotate 角度不同。要再進行 rotate 時候可以按兩次 `Z` + `Z` 旋轉軸變成該 donut 自己的方向。
- 讓每個 donut icing 顏色不同。按下每個 donut 的 material 右側數字(共用)， 重新命名 material, 改顏色。
- 盤子材質 : 泛黃白色，roughness:0.15, subsurface:weight=1,radius=1,1,1

## Part 10 : Light

```
使用 world > Sky Texture 造出空間日光，
用 cube 製作房間。
對齊房間與地板用 grab `g`, `b` 進入 snap mode.
刪除 cube 重複的底和後背，去除 z-fighting
左側開窗 insect, x 刪除 face
右側面爲 black 不反光
```

- Sky Texture 全場自然光: world > color > texture > Sky Texture
- 太亮調 Render > Color Management > Exposure
- Sky Texture: sun rotation 旋轉太陽角度
- sun elevation: 如 日出,正午,日落，改成 15 度
- sun size: 預設0.545是地球與太陽相對真實量。改成 2.0 ~ 3.0 之間，讓影子邊緣較柔軟。
- donut 盤子與後方背景牆距離 3個盤子，方便後續製造景深模糊失焦。
- sky light 從四面八方照入，需要有個房間窗戶照入光的感覺。
- 增加 mesh > cube
- 需要將 cube 的一角對齊背景地板,牆直角。按下 `g`, 再按下 `b` 進入 snap mode, 此時遊標會變化選定 點,線,中點,面，再選定要貼齊的對象點,線,...
- `g` > `b` 的 snap mode 下, 按住 `alt + 中鍵` 可以旋轉畫面視角
- 其他幾個面，先進入 `face-select mode`, 再用 snap mode 貼合。
- 將 cube 的底和後 兩面刪除。edge-select, `x` 選擇 face.
- cube 左側牆開窗。選中左側face, `i` insect 拉出窗的面，`x` 刪除 face
- 右側牆希望是不會反光，像是房間深處。選中 cube 的 material 加 white, black walls 兩種 material, black wall 的 Surface 選 Diffuse BSDF 可以減低 cycles renderer 的負擔。
- 在 edit mode, 選中右側牆，在 material 中選擇 black walls 再按 `Assign`
- import model: import blender model 是用 `File > Append` 通常是選 collection
- install addon: 下載的 zip 不需解開

## Part 11 : Composition

```
composition 是 post processing 過程，
作出亮點光暈效果
```

- 在右側加入一個 area lighting
- Composition: 上方菜單 composition, 上方 勾選 Use Nodes, 按下 `Home` 會將 node圖 置中。
- 右側 Render 設定: Sampling > Render > Max Samples ( 100 作爲這個練習就夠用，比較快。4096可在正式時候用。)
- Viewer Node: 背景出現 render 圖: `Ctrl + Shift 左鍵點 Render Layer`, `Alt + 中鍵` 拖動背景圖，以及 Viewer Node。
- `V`, `Alt + V`: zoom-in, out 背景的 render. 或點 viewer node 再拖動。
- 右側 Render 設定: Color management > Look > High Contrast
- 亮晶晶: add filter > glare, 亮點streaks:16, threshold:越低亮的區域越多, mix:1完全只有效果
- 亮霧化: duplicate 
- add: color > mix > mix color, 將 image 的線接入，blending mode:add, fac:0.01
- 別用 compositor 入魔了
- 下方畫面，左上小按鈕選擇 General > 3D viewport, 此時右邊的小下拉箭頭按鈕 viewport shading > compositor > always
- lens distortion: 可以作出貓眼鏡頭效果
- 右菜單 output > post processing > pipeline: 可以將 compositing 取消

## Part 12 : Animation

## Part 13 : Render

## Part 14 : Final
