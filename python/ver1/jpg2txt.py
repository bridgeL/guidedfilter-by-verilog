# encoding:utf-8
import numpy as np
import cv2
import sys

# ver python 3.5


def img2txt(img, name):
    rows, cols = img.shape
    # print rows,cols
    print(name, ':', rows, cols)
    grey = img[0, 0]

    fp = open("imgdata" + name + ".txt", "wt")
    fpz = open("savedata" + name + ".txt", "wt")

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


# Load an color image in grayscale
img = cv2.imread('img450x320.jpg')

(B, G, R) = cv2.split(img)

img2txt(B, 'Blue')
img2txt(G, 'Green')
img2txt(R, 'Red')

cv2.namedWindow("Image")
cv2.imshow("Image", img)
cv2.waitKey(0)
cv2.destroyAllWindows()

sys.exit(0)
