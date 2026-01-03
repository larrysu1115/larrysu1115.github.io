---
layout: post
title: "Blender Rig"
description: ""
category: [3D-model]
tags: [blender, 3d]
---

# Rig Notes

Blender Character Creator for Video Games (Updated to 4.2)

# Sculpt Mode

- mesh filter: 選擇 filter 的類型 "smooth" 後，從左拉到右邊應用強度
- `Alt + Q`: 切換物件
- remesh: `R`: remesh 單位大小, `Ctrl + R`: remesh
- brushes: `V`: draw, `G`: grab, 
- Crease brush: `Shift + C`: Crease皺褶, 添加小細節. 同時按 `Ctrl` 會拉起
- brush (Clay Strips): 肌肉線條效果，之後再 smooth 弱化
- `Ctrl + J`: 合併物件，但邊際仍存在。之後可以 remesh 完成邊際混合。
- outliner 中有 face-orientation 選項可看出是否 face 內朝外導致異常問題, `Shift + N` recalculate normals 可以解決
- `Ctrl + 2`: subdivision modifier

- `Shift + RMB` : Cursor 位置設定
- `Alt + MMB`: 設定旋轉中心

- 技巧: 使用 cube 建 subdivision modifier, 然後 extrude, scale 製作獸人牙齒
- 技巧: 多個面置於水平, 選取所有面 `S` scale, `Z` z-axis, `0` 歸零
- 技巧: 設定 object origin, 在 edit mode 選中面，`Shift + S` cursor to selected,  object mode "Set origin", "origin to 3D cursor"



- `g` + `g` : 沿着原來的線條上 grab, edge slide
- `Ctrl + RMB`: extrude as `e` in edit mode
- shortest path selection: 先選中一線段，再 `Ctrl + LMB` 選中另一線段，會將之間一起選起 

- 移除 link : Object > Relations > Make Single User > Object & Data

- 繪圖板 : main button 設爲 MMB, secondary button 爲 RMB

- `/`: local view 隱藏其他物件
- `X`: 刪除 點線面, 其中 "disolve edges" 可移除線段保留結構
- `Ctrl + X`: "disolve edges" 移除線段保留結構
- `Ctrl + R`: loop cut 將面上多增加環繞線
- `Shift + Tab`: turn off snapping
- snap when grab: `G` grab, hold `CTRL`, then move
- `P`: separate, edit mode (mesh > separate > selection)

- modifier solidify: 增加厚度, 內外層有問題用 offset 調整
- modifier shrinkwrap: 貼近指定的物件的面, 注意其他 modifier 的順序

- 選擇物件按下 `Alt` 可從多個中挑選

- propotional editing `O`:

## Clothing

## Retopology

- instant mesh: 
  - 先 join, remesh, (350K Faces)
  - apply decimate modifier 降低 mesh 後 (70K Faces)
  - export wavefront (.obj) 檔案, selection only
  - use [instant-meshes](https://github.com/wjakob/instant-meshes)
  - solve 使用 comb (梳子) 劃定垂直中分線，然後 export, extract, save 回到 blender (10K Faces)
  - 用 auto mirror 後, 再將 eye 周圍 indent, 
  - 結果 orc body  (10K Faces )
- modifier decimate: 降低 poly 

- finger retopology: 
  - 先用 8 邊 circle, shrinkwrap + snap extrude 到指尖, 
  - 最後 `F` fill 面, 在面上的點 `J` join 出兩條線再修形狀

- `M` merge: mesh > merge > by distance 將重疊的點合併
- `M` merge: 選擇兩個電後，`M` merge, "at last" 點合併
- `L` select linked: 在 edit mode 一個物件有多個不相連的部位，可以鼠標移動到一個部位, 按下 `L` 就會選中該部位。

- smooth vertices: 先選中 loop edges 一圈，如果有些參差不齊，用 vertax > smooth vertices 然後調整強度就會較平齊
- select more/less: `Ctrl +/-` 先選指尖的面，然後一圈一圈加入選擇
- scale by normal: `Alt + S` 將形體按照原先的垂直向量延伸擴大

- `Ctrl + E` edge bridge: edge > "bridge edge" loops 在 edit mode 中將兩邊一樣多的 edge 之間用面連接

- knife tool `K`

- dissolve edges `Ctrl + X`: 移除四邊形中的對角線, 也可用 `X` > dissolve edges

- `I` insect + `B` boundary

- grid fill: face > "grid fill" 將兩邊填格子連起

- add-ons: "Mesh:LoopTools" 讓 loop 中的多個 edge 平均分佈. RMB > "LoopTools" > "Space", 可再調整 influence

- `V` split vertex: 將一個點分成兩個，可以再左右拉開

- subdivided : 選中邊，點 RMB 選 subdivide, 可將邊切兩段

- 將左右對稱, 到 sculpting mode, X 對稱, 下拉選單, symmetrize

- Sculpting mode, Line Project 切斷小腿平面, 可用 `F` flip

## Detailed Sculpt

- brush: "scrape" 刷出金屬質感

- extrude along normals: 讓最下一圈的面延伸出. 選中一圈面，`Alt + E`, "extrude along normals"