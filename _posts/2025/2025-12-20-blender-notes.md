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

