# encoding:utf-8
import numpy as np
import cv2
import sys

# ver python 3.5

# Load an color image in grayscale
img = cv2.imread('img300x210.jpg', 0)

rows, cols = img.shape
# print rows,cols
print(rows, cols)
grey = img[0, 0]

fp = open("imgdata.txt", "wt")
fpz = open("savedata.txt", "wt")

for i in range(0, rows):
    for j in range(0, cols):
        p = img[i, j]
        char_tmp = "@"+str(hex(i*cols+j))+'\n'
        fp.write(char_tmp.replace('0x', ''))
        char_tmp = str(hex(p))+"\n"
        fp.write(char_tmp.replace('0x', ''))
        fpz.write(str(hex(p))+"\n")
fp.close()
fpz.close()

cv2.namedWindow("Image")
cv2.imshow("Image", img)
cv2.waitKey(0)
cv2.destroyAllWindows()

sys.exit(0)
