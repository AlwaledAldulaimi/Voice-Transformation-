# Python code for trainig data coming from 2-level DW matlab for the 3 ip 1 op
import tensorflow as tf
from tensorflow import keras
# from keras.utils import multi_gpu_model
from sklearn.model_selection import train_test_split
import timeit
start11 = timeit.default_timer()
import numpy
import numpy as np
import scipy.io
import os
import smtplib
import pandas as pd
import matplotlib.pyplot as plt

## Train Data, Data prepar
mat1 = scipy.io.loadmat('x_train.mat') # loading Training data
x_train_split = mat1['X_TRAIN']

mat2 = scipy.io.loadmat('y_train.mat') # loading Training data
y_train_split = mat2['Y_TRAIN']

mat3 = scipy.io.loadmat('x_valid.mat') # loading Validation data
x_valid_split = mat3['X_VALID']

mat4 = scipy.io.loadmat('y_valid.mat') # loading Validation data
y_valid_split = mat4['Y_VALID']

mat5 = scipy.io.loadmat('x_pred.mat') # loading Predication data
x_pred_455 = mat5['X_PRED']

mat6 = scipy.io.loadmat('y_pred.mat') # loading Predication data
y_pred_455 = mat6['Y_PRED']


mat = scipy.io.loadmat('data_600_3_diff.mat')
x_train_600_phrases = mat['DDD']

warping_path = scipy.io.loadmat('a_b_3_diff_1_600.mat')
y_train_600_phrases = warping_path['AAA']

print('x_train_600=',x_train_600_phrases.shape)  # print the size of whole train data for the whole 600 phrases
print('y_train_600=',y_train_600_phrases.shape)
print('x_train_split=',x_train_split.shape)
print('y_train_split=',y_train_split.shape)
print('x_valid_split=',x_valid_split.shape)
print('y_valid_split=',y_valid_split.shape)
print('x_pred_455=',x_pred_455.shape) # print the size of whole train data for one phrase of 455 spectral vectors
print('y_pred_455=',y_pred_455.shape)


start1 = timeit.default_timer()
keras.backend.clear_session()  # Initializations 
np.random.seed(42)
tf.random.set_seed(42)

# =============================================================================
model = keras.models.Sequential([
    keras.layers.InputLayer(input_shape=x_train_600_phrases.shape[1:]), # need to be modified
    keras.layers.Dense(1000, activation="relu"),
    keras.layers.Dense(1000, activation="relu"),
    keras.layers.Dense(2000, activation="relu"),
    keras.layers.Dense(2960, activation="relu"),
    keras.layers.Dense(1960, activation="relu"),
    keras.layers.Dense(1960, activation="relu"),
    keras.layers.Dense(964)
])

# This part of the code responsible for restore the modelm
# model = keras.models.load_model('Path for file.h5')

model.compile(loss=tf.keras.losses.MeanAbsoluteError(),
                optimizer="sgd")#,

checkpoint_csv_log = keras.callbacks.CSVLogger('/Path to create and record the .csv file/my_log_test.csv',separator=';')
checkpoint_cb = keras.callbacks.ModelCheckpoint('/Path to create and record the .h5 file/modeltest{epoch:04d}-{loss:3f}.h5',period=50)
callbaks_list = [checkpoint_cb,checkpoint_csv_log]
 
history = model.fit(x_train_split, y_train_split, batch_size=11,epochs=5000,
                     validation_data=(x_valid_split, y_valid_split),
                     callbacks=callbaks_list)

print('Time: ', (stop - start1)/60, 'mim')
 
model.summary()
model.save('/Path to save the .h5 file/h5_files/my_test6.h5',)
 
mae_test1 = model.evaluate(x_valid_split,y_valid_split) # Evaluation step
y_pred = model.predict(x_pred_455) # Prediction step
print('Y_PRED=',y_pred.shape)
##model.save('/Path to save the .h5 file/my_Modetest_tf',save_format='tf')
 
stop1 = timeit.default_timer()
print('Time: ', (stop1 - start11)/60, 'mim')  
# Plot some segnets of speech
plt.figure(figsize=(10,10))
for i in range(56):
    plt.subplot(7,8,i+1)
    plt.xticks([])
    plt.yticks([])
    plt.grid(False)
    plt.plot(y_pred[i,:482])
    plt.plot(y_pred_455[i,:482])
    plt.xlabel(['segment'+ str(i)])
    fig1 = plt.gcf()
plt.close(fig1)
# Save .mat file
scipy.io.savemat('a_3_diff,'+str(5000)+'.mat',mdict={'y_pred_final':y_pred})
# =============================================================================

