from PyQt5 import QtCore, QtGui, QtWidgets

from PyQt5.QtWidgets import *
from PyQt5.QtCore import *

class SteeringPanelView(QtWidgets.QTableView):

    def __init__(self, *args, **kwargs):
        QtWidgets.QTableView.__init__(self, *args, **kwargs)
        # self._model = None
    # def setModel(self, model):
    #     self._model = model
    #     super(SteeringPanelView, self).setModel(model)

    def mousePressEvent(self, event):
        if event.button() == Qt.LeftButton:
            index = self.indexAt(event.pos())
            col_name = self.get_col_name(index)
            if col_name == 'Value':
                self.edit(index)
        else:
            super(SteeringPanelView, self).mousePressEvent(event)
        # QTableView.mousePressEvent(event)

    def get_col_name(self, index):

        model = index.model()
        return model.header_data[index.column()]

    def sizeHint(self):
        """
        Implements basic
        :return:
        """
        row_count = min(self.model().rowCount()+1, 20)
        row_size = self.rowHeight(0)

        sugested_vsize = row_count*row_size
        return QSize(600,sugested_vsize)
