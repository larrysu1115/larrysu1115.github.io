---
layout: post
title: "Python implementation of [Colorization using Optimazation]"
description: "Python implementation of the paper: [Colorization using Optimazation] (Anat Levin, Dani Lischinski and Yair Weiss). The idea is that neighboring pixels in a photo should have similar color if their intensity levels are close. Thus it is possible to colorize a black-and-white photo with a little hints."
category: computer-vision
tags: [computer-vision, homepage]
image-url: /assets/img/2017/x_02_colorization_kv.jpg
---

<script type="text/javascript" async
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-MML-AM_CHTML">
</script>

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  displayAlign: "left",
  displayIndent: "0em",
  tex2jax: {inlineMath: [['$','$'], ['\\(','\\)']]}
});
</script>

# Colorization using optimization

This is a python implementation of the paper: [Colorization using Optimazation](http://www.cs.huji.ac.il/~yweiss/Colorization/) (Anat Levin, Dani Lischinski and Yair Weiss). The idea is that neighboring pixels in a photo should have similar color if their intensity levels are close. Thus it is possible to colorize a black-and-white photo with a little hints.

$$
J \big( U \big) = \sum_r \Big( U\big(r\big) - \sum_{s\in N(r)} w_{rs} U(s) \Big)^2
$$

r: a pixel (x,y)  
s: neighboring pixels of point r.  
$ w_{rs} $ : weight between points r and s.  
$ U \big( r \big) $ : chrominance channel "U" in YUV color space of pixel r

if 2 neighboring pixels have similar intensity (channel Y), then we assume they are more likely to have similar color (channel U &amp; V). Otherwise, they should have less similar color. To represent this weight, we use this affinity function (equation 2 in the paper).

$$
w_{rs} \propto \exp \Big( \frac{-\big( Y(r) - Y(s) \big)^2 }{2 \sigma_r^2} \Big)
$$

$ Y \big( r \big) $ : intensity value (channel Y) in YUV color space of pixel r.


```python
# import packages
import numpy as np
import matplotlib.pyplot as plt
import colorsys
import scipy
import logging
from scipy.misc import imread
np.set_printoptions(precision=8, suppress=True)

# set the photo file path
path_pic = '/Users/larrysu/repos/mconda3/cv01/ex_1.bmp'
path_pic_marked = '/Users/larrysu/repos/mconda3/cv01/ex_1_marked.bmp'
# window width
wd_width = 1

pic_o_rgb = imread(path_pic)
pic_o = pic_o_rgb.astype(float)/255
pic_m_rgb = imread(path_pic_marked)
pic_m = pic_m_rgb.astype(float)/255

fig = plt.figure()
fig.add_subplot(1,2,1).set_title('Black & White')
imgplot = plt.imshow(pic_o)
fig.add_subplot(1,2,2).set_title('Color Hints')
imgplot = plt.imshow(pic_m)
plt.show();
```


![png](/assets/img/2017/x_02_colorization_1_0.png)


With some human intervention, an image with "color hints" can be used to generate colors for all pixels on the photo. Before start, we need to prepare some useful functions:


```python
# the window class, find the neighbor pixels around the center.
class WindowNeighbor:
    def __init__(self, width, center, pic):
        # center is a list of [row, col, Y_intensity]
        self.center = [center[0], center[1], pic[center][0]]
        self.width = width
        self.neighbors = None
        self.find_neighbors(pic)
        self.mean = None
        self.var = None

    def find_neighbors(self, pic):
        self.neighbors = []
        ix_r_min = max(0, self.center[0] - self.width)
        ix_r_max = min(pic.shape[0], self.center[0] + self.width + 1)
        ix_c_min = max(0, self.center[1] - self.width)
        ix_c_max = min(pic.shape[1], self.center[1] + self.width + 1)
        for r in range(ix_r_min, ix_r_max):
            for c in range(ix_c_min, ix_c_max):
                if r == self.center[0] and c == self.center[1]:
                    continue
                self.neighbors.append([r,c,pic[r,c,0]])

    def __str__(self):
        return 'windows c=(%d, %d, %f) size: %d' % (self.center[0], self.center[1], self.center[2], len(self.neighbors))

# affinity functions, calculate weights of pixels in a window by their intensity.
def affinity_a(w):
    nbs = np.array(w.neighbors)
    sY = nbs[:,2]
    cY = w.center[2]
    diff = sY - cY
    sig = np.var(np.append(sY, cY))
    if sig < 1e-6:
        sig = 1e-6  
    wrs = np.exp(- np.power(diff,2) / (sig * 2.0))
    wrs = - wrs / np.sum(wrs)
    nbs[:,2] = wrs
    return nbs

# translate (row,col) to/from sequential number
def to_seq(r, c, rows):
    return c * rows + r

def fr_seq(seq, rows):
    r = seq % rows
    c = int((seq - r) / rows)
    return (r, c)

# combine 3 channels of YUV to a RGB photo: n x n x 3 array
def yuv_channels_to_rgb(cY,cU,cV):
    ansRGB = [colorsys.yiq_to_rgb(cY[i],cU[i],cV[i]) for i in range(len(ansY))]
    ansRGB = np.array(ansRGB)
    pic_ansRGB = np.zeros(pic_yuv.shape)
    pic_ansRGB[:,:,0] = ansRGB[:,0].reshape(pic_rows, pic_cols, order='F')
    pic_ansRGB[:,:,1] = ansRGB[:,1].reshape(pic_rows, pic_cols, order='F')
    pic_ansRGB[:,:,2] = ansRGB[:,2].reshape(pic_rows, pic_cols, order='F')
    return pic_ansRGB

def init_logger():
    FORMAT = '%(asctime)-15s %(message)s'
    logging.basicConfig(format=FORMAT, level=logging.DEBUG)
    logger = logging.getLogger()
    return logger
```

### Prepare the Matrix: A

The matrix A holds all the weights between each pixel. Because only pixels in a window have weight with each other, so this is a sparse matrix of size n &times; n (n is the total number of pixels)


```python
log = init_logger()
(pic_rows, pic_cols, _) = pic_o.shape
pic_size = pic_rows * pic_cols

channel_Y,_,_ = colorsys.rgb_to_yiq(pic_o[:,:,0],pic_o[:,:,1],pic_o[:,:,2])
_,channel_U,channel_V = colorsys.rgb_to_yiq(pic_m[:,:,0],pic_m[:,:,1],pic_m[:,:,2])

map_colored = (abs(channel_U) + abs(channel_V)) > 0.0001

pic_yuv = np.dstack((channel_Y, channel_U, channel_V))
weightData = []
num_pixel_bw = 0

# build the weight matrix for each window.
for c in range(pic_cols):
    for r in range(pic_rows):
        res = []
        w = WindowNeighbor(wd_width, (r,c), pic_yuv)
        if not map_colored[r,c]:
            weights = affinity_a(w)
            for e in weights:
                weightData.append([w.center,(e[0],e[1]), e[2]])
        weightData.append([w.center, (w.center[0],w.center[1]), 1.])

sp_idx_rc_data = [[to_seq(e[0][0], e[0][1], pic_rows), to_seq(e[1][0], e[1][1], pic_rows), e[2]] for e in weightData]
sp_idx_rc = np.array(sp_idx_rc_data, dtype=np.integer)[:,0:2]
sp_data = np.array(sp_idx_rc_data, dtype=np.float64)[:,2]

matA = scipy.sparse.csr_matrix((sp_data, (sp_idx_rc[:,0], sp_idx_rc[:,1])), shape=(pic_size, pic_size))
```

### Vector b

using chrominance channels U,V to get the vector $ \vec{b} $, then we can solve the equation:

$$
A \ \ \vec{x} = \vec{b}
$$


```python
b_u = np.zeros(pic_size)
b_v = np.zeros(pic_size)
idx_colored = np.nonzero(map_colored.reshape(pic_size, order='F'))
pic_u_flat = pic_yuv[:,:,1].reshape(pic_size, order='F')
b_u[idx_colored] = pic_u_flat[idx_colored]

pic_v_flat = pic_yuv[:,:,2].reshape(pic_size, order='F')
b_v[idx_colored] = pic_v_flat[idx_colored]
```

### Solve the optimazation problem


```python
log.info('Optimizing Ax=b')
ansY = pic_yuv[:,:,0].reshape(pic_size, order='F')
ansU = scipy.sparse.linalg.spsolve(matA, b_u)
ansV = scipy.sparse.linalg.spsolve(matA, b_v)
pic_ans = yuv_channels_to_rgb(ansY,ansU,ansV)
log.info('Optimized Ax=b')

fig = plt.figure()
fig.add_subplot(1,2,1).set_title('Black & White')
imgplot = plt.imshow(pic_o_rgb)
fig.add_subplot(1,2,2).set_title('Colorized')
imgplot = plt.imshow(pic_ans)
plt.show();
```

    2017-09-07 11:51:14,236 Optimizing Ax=b
    2017-09-07 11:51:15,258 Optimized Ax=b



![png](/assets/img/2017/x_02_colorization_9_1.png)


### Iterative method of optimization : jacobi

We can also implement a simple iterative method to find an answer close to the solution. Here shows the result of 50, 100, 300 iterations, more iteration will generate better result.

$$
A \ x = b
\\
D \ x = b - R x
\\
\to x^{k+1} = D^{-1} \big( b - R \ x \big)
$$

D: diagonal matrix of A.  
R: A - D


```python
# jacobi method for iterative optimization
def jacobi(A, b, x, n, verbose=False):
    D = A.diagonal()
    R = A - scipy.sparse.diags(D)
    for i in range(n):
        x = (b - R.dot(x)) / D
    return x

ansY = pic_yuv[:,:,0].reshape(pic_size, order='F')
ansU050 = jacobi(matA, b_u, x=np.zeros(matA.shape[0]), n=50)
ansV050 = jacobi(matA, b_v, x=np.zeros(matA.shape[0]), n=50)
ansU100 = jacobi(matA, b_u, x=np.zeros(matA.shape[0]), n=100)
ansV100 = jacobi(matA, b_v, x=np.zeros(matA.shape[0]), n=100)
ansU300 = jacobi(matA, b_u, x=np.zeros(matA.shape[0]), n=300)
ansV300 = jacobi(matA, b_v, x=np.zeros(matA.shape[0]), n=300)

pic_ans050 = yuv_channels_to_rgb(ansY,ansU050,ansV050)
pic_ans100 = yuv_channels_to_rgb(ansY,ansU100,ansV100)
pic_ans300 = yuv_channels_to_rgb(ansY,ansU300,ansV300)

fig = plt.figure(figsize=(8, 6))
fig.add_subplot(2,2,1).set_title('Black & White')
imgplot = plt.imshow(pic_o_rgb)
fig.add_subplot(2,2,2).set_title('Loop 50')
imgplot = plt.imshow(pic_ans050)
fig.add_subplot(2,2,3).set_title('Loop 100')
imgplot = plt.imshow(pic_ans100)
fig.add_subplot(2,2,4).set_title('Loop 300')
imgplot = plt.imshow(pic_ans300)
plt.tight_layout()
plt.show();
```

![img](/assets/img/2017/x_02_colorization_11_0.jpg)

### Try other photos

```python
path_pic = '/Users/larrysu/repos/mconda3/cv01/ex_2.bmp'
path_pic_marked = '/Users/larrysu/repos/mconda3/cv01/ex_2_marked.bmp'
# window width
wd_width = 1

pic_o_rgb = imread(path_pic, mode='RGB')
pic_o = pic_o_rgb.astype(float)/255

pic_m_rgb = imread(path_pic_marked)
pic_m = pic_m_rgb.astype(float)/255

# prepare matrix A
(pic_rows, pic_cols, _) = pic_o.shape
pic_size = pic_rows * pic_cols

channel_Y,_,_ = colorsys.rgb_to_yiq(pic_o[:,:,0],pic_o[:,:,1],pic_o[:,:,2])
_,channel_U,channel_V = colorsys.rgb_to_yiq(pic_m[:,:,0],pic_m[:,:,1],pic_m[:,:,2])

map_colored = (abs(channel_U) + abs(channel_V)) > 0.0001

pic_yuv = np.dstack((channel_Y, channel_U, channel_V))
weightData = []
num_pixel_bw = 0

# build the weight matrix for each window.
for c in range(pic_cols):
    for r in range(pic_rows):
        res = []
        w = WindowNeighbor(wd_width, (r,c), pic_yuv)
        if not map_colored[r,c]:
            weights = affinity_a(w)
            for e in weights:
                weightData.append([w.center,(e[0],e[1]), e[2]])
        weightData.append([w.center, (w.center[0],w.center[1]), 1.])

sp_idx_rc_data = [[to_seq(e[0][0], e[0][1], pic_rows), to_seq(e[1][0], e[1][1], pic_rows), e[2]] for e in weightData]
sp_idx_rc = np.array(sp_idx_rc_data, dtype=np.integer)[:,0:2]
sp_data = np.array(sp_idx_rc_data, dtype=np.float64)[:,2]

matA = scipy.sparse.csr_matrix((sp_data, (sp_idx_rc[:,0], sp_idx_rc[:,1])), shape=(pic_size, pic_size))

# prepare vector b
b_u = np.zeros(pic_size)
b_v = np.zeros(pic_size)
idx_colored = np.nonzero(map_colored.reshape(pic_size, order='F'))
pic_u_flat = pic_yuv[:,:,1].reshape(pic_size, order='F')
b_u[idx_colored] = pic_u_flat[idx_colored]

pic_v_flat = pic_yuv[:,:,2].reshape(pic_size, order='F')
b_v[idx_colored] = pic_v_flat[idx_colored]

# optimize the problem
ansY = pic_yuv[:,:,0].reshape(pic_size, order='F')
ansU = scipy.sparse.linalg.spsolve(matA, b_u)
ansV = scipy.sparse.linalg.spsolve(matA, b_v)
pic_ans = yuv_channels_to_rgb(ansY,ansU,ansV)

fig = plt.figure(figsize=(16, 13))
fig.add_subplot(2,2,1).set_title('Black & White')
imgplot = plt.imshow(pic_o_rgb)
fig.add_subplot(2,2,2).set_title('hints')
imgplot = plt.imshow(pic_m_rgb)
fig.add_subplot(2,2,3).set_title('Colorized')
imgplot = plt.imshow(pic_ans)
plt.show();
```

![img](/assets/img/2017/x_02_colorization_13_0.jpg)
