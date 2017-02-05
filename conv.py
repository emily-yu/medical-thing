import cv2
import numpy as np
import sys

face_cascade = cv2.CascadeClassifier('haarcascade_frontalface_default.xml')


# names = ["kevin.jpg","lilia.jpg","michael.png"]
# names = ["lilia.jpg"]
# names = ["michael.jpg"]
# names = ["kevin.jpg"]
#
# for name in names:

name = sys.argv[1]

print name
img = cv2.imread(name)
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)


scaled = cv2.resize(gray,(32,32))

spl = name.split(".jpg")
spl3 = spl[0]+"Small.jpg"
print spl3
cv2.imwrite(spl3,scaled);

# cv2.namedWindow("Final", 0);
# cv2.resizeWindow("Final", 500,500);

# cv2.imshow('img',img)
# cv2.waitKey(0)
# cv2.destroyAllWindows()
