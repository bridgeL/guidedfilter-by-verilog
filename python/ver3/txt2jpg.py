import cv2
import numpy as np
import sys

(h, w) = img_size = (300, 210)

lnum = 0
img = np.zeros(img_size, np.uint8)  # 生成一个空灰度图像
with open('savedata.txt', 'r') as fd:
    for line in fd:
        if (lnum < h * w):
            i = (int(lnum / w)) % h
            j = (int(lnum % w)-2) % w
            c = line.strip('\n')
            if c == 'xxxx':
                c = '0'
            img[i, j] = int(c, 16)
        lnum += 1
    fd.close()

img0 = cv2.imread('img300x210.jpg', 0)

cv2.imwrite("./output.jpg", img)
cv2.imshow("Img1", img)
cv2.imshow("Img0", img0)

cv2.waitKey(0)
cv2.destroyAllWindows()


sys.exit(0)
