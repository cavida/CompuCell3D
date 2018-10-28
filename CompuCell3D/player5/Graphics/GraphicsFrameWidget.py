# todo - check simulation replay
# todo - resolve the issue of imports in the CompuCellSetup

from weakref import ref
import string
import DefaultData
import Configuration
from PyQt5 import QtCore, QtGui, QtOpenGL, QtWidgets
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from enums import *
from GraphicsOffScreen import GenericDrawer
from Utilities import ScreenshotData
from Utilities import qcolor_to_rgba, cs_string_to_typed_list
import sys

platform = sys.platform
if platform == 'darwin':
    from Utilities.QVTKRenderWindowInteractor_mac import QVTKRenderWindowInteractor
else:
    from Utilities.QVTKRenderWindowInteractor import QVTKRenderWindowInteractor
MODULENAME = '---- GraphicsFrameWidget.py: '


class GraphicsFrameWidget(QtWidgets.QFrame):
    def __init__(self, parent=None, originatingWidget=None):
        QtWidgets.QFrame.__init__(self, parent)
        self.is_screenshot_widget = False
        self.qvtkWidget = QVTKRenderWindowInteractor(self)  # a QWidget

        self.setAttribute(QtCore.Qt.WA_DeleteOnClose)

        # MDIFIX
        self.parentWidget = ref(originatingWidget)

        self.plane = None
        self.planePos = None

        self.lineEdit = QtWidgets.QLineEdit()

        self.init_cross_section_actions()
        self.cstb = self.initCrossSectionToolbar()

        layout = QtWidgets.QBoxLayout(QtWidgets.QBoxLayout.TopToBottom)
        layout.addWidget(self.cstb)
        layout.addWidget(self.qvtkWidget)
        self.setLayout(layout)
        self.setMinimumSize(100, 100)  # needs to be defined to resize smaller than 400x400
        self.resize(600, 600)

        self.qvtkWidget.Initialize()
        self.qvtkWidget.Start()

        # todo 5 - adding generic drawer

        self.gd = GenericDrawer()
        self.gd.set_interactive_camera_flag(True)
        self.current_screenshot_data = None

        self.camera2D = self.gd.get_active_camera()
        self.camera3D = self.gd.get_renderer().MakeCamera()

        self.renWin = self.qvtkWidget.GetRenderWindow()
        self.renWin.AddRenderer(self.gd.get_renderer())

        self.metadata_fetcher_dict = {
            'CellField': self.get_cell_field_metadata,
            'ConField': self.get_con_field_metadata,
            'ScalarField': self.get_con_field_metadata,
            'ScalarFieldCellLevel': self.get_con_field_metadata,
            'VectorField': self.get_con_field_metadata,
            'VectorFieldCellLevel': self.get_vector_field_metadata,
        }

    def copy_camera(self, src, dst):
        """
        Copies camera settings
        :param src: 
        :param dst: 
        :return: None
        """
        dst.SetClippingRange(src.GetClippingRange())
        dst.SetFocalPoint(src.GetFocalPoint())
        dst.SetPosition(src.GetPosition())
        dst.SetViewUp(src.GetViewUp())

    def get_metadata(self, field_name, field_type):
        """
        Fetches a dictionary that summarizes graphics/configs settings for the current scene
        :param field_name: {str} field name
        :param field_type: {str} field type
        :return: {dict}
        """
        try:
            metadata_fetcher_fcn = self.metadata_fetcher_dict[field_type]
        except KeyError:
            return {}

        metadata = metadata_fetcher_fcn(field_name=field_name, field_type=field_type)

        return metadata

    def get_cell_field_metadata(self, field_name, field_type):
        """
        Returns dictionary of auxiliary information needed to cell field
        :param field_name:{str} field_name
        :param field_type: {str} field type
        :return: {dict}
        """

        metadata_dict = self.get_color_metadata(field_name=field_name, field_type=field_type)
        return metadata_dict

    def get_color_metadata(self, field_name, field_type):
        """
        Returns dictionary of auxiliary information needed to render borders
        :param field_name:{str} field_name
        :param field_type: {str} field type
        :return: {dict}
        """
        metadata_dict = {}
        metadata_dict['BorderColor'] = qcolor_to_rgba(Configuration.getSetting('BorderColor'))
        metadata_dict['ClusterBorderColor'] = qcolor_to_rgba(Configuration.getSetting('ClusterBorderColor'))
        metadata_dict['BoundingBoxColor'] = qcolor_to_rgba(Configuration.getSetting('BoundingBoxColor'))
        metadata_dict['AxesColor'] = qcolor_to_rgba(Configuration.getSetting('AxesColor'))
        metadata_dict['ContourColor'] = qcolor_to_rgba(Configuration.getSetting('ContourColor'))
        metadata_dict['WindowColor'] = qcolor_to_rgba(Configuration.getSetting('WindowColor'))
        # todo - fix color of fpp links
        metadata_dict['FppLinksColor'] = qcolor_to_rgba(Configuration.getSetting('ContourColor'))

        return metadata_dict

    def get_con_field_metadata(self, field_name, field_type):
        """
        Returns dictionary of auxiliary information needed to render a give scene
        :param field_name:{str} field_name
        :param field_type: {str} field type
        :return: {dict}
        """

        # metadata_dict = {}
        metadata_dict = self.get_color_metadata(field_name=field_name, field_type=field_type)
        con_field_name = field_name
        metadata_dict['MinRangeFixed'] = Configuration.getSetting("MinRangeFixed", con_field_name)
        metadata_dict['MaxRangeFixed'] = Configuration.getSetting("MaxRangeFixed", con_field_name)
        metadata_dict['MinRange'] = Configuration.getSetting("MinRange", con_field_name)
        metadata_dict['MaxRange'] = Configuration.getSetting("MaxRange", con_field_name)
        metadata_dict['ContoursOn'] = Configuration.getSetting("ContoursOn", con_field_name)
        metadata_dict['NumberOfContourLines'] = Configuration.getSetting("NumberOfContourLines", field_name)
        metadata_dict['ScalarIsoValues'] = cs_string_to_typed_list(
            Configuration.getSetting("ScalarIsoValues", field_name))
        metadata_dict['LegendEnable'] = Configuration.getSetting("LegendEnable", field_name)

        return metadata_dict

    def get_vector_field_metadata(self, field_name, field_type):
        """
        Returns dictionary of auxiliary information needed to render a give scene
        :param field_name:{str} field_name
        :param field_type: {str} field type
        :return: {dict}
        """

        metadata_dict = self.get_con_field_metadata(field_name=field_name, field_type=field_type)
        metadata_dict['ArrowLength'] = Configuration.getSetting('ArrowLength', field_name)
        metadata_dict['FixedArrowColorOn'] = Configuration.getSetting('FixedArrowColorOn', field_name)
        metadata_dict['ArrowColor'] = qcolor_to_rgba(Configuration.getSetting('ArrowColor', field_name))
        metadata_dict['ScaleArrowsOn'] = Configuration.getSetting('ScaleArrowsOn', field_name)

        return metadata_dict

    def initialize_scene(self):
        """
        initialization function that sets up field extractor for the generic Drawer
        :return:
        """
        tvw = self.parentWidget()
        self.current_screenshot_data = self.compute_current_screenshot_data()

        self.gd.set_field_extractor(field_extractor=tvw.fieldExtractor)

    def get_current_field_name_and_type(self):
        """
        Returns current field name and type
        :return: {tuple}
        """
        tvw = self.parentWidget()
        field_name = str(self.fieldComboBox.currentText())

        try:
            field_type = tvw.fieldTypes[field_name]
        except KeyError:
            return field_name, ''
            # raise KeyError('Could not figure out the type of the field {} you requested'.format(field_name))

        return field_name, field_type

    def compute_current_screenshot_data(self):
        """
        Computes/populates Screenshot Description data based ont he current GUI configuration
        for the current window
        :return: {screenshotData}
        """

        scr_data = ScreenshotData()
        self.store_gui_vis_config(scr_data=scr_data)

        projection_name = str(self.projComboBox.currentText())
        projection_position = int(self.projSpinBox.value())

        field_name, field_type = self.get_current_field_name_and_type()
        scr_data.plotData = (field_name, field_type)

        metadata = self.get_metadata(field_name=scr_data.plotData[0], field_type=scr_data.plotData[1])

        if projection_name == '3D':
            scr_data.spaceDimension = '3D'
        else:
            scr_data.spaceDimension = '2D'
            scr_data.projection = projection_name
            scr_data.projectionPosition = projection_position

        scr_data.metadata = metadata

        return scr_data

    def store_gui_vis_config(self, scr_data):
        """
        Stores visualization settings such as cell borders, on/or cell on/off etc...

        :param scr_data: {instance of ScreenshotDescriptionData}
        :return: None
        """
        tvw = self.parentWidget()

        scr_data.cell_borders_on = tvw.borderAct.isChecked()
        scr_data.cells_on = tvw.cellsAct.isChecked()
        scr_data.cluster_borders_on = tvw.clusterBorderAct.isChecked()
        scr_data.cell_glyphs_on = tvw.cellGlyphsAct.isChecked()
        scr_data.fpp_links_on = tvw.FPPLinksAct.isChecked()
        scr_data.lattice_axes_on = Configuration.getSetting('ShowHorizontalAxesLabels') or Configuration.getSetting(
            'ShowVerticalAxesLabels')
        scr_data.lattice_axes_labels_on = Configuration.getSetting("ShowAxes")
        scr_data.bounding_box_on = Configuration.getSetting("BoundingBoxOn")

        invisible_types = Configuration.getSetting("Types3DInvisible")
        invisible_types = invisible_types.strip()

        if invisible_types:
            scr_data.invisible_types = list(map(lambda x: int(x), invisible_types.split(',')))
        else:
            scr_data.invisible_types = []

    def render_repaint(self):
        """

        :return:
        """
        self.Render()

    def draw(self, basic_simulation_data):
        """
        Main drawing function - calls draw fcn from the GenericDrawer. All drawing happens there
        :param basic_simulation_data: {instance of BasicSimulationData}
        :return: None
        """

        if self.current_screenshot_data is None:
            self.initialize_scene()

        self.gd.clear_display()

        self.current_screenshot_data = self.compute_current_screenshot_data()

        self.gd.draw(screenshot_data=self.current_screenshot_data, bsd=basic_simulation_data, screenshot_name='')

        # this call seems to be needed to refresh qvtk widget
        self.gd.get_renderer().ResetCameraClippingRange()
        # essential call to refresh screen . otherwise need to move/resize graphics window
        self.Render()

        # self.qvtkWidget.zoomIn()
        # self.qvtkWidget.zoomOut()

    def setStatusBar(self, statusBar):
        """
        Sets status bar
        :param statusBar:
        :return:
        """
        self._statusBar = statusBar

    def configsChanged(self):
        """

        :return:
        """
        print 'configsChanged'

    def Render(self):
        color = Configuration.getSetting("WindowColor")
        self.gd.get_renderer().SetBackground(float(color.red()) / 255, float(color.green()) / 255,
                                             float(color.blue()) / 255)
        self.qvtkWidget.Render()

    def getCamera(self):
        """
        Conveenince function that fetches active camera obj
        :return: {vtkCamera}
        """
        return self.getActiveCamera()

    def getActiveCamera(self):

        return self.gd.get_active_camera()

    def getCamera3D(self):
        """
        Convenince function that fetches 3D camera obj
        :return: {vtkCamera}
        """
        return self.camera3D


    # def setActiveCamera(self, _camera):
    #     return self.ren.SetActiveCamera(_camera)

    def getCamera2D(self):
        return self.camera2D

    def setZoomItems(self, _zitems):
        # todo 5
        # self.draw2D.setZoomItems(_zitems)
        # self.draw3D.setZoomItems(_zitems)
        print 'set zoom items'


    def setPlane(self, plane, pos):
        (self.plane, self.planePos) = (str(plane).upper(), pos)
        # print (self.plane, self.planePos)

    def getPlane(self):
        """
        Gets current plane tuple
        :return: {tuple} (plane label, plane position)
        """
        return (self.plane, self.planePos)

    def initCrossSectionToolbar(self):
        """
        Initializes crosse section toolbar
        :return: None
        """

        cstb = QtWidgets.QToolBar("CrossSection", self)
        # viewtb.setIconSize(QSize(20, 18))
        cstb.setObjectName("CrossSection")
        cstb.setToolTip("Projection")

        # new technique (rwh, May 2011), instead of individual radio buttons as originally done (above)
        cstb.addWidget(self.projComboBox)
        cstb.addWidget(self.projSpinBox)

        cstb.addWidget(self.fieldComboBox)
        cstb.addAction(self.screenshotAct)

        return cstb

    def init_cross_section_actions(self):
        """
        Initializes actions associated with the cross section toolbar
        :return: None
        """

        self.projComboBoxAct = QtWidgets.QAction(self)
        self.projComboBox = QtWidgets.QComboBox()
        self.projComboBox.addAction(self.projComboBoxAct)

        # NB: the order of these is important; rf. setInitialCrossSection where we set 'xy' to be default projection
        self.projComboBox.addItem("3D")
        self.projComboBox.addItem("xy")
        self.projComboBox.addItem("xz")
        self.projComboBox.addItem("yz")

        self.projSBAct = QtWidgets.QAction(self)
        self.projSpinBox = QtWidgets.QSpinBox()
        self.projSpinBox.addAction(self.projSBAct)

        self.fieldComboBoxAct = QtWidgets.QAction(self)
        self.fieldComboBox = QtWidgets.QComboBox()  # Note that this is different than the fieldComboBox in the Prefs panel (rf. SimpleTabView.py)
        self.fieldComboBox.addAction(self.fieldComboBoxAct)
        self.fieldComboBox.addItem("-- Field Type --")
        # self.fieldComboBox.addItem("cAMP")  # huh?

        gip = DefaultData.getIconPath
        self.screenshotAct = QtWidgets.QAction(QtGui.QIcon(gip("screenshot.png")), "&Take Screenshot", self)

    def proj_combo_box_changed(self):
        """
        slot reacting to changes in the projection combo box
        :return: None
        """

        tvw = self.parentWidget()

        if tvw.completedFirstMCS:
            tvw.newDrawingUserRequest = True
        name = str(self.projComboBox.currentText())
        self.currentProjection = name

        if self.currentProjection == '3D':  # disable spinbox

            self.projSpinBox.setEnabled(False)
            self.setDrawingStyle("3D")
            if tvw.completedFirstMCS:
                tvw.newDrawingUserRequest = True

        elif self.currentProjection == 'xy':
            self.projSpinBox.setEnabled(True)
            self.projSpinBox.setValue(self.xyPlane)
            self.proj_spin_box_changed(self.xyPlane)

        elif self.currentProjection == 'xz':
            self.projSpinBox.setEnabled(True)

            self.projSpinBox.setValue(self.xzPlane)
            self.proj_spin_box_changed(self.xzPlane)

        elif self.currentProjection == 'yz':
            self.projSpinBox.setEnabled(True)

            self.projSpinBox.setValue(self.yzPlane)
            self.proj_spin_box_changed(self.yzPlane)

        self.current_screenshot_data = self.compute_current_screenshot_data()

        tvw._drawField()  # SimpleTabView.py

        # self.qvtkWidget.zoomIn()
        # self.qvtkWidget.zoomOut()

        # self.Render()
        # self.render_repaint()

    def proj_spin_box_changed(self, val):
        """
        Slot that reacts to position spin boox changes
        :param val: {int} number corresponding to the position of the crosse section
        :return: None
        """

        tvw = self.parentWidget()

        if tvw.completedFirstMCS:
            tvw.newDrawingUserRequest = True

        self.setDrawingStyle("2D")

        if self.currentProjection == 'xy':
            if val > self.xyMaxPlane: val = self.xyMaxPlane
            self.projSpinBox.setValue(val)
            self.setPlane(self.currentProjection, val)  # for some bizarre(!) reason, val=0 for xyPlane
            self.xyPlane = val

        elif self.currentProjection == 'xz':
            if val > self.xzMaxPlane: val = self.xzMaxPlane
            self.projSpinBox.setValue(val)
            self.setPlane(self.currentProjection, val)
            self.xzPlane = val

        elif self.currentProjection == 'yz':
            if val > self.yzMaxPlane: val = self.yzMaxPlane
            self.projSpinBox.setValue(val)
            self.setPlane(self.currentProjection, val)
            self.yzPlane = val

        self.current_screenshot_data = self.compute_current_screenshot_data()
        # SimpleTabView.py
        tvw._drawField()

    def field_type_changed(self):
        """
        Slot reacting to the field type combo box changes
        :return: None
        """

        tvw = self.parentWidget()
        if tvw.completedFirstMCS:
            tvw.newDrawingUserRequest = True
        field_name, field_type = self.get_current_field_name_and_type()

        tvw.setFieldType((field_name, field_type))
        self.current_screenshot_data = self.compute_current_screenshot_data()
        tvw._drawField()

    def setDrawingStyle(self, _style):
        """
        Function that wires-up the widget to behave according tpo the dimension of the visualization
        :param _style:{str} '2D' or '3D'
        :return: None
        """

        style = string.upper(_style)
        if style == "2D":
            self.draw3DFlag = False
            self.gd.get_renderer().SetActiveCamera(self.camera2D)
            self.qvtkWidget.setMouseInteractionSchemeTo2D()
        elif style == "3D":
            self.draw3DFlag = True
            self.gd.get_renderer().SetActiveCamera(self.camera3D)
            self.qvtkWidget.setMouseInteractionSchemeTo3D()


    def set_camera_from_graphics_window_data(self,camera, gwd):
        """
        Sets camera from graphics window data
        :param camera: {vtkCamera} camera obj
        :param gwd: {instance og GrtaphicsWindowData}
        :return: None
        """
        camera.SetClippingRange(gwd.cameraClippingRange)
        camera.SetFocalPoint(gwd.cameraFocalPoint)
        camera.SetPosition(gwd.cameraPosition)
        camera.SetViewUp(gwd.cameraViewUp)

    def apply_3D_graphics_window_data(self, gwd):
        """
        Applies graphics window configuration data (stored on a disk) to graphics window (3D version)
        :param gwd: {instrance of GraphicsWindowData}
        :return: None
        """

        for p in xrange(self.projComboBox.count()):

            if str(self.projComboBox.itemText(p)) == '3D':
                self.projComboBox.setCurrentIndex(p)
                # notice: there are two cameras one for 2D and one for 3D  here we set camera for 3D
                self.set_camera_from_graphics_window_data(camera=self.camera3D, gwd=gwd)
                break

    def apply_2D_graphics_window_data(self, gwd):
        """
        Applies graphics window configuration data (stored on a disk) to graphics window (2D version)
        :param gwd: {instrance of GraphicsWindowData}
        :return: None
        """

        for p in xrange(self.projComboBox.count()):

            if str(self.projComboBox.itemText(p)).lower() == str(gwd.planeName).lower():
                self.projComboBox.setCurrentIndex(p)
                # print 'self.projSpinBox.maximum()= ', self.projSpinBox.maximum()    
                # if gwd.planePosition <= self.projSpinBox.maximum():
                self.projSpinBox.setValue(gwd.planePosition)  # automatically invokes the callback (--Changed)

                # notice: there are two cameras one for 2D and one for 3D  here we set camera for 2D
                self.set_camera_from_graphics_window_data(camera=self.camera2D, gwd=gwd)

    def apply_graphics_window_data(self, gwd):
        """
        Applies graphics window configuration data (stored on a disk) to graphics window (2D version)
        :param gwd: {instrance of GraphicsWindowData}
        :return: None
        """

        for i in xrange(self.fieldComboBox.count()):

            if str(self.fieldComboBox.itemText(i)) == gwd.sceneName:

                self.fieldComboBox.setCurrentIndex(i)
                # setting 2D projection or 3D
                if gwd.is3D:
                    self.apply_3D_graphics_window_data(gwd)
                else:
                    self.apply_2D_graphics_window_data(gwd)

                break


    def getGraphicsWindowData(self):
        """

        :return:
        """
        tvw = self.parentWidget()
        print 'UPDATE getGraphicsWindowData'

        from GraphicsWindowData import GraphicsWindowData
        gwd = GraphicsWindowData()
        activeCamera = self.getActiveCamera()
        # gwd.camera = self.getActiveCamera()
        gwd.sceneName = str(self.fieldComboBox.currentText())
        gwd.sceneType = tvw.fieldTypes[gwd.sceneName]
        # gwd.winType = 'graphics'
        gwd.winType = GRAPHICS_WINDOW_LABEL
        # winPosition and winPosition will be filled externally by the SimpleTabView , since it has access to mdi windows

        # gwd.winPosition = self.pos()
        # gwd.winSize = self.size()

        if self.current_screenshot_data.spaceDimension == '3D':
            gwd.is3D = True
        else:

            gwd.planeName = self.current_screenshot_data.projection
            gwd.planePosition = self.current_screenshot_data.projectionPosition

        gwd.cameraClippingRange = activeCamera.GetClippingRange()
        gwd.cameraFocalPoint = activeCamera.GetFocalPoint()
        gwd.cameraPosition = activeCamera.GetPosition()
        gwd.cameraViewUp = activeCamera.GetViewUp()

        return gwd

    def add_screenshot_conf(self):
        """
        Adds screenshot configuration data for a current scene
        :return: None
        """
        tvw = self.parentWidget()
        print MODULENAME, '  _takeShot():  self.renWin.GetSize()=', self.renWin.GetSize()
        camera = self.getActiveCamera()

        if tvw.screenshotManager is not None:
            field_name = str(self.fieldComboBox.currentText())

            field_type = tvw.fieldTypes[field_name]
            field_name_type_tuple = (field_name, field_type)
            print MODULENAME, '  _takeShot():  fieldType=', field_name_type_tuple

            if self.draw3DFlag:
                metadata = self.get_metadata(field_name=field_name, field_type=field_type)
                tvw.screenshotManager.add3DScreenshot(field_name, field_type, camera, metadata)
            else:
                plane, position = self.getPlane()
                metadata = self.get_metadata(field_name=field_name, field_type=field_type)
                tvw.screenshotManager.add2DScreenshot(field_name, field_type, plane,
                                                      position, camera, metadata)

    def setConnects(self, _workspace):  # rf. Plugins/ViewManagerPlugins/SimpleTabView.py

        self.projComboBox.currentIndexChanged.connect(self.proj_combo_box_changed)
        self.projSpinBox.valueChanged.connect(self.proj_spin_box_changed)

        self.fieldComboBox.currentIndexChanged.connect(self.field_type_changed)

        self.screenshotAct.triggered.connect(self.add_screenshot_conf)

    def setInitialCrossSection(self, basic_simulation_data):

        fieldDim = basic_simulation_data.fieldDim

        self.updateCrossSection(basic_simulation_data)

        # new (rwh, May 2011)
        self.currentProjection = 'xy'  # rwh

        # set to be 'xy' projection by default, regardless of 2D or 3D sim?
        self.projComboBox.setCurrentIndex(1)

        self.projSpinBox.setMinimum(0)

        self.projSpinBox.setMaximum(10000)

        # If you want to set the value from configuration
        self.projSpinBox.setValue(fieldDim.z / 2)

    def updateCrossSection(self, basic_simulation_data):

        field_dim = basic_simulation_data.fieldDim
        self.xyMaxPlane = field_dim.z - 1
        #        self.xyPlane = fieldDim.z/2 + 1
        self.xyPlane = field_dim.z / 2

        self.xzMaxPlane = field_dim.y - 1
        self.xzPlane = field_dim.y / 2

        self.yzMaxPlane = field_dim.x - 1
        self.yzPlane = field_dim.x / 2

    def takeSimShot(self, *args, **kwds):
        print 'CHANGE - TAKE SIM SHOT'

    def setFieldTypesComboBox(self, _fieldTypes):
        # return
        self.fieldTypes = _fieldTypes  # assign field types to be the same as field types in the workspace

        self.fieldComboBox.clear()
        self.fieldComboBox.addItem("-- Field Type --")
        self.fieldComboBox.addItem("Cell_Field")
        for key in self.fieldTypes.keys():
            if key != "Cell_Field":
                self.fieldComboBox.addItem(key)
        self.fieldComboBox.setCurrentIndex(1)  # setting value of the Combo box to be cellField - default action

        # self.qvtkWidget.resetCamera() # last call triggers fisrt call to draw function so
        # we here reset camera so that all the actors are initially visible

        # todo 5 - essential initialization of the default cameras
        # last call triggers fisrt call to draw function so we here reset camera so that
        # all the actors are initially visible
        self.resetCamera()
        self.copy_camera(src=self.camera2D, dst=self.camera3D)

    def zoomIn(self):
        '''
        Zooms in view
        :return:None
        '''
        self.qvtkWidget.zoomIn()

    def zoomOut(self):
        '''
        Zooms in view
        :return:None
        '''
        self.qvtkWidget.zoomOut()

    def resetCamera(self):
        '''
        Resets camera to default settings
        :return:None
        '''
        self.qvtkWidget.resetCamera()

    # note that if you close widget using X button this slot is not called
    # we need to reimplement closeEvent
    # def close(self):

    def closeEvent(self, ev):
        """

        :param ev:
        :return:
        """
        print 'CHANGE and update closeEvent'

        # print '\n\n\n closeEvent GRAPHICS FRAME'

        # cleaning up to release memory - notice that if we do not do this cleanup this widget will not be destroyed and will take sizeable portion of the memory
        # not a big deal for a single simulation but repeated runs can easily exhaust all system memory
        # todo 5 - old code
        # self.clearEntireDisplay()

        self.qvtkWidget.close()
        self.qvtkWidget = None

        tvw = None

