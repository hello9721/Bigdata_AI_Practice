import sys
import pymysql
import numpy as np
import pandas as pd

from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *

import matplotlib.pyplot as plt
from matplotlib import font_manager, rc
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas

import tensorflow as tf
import tensorflow.keras as keras
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import SimpleRNN, LSTM, GRU, Dropout, Dense
from sklearn.preprocessing import MinMaxScaler

class MyApp(QWidget) :                  # 클래스 정의

    def __init__(self) :
        
        super().__init__()              # 부모클래스 생성자 호출(가장 위쪽 코딩)
        self.initUI()
        
    def initUI(self) :                  # 윈도우 환경 구성