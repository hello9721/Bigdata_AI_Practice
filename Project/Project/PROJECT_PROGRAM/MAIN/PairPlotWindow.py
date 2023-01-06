from PyQt5.QtGui import *
from PyQt5.QtCore import *
from PyQt5.QtWidgets import *
import seaborn as sns

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as fic

class PairPlot(QDialog):
    
    def __init__(self, info) :
        
        super().__init__()
        self.initUI(info)
        
    def initUI(self, info):

        layout_main = QHBoxLayout()

        pp = sns.pairplot(info.today_data, kind="hist")
        self.canv_pplot = fic(pp.fig)

        layout_main.addWidget(self.canv_pplot)

        self.setLayout(layout_main)
        self.setWindowTitle('Pair Plot')
        self.setGeometry(0, 30, 700, 700)
        self.show()
        
    def showModal(self):
        
        return super().exec_()