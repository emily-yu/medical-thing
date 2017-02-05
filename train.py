import tensorflow as tf
import numpy as np
import input_data
import cv2
from scipy import misc
from matplotlib import pyplot as plt
import sys
from bottle import route, run, template, static_file, get, post, request
import urllib2


def initWeight(shape):
    weights = tf.truncated_normal(shape,stddev=0.1)
    return tf.Variable(weights)

def initBias(shape):
    bias = tf.constant(0.1,shape=shape)
    return tf.Variable(bias)

def conv2d(x,W):
    return tf.nn.conv2d(x,W,strides=[1,1,1,1],padding="SAME")

def maxPool2d(x):
    return tf.nn.max_pool(x,ksize=[1,2,2,1],strides=[1,2,2,1],padding="SAME")

sess = tf.InteractiveSession()


# NOW FOR THE GRAPH BUILDING
x = tf.placeholder("float", shape=[None, 1024])
y_ = tf.placeholder("float", shape=[None, 4])

# turn the pixels into the a matrix
xImage = tf.reshape(x,[-1,32,32,1])
# xImage = x;

# conv layer 1
wConv1 = initWeight([5,5,1,32])
bConv1 = initBias([32])
# turns to 16x16 b/c pooling
hConv1 = tf.nn.relu(conv2d(xImage,wConv1) + bConv1)
hPool1 = maxPool2d(hConv1)

# conv layer 2
wConv2 = initWeight([5,5,32,64])
bConv2 = initBias([64])
# turns to 8x8 b/c pooling
hConv2 = tf.nn.relu(conv2d(hPool1,wConv2) + bConv2)
hPool2 = maxPool2d(hConv2)

# fully connected layer
W_fc1 = initWeight([8 * 8 * 64, 1024])
b_fc1 = initBias([1024])

# resize the 7x7x64 into a 1-D array so we can matmul it.
h_pool2_flat = tf.reshape(hPool2, [-1, 8*8*64])
h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)

# dropout for the FC layer.
keep_prob = tf.placeholder("float")
h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)

# weights to turn to softmax classify
W_fc2 = initWeight([1024, 4])
b_fc2 = initBias([4])
y_conv = tf.nn.softmax(tf.matmul(h_fc1_drop, W_fc2) + b_fc2)

cross_entropy = -tf.reduce_sum(y_*tf.log(y_conv  + 1e-9))
train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)
correct_prediction = tf.equal(tf.argmax(y_conv,1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))


sess.run(tf.initialize_all_variables())

si = 4;
sl = ["f","k","l","m"]
sn = ["Kevin_Fang","Kevin_Frans","Lilia_Tang","Michael_Huang"]

batch = np.zeros((si*6,1024))
labels = np.zeros((si*6,si))





saver = tf.train.Saver()

if sys.argv[1] == "train":
    ti = 0
    for siii in range(si):
        for sxxx in range(6):
            labels[ti] = np.zeros([si])
            labels[ti][siii] = 1;

            loc = sl[siii]+""+str(sxxx+1)+".jpg"
            print loc
            batch[ti] = misc.imread(loc).flatten()
            ti += 1
    batch = batch/225.0

    for i in range(20000):
        if i%10 == 0:
            print "hi"
            train_accuracy = accuracy.eval(feed_dict={x:batch, y_: labels, keep_prob: 1.0})
            print "step %d, training accuracy %g"%(i, train_accuracy)
            # result = y_conv.eval(feed_dict={x: batch, y_: labels, keep_prob: 1.0})
            # for k in range(18):
            #     print "lmao %d %s" % (k, np.array_str(result[k]))
        if i%50 == 0:
            saver.save(sess, "/Users/kevin/Documents/Python/facial-detection/training.ckpt", global_step=i)

        train_step.run(feed_dict={x: batch, y_: labels, keep_prob: 0.5})
elif sys.argv[1] == "server":
    print "server"
else:
    saver.restore(sess, tf.train.latest_checkpoint("/Users/kevin/Documents/Python/facial-detection/"))
    batch = np.zeros((1,1024))
    batch[0] = misc.imread(sys.argv[1]).flatten()
    print y_conv.eval(feed_dict={x: batch, y_: labels, keep_prob: 1.0})


@route('/')
def index():
    return "same"

login = ""

@post('/login') # or @route('/login', method='POST')
def do_login():
    global login

    saver.restore(sess, tf.train.latest_checkpoint("/Users/kevin/Documents/Python/facial-detection/"))
    image = urllib2.urlopen('https://signatureauthentication.firebaseio.com/image.json').read()
    image = image[1:-1]
    image = image.replace("\\r\\n", "")

    fh = open("imageToSave.png", "wb")
    fh.write(image.decode('base64'))
    fh.close()

    img = cv2.imread("imageToSave.png")
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    scaled = cv2.resize(gray,(32,32))
    cv2.imwrite("imageToSaveSmall.jpg",scaled);

    batch = np.zeros((1,1024))
    batch[0] = misc.imread("imageToSaveSmall.jpg").flatten()
    pr = y_conv.eval(feed_dict={x: batch, y_: labels, keep_prob: 1.0})
    login = sn[np.argmax(pr)];
    print "login is " + login
    print sn[np.argmax(pr)];
    return sn[np.argmax(pr)];



@post('/loggedin')
def loggedin():
    global login
    print request.forms.get('username') + " is trying to login, it is: " + login + "asd"
    if(login == request.forms.get('username')):
        print "got in"
        login = ""
        return "true"
    elif(login == ""):
        login = ""
        return "false"
    else:
        tmp = login
        login = ""
        return tmp


@get('/reset')
def reseto():
    global login
    print "reset"
    login = ""



run(host='localhost', port=8000)


  # print i

# print("test accuracy %g"%accuracy.eval(feed_dict={
#     x: mnist.test.images, y_: mnist.test.labels, keep_prob: 1.0}))
