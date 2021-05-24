# from scipy.cluster.vq import kmeans2
import matplotlib.pyplot as plt
from sklearn.datasets import make_blobs
# from sklearn.cluster import KMeans
from scipy.cluster.vq import vq, kmeans, whiten,kmeans2
from numpy import array
import scipy.io
import os
import hdf5storage
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from numpy import random
from scipy import cluster
from matplotlib import pyplot
# =============================================================================
# Load spectral data for 600 phrases
mat = hdf5storage.loadmat('/uufs/chpc.utah.edu/common/home/u6027723/Downloads/final_3_result/data_457.mat')
x_pred = mat['D']
# Load warping paths for 600 phrases
warping_path = hdf5storage.loadmat('/uufs/chpc.utah.edu/common/home/u6027723/Downloads/final_3_result/a_b_457.mat')
y_pred = warping_path['A']
# z = np.empty((0, 482))
print('x_pred=',x_pred.shape)
print('y_pred=',y_pred.shape)

d = x_pred
a = y_pred
print('d,Done=',d.shape)
print('a,Done=',a.shape)
# Clustering step
centroid, label = kmeans2(d , 6, minit='points')
# =============================================================================
# Collect Clusters
index_1_test = np.where(label == 0)
D_D1 = d[label == 0]
A_A1 = a[label == 0]
print('D_D1=',D_D1.shape)
print('A_A1=',A_A1.shape)

index_2_test = np.where(label == 1)
D_D2 = d[label == 1]
A_A2 = a[label == 1]
print('D_D2=',D_D2.shape)
print('A_A2=',A_A2.shape)

index_3_test = np.where(label == 2)
D_D3 = d[label == 2]
A_A3 = a[label == 2]
print('D_D3=',D_D3.shape)
print('A_A3=',A_A3.shape)

index_4_test = np.where(label == 3)
D_D4 = d[label == 3]
A_A4 = a[label == 3]
print('D_D4=',D_D4.shape)
print('A_A4=',A_A4.shape)

index_5_test = np.where(label == 4)
D_D5 = d[label == 4]
A_A5 = a[label == 4]
print('D_D5=',D_D5.shape)
print('A_A5=',A_A5.shape)

index_6_test = np.where(label == 5)
D_D6 = d[label == 5]
A_A6 = a[label == 5]
print('D_D6=',D_D6.shape)
print('A_A6=',A_A6.shape)

# =============================================================================
# Save Clusterl Spectraing Data
scipy.io.savemat('Path for saving cluster spectral data 1/y_pred_11_test'+'.mat',mdict={'Y_D_D1':D_D1})
scipy.io.savemat('Path for saving cluster spectral data 2/y_pred_21_test'+'.mat',mdict={'Y_D_D2':D_D2})
scipy.io.savemat('Path for saving cluster spectral data 3/y_pred_31_test'+'.mat',mdict={'Y_D_D3':D_D3})
scipy.io.savemat('Path for saving cluster spectral data 4/y_pred_41_test'+'.mat',mdict={'Y_D_D4':D_D4})
scipy.io.savemat('Path for saving cluster spectral data 5/y_pred_51_test'+'.mat',mdict={'Y_D_D5':D_D5})
scipy.io.savemat('Path for saving cluster spectral data 6/y_pred_61_test'+'.mat',mdict={'Y_D_D6':D_D6})
# Save Clustering warping paths
scipy.io.savemat('Path for saving cluster warping paths 1/x_pred_11_test'+'.mat',mdict={'X_A_A1':A_A1})
scipy.io.savemat('Path for saving cluster warping paths 2/x_pred_21_test'+'.mat',mdict={'X_A_A2':A_A2})
scipy.io.savemat('Path for saving cluster warping paths 3/x_pred_31_test'+'.mat',mdict={'X_A_A3':A_A3})
scipy.io.savemat('Path for saving cluster warping paths 4/x_pred_41_test'+'.mat',mdict={'X_A_A4':A_A4})
scipy.io.savemat('Path for saving cluster warping paths 5/x_pred_51_test'+'.mat',mdict={'X_A_A5':A_A5})
scipy.io.savemat('Path for saving cluster warping paths 6/x_pred_61_test'+'.mat',mdict={'X_A_A6':A_A6})
# Save Clustering index
scipy.io.savemat('Path for saving cluster index 1/index_11_test'+'.mat',mdict={'INDEX_1':index_1_test})
scipy.io.savemat('Path for saving cluster index 2/index_21_test'+'.mat',mdict={'INDEX_2':index_2_test})
scipy.io.savemat('Path for saving cluster index 3/index_31_test'+'.mat',mdict={'INDEX_3':index_3_test})
scipy.io.savemat('Path for saving cluster index 4/index_41_test'+'.mat',mdict={'INDEX_4':index_4_test})
scipy.io.savemat('Path for saving cluster index 5/index_51_test'+'.mat',mdict={'INDEX_5':index_5_test})
scipy.io.savemat('Path for saving cluster index 6/index_61_test'+'.mat',mdict={'INDEX_6':index_6_test})

