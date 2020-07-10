import cv2
import numpy as np
import sys

(h, w) = img_size = (450, 320)


def GetStockTxt(path):
    global img_size
    lnum = 0
    img = np.zeros(img_size, np.uint8)  # 生成一个空灰度图像
    with open(path, 'r') as fd:
        for line in fd:
            if (lnum < h * w):
                i = (int(lnum / w)) % h
                j = int(lnum % w)
                img[i, j] = int(line.strip('\n'), 16)
            lnum += 1
        fd.close()
    return img


# 生成一个空灰度图像

B = GetStockTxt('savedataBlue.txt')
G = GetStockTxt('savedataGreen.txt')
R = GetStockTxt('savedataRed.txt')

img = cv2.merge([B, G, R])

cv2.imwrite("./output.jpg", img)
cv2.namedWindow("Image")
cv2.imshow("Image", img)
cv2.waitKey(0)
cv2.destroyAllWindows()


sys.exit(0)
