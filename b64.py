import urllib2

image = urllib2.urlopen('https://lahproject-16b32.firebaseio.com/base64string').read()
image = image[1:-1]
image = image.replace("\\r\\n", "")
fh = open("imageToSaveCurl.txt", "wb")
fh.write(image)
fh.close()
# print image
fh = open("imageToSave.png", "wb")
fh.write(image.decode('base64'))
fh.close()
