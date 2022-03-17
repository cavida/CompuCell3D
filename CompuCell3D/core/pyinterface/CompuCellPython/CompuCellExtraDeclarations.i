

// ************************************************************
// SWIG Declarations
// ************************************************************


// ************************************************************
// SWIG Declarations
// ************************************************************

// Where possible, classes are presneted to SWIG via %include.
// SWIG simply uses the definition in the include file and builds
// wrappers based on it.

// In a few cases (e.g. Field3D), SWIG became confused and could not
// properly handle the header file.  These classes and support definitions
// are explicitly handled here.

// Additionally, the definitions for some of the third party classes
// are explicit here.  This may change in the future.

// ******************************
// SWIG Libraries
// ******************************


// C++ std::string handling
%include "std_string.i"

// C++ std::map handling
%include "std_map.i"

// C++ std::map handling
%include "std_set.i"



// C++ std::vector handling
%include "std_vector.i"


%include "Potts3D/Cell.h"
%include "Field3D/Point3D.h"
%include "Field3D/Dim3D.h"
%include <NeighborFinderParams.h>
%include <CompuCell3D/Field3D/Array3D.h>

using namespace CompuCell3D;



//%include "Field3D/Field3DChangeWatcher.h"
//%template(cellchangewatcher) CompuCell3D::Field3DChangeWatcher<CompuCell3D::Cell *>;

//%include "Potts3D/CellChangeWatcher.h"
%include <CompuCell3D/Automaton/Automaton.h>
%include <CompuCell3D/Potts3D/Potts3D.h>
%include "Steppable.h"
%include "ClassRegistry.h"
%include "Simulator.h"


%include <PyCompuCellObjAdapter.h>
%include <EnergyFunctionPyWrapper.h>
%include <ChangeWatcherPyWrapper.h>
%include <TypeChangeWatcherPyWrapper.h>
%include <StepperPyWrapper.h>

%include <CompuCell3D/steppables/PDESolvers/DiffusableVector.h>
%template (DiffusableVectorFloat) DiffusableVector<float>;

// %nothread PyAttributeAdder;
%include <PyAttributeAdder.h>




%include "ParseData.h"
%include "ParserStorage.h"

%template (VectorParseDataPtr) std::vector<ParseData*> ;


//have to include all  export definitions for modules which are arapped to avoid problems with interpreting by swig win32 specific c++ extensions...
#define COMPUCELLLIB_EXPORT
#define BOUNDARYSHARED_EXPORT
#define CHEMOTAXISSIMPLE_EXPORT
#define CHEMOTAXIS_EXPORT
#define MITOSIS_EXPORT
#define MITOSISSTEPPABLE_EXPORT
#define NEIGHBORTRACKER_EXPORT
#define PIXELTRACKER_EXPORT
#define BOUNDARYPIXELTRACKER_EXPORT
#define CONTACTLOCALFLEX_EXPORT
#define CONTACTLOCALPRODUCT_EXPORT
#define CONTACTMULTICAD_EXPORT
#define CELLORIENTATION_EXPORT
#define POLARIZATIONVECTOR_EXPORT
#define ELASTICITYTRACKER_EXPORT
#define ELASTICITY_EXPORT
#define PLASTICITYTRACKER_EXPORT
#define PLASTICITY_EXPORT
#define CONNECTIVITYLOCALFLEX_EXPORT
#define CONNECTIVITYGLOBAL_EXPORT
// #define LENGTHCONSTRAINTLOCALFLEX_EXPORT
#define LENGTHCONSTRAINT_EXPORT
#define MOLECULARCONTACT_EXPORT 
#define FOCALPOINTPLASTICITY_EXPORT
#define MOMENTOFINERTIA_EXPORT 
#define ADHESIONFLEX_EXPORT
#define CENTEROFMASS_EXPORT
//AutogeneratedModules1 - DO NOT REMOVE THIS LINE IT IS USED BY TWEDIT TO LOCATE CODE INSERTION POINT
//BiasVectorSteppable_autogenerated1
#define BIASVECTORSTEPPABLE_EXPORT
//ImplicitMotility_autogenerated1
#define IMPLICITMOTILITY_EXPORT
//CurvatureCalculator_autogenerated1
#define CURVATURECALCULATOR_EXPORT
//OrientedGrowth_autogenerated1
#define ORIENTEDGROWTH_EXPORT
//OrientedGrowth2_autogenerated1
#define ORIENTEDGROWTH2_EXPORT
//CleaverMeshDumper_autogenerated1
#define CLEAVERMESHDUMPER_EXPORT
// // // //CGALMeshDumper_autogenerated1
// // // #define CGALMESHDUMPER_EXPORT
//ContactOrientation_autogenerated1
#define CONTACTORIENTATION_EXPORT
//BoundaryMonitor_autogenerated1
#define BOUNDARYMONITOR_EXPORT
//CellTypeMonitor_autogenerated1
#define CELLTYPEMONITOR_EXPORT
//Polarization23_autogenerated1
#define POLARIZATION23_EXPORT
//ClusterSurface_autogenerated1
#define CLUSTERSURFACE_EXPORT

//ClusterSurfaceTracker_autogenerated1
#define CLUSTERSURFACETRACKER_EXPORT

%define PLUGINACCESSOR(pluginName)   
// #ifdef #extraHeader != -1
// %include <CompuCell3D/plugins/ ## pluginName/extraHeader ## .h>
// #endif

    %include <CompuCell3D/plugins/ ## pluginName/pluginName ## Plugin.h>

    %inline %{
    pluginName ## Plugin * get ## pluginName ## Plugin(){
            return (pluginName ## Plugin *)Simulator::pluginManager.get(#pluginName);
        }
    %}

%enddef

%inline %{
   PyObject * getPyAttrib(CompuCell3D::CellG * _cell){
      Py_INCREF(_cell->pyAttrib);
      return _cell->pyAttrib;
   }
   
   bool isPyAttribValid(CompuCell3D::CellG * _cell){
      return (bool) _cell->pyAttrib;

   }   
%}

//Plugins

%include "ExtraMembers.h"


%inline %{
   Plugin * getPlugin(std::string _pluginName){
      return (Plugin *)Simulator::pluginManager.get(_pluginName);
   }

   Steppable * getSteppable(std::string _steppableName){
      return (Steppable *)Simulator::steppableManager.get(_steppableName);
   }


%}

//ConnectivityLocalFlex

%include <CompuCell3D/plugins/ConnectivityLocalFlex/ConnectivityLocalFlexData.h>
%template (connectivitylocalflexaccessor) ExtraMembersGroupAccessor<ConnectivityLocalFlexData>; //necessary to get ConnectivityLocalFlexData accessor working
PLUGINACCESSOR(ConnectivityLocalFlex)


//ConnectivityGlobal

%include <CompuCell3D/plugins/ConnectivityGlobal/ConnectivityGlobalData.h>
%template (connectivityGlobalaccessor) ExtraMembersGroupAccessor<ConnectivityGlobalData>; //necessary to get ConnectivityGlobalData accessor working
PLUGINACCESSOR(ConnectivityGlobal)


// //LengthConstraintLocalFlex
// %include <CompuCell3D/plugins/LengthConstraintLocalFlex/LengthConstraintLocalFlexData.h>
// %template (lengthconstraintlocalflexccessor) ExtraMembersGroupAccessor<LengthConstraintLocalFlexData>; //necessary to get LengthConstraintLocalFlexData accessor working

// %include <CompuCell3D/plugins/LengthConstraintLocalFlex/LengthConstraintLocalFlexPlugin.h>

// %inline %{
   // LengthConstraintLocalFlexPlugin * getLengthConstraintLocalFlexPlugin(){
         // return (LengthConstraintLocalFlexPlugin *)Simulator::pluginManager.get("LengthConstraintLocalFlex");
    // }
// %}



//LengthConstraint - includes local flax option
%include <CompuCell3D/plugins/LengthConstraint/LengthConstraintData.h>
%template (lengthconstraintccessor) ExtraMembersGroupAccessor<LengthConstraintData>; //necessary to get LengthConstraintData accessor working

%include <CompuCell3D/plugins/LengthConstraint/LengthConstraintPlugin.h>

%inline %{
   LengthConstraintPlugin * getLengthConstraintPlugin(){
         return (LengthConstraintPlugin *)Simulator::pluginManager.get("LengthConstraint");
    }
   LengthConstraintPlugin * getLengthConstraintLocalFlexPlugin(){
         
         Plugin  * ptr= Simulator::pluginManager.get("LengthConstraintLocalFlex");
         
         if (ptr){
            return (LengthConstraintPlugin *)ptr;
         }
         
         return (LengthConstraintPlugin *)Simulator::pluginManager.get("LengthConstraintLocalFlex");
    }
    
    
%}


//%include <CompuCell3D/plugins/ChemotaxisSimple/ChemotaxisSimpleEnergy.h>
//
////Chemotaxis Plugin
//
%include <CompuCell3D/plugins/Chemotaxis/ChemotaxisData.h>
PLUGINACCESSOR(Chemotaxis)


////plugins
//// %include <CompuCell3D/plugins/Mitosis/MitosisParseData.h>
%include <CompuCell3D/plugins/Mitosis/MitosisPlugin.h>
%include <CompuCell3D/plugins/Mitosis/MitosisSimplePlugin.h>

////Volume Tracker Plugin
PLUGINACCESSOR(VolumeTracker)


//CenterOfMass Plugin
PLUGINACCESSOR(CenterOfMass)

//NeighborPlugin

%include <CompuCell3D/plugins/NeighborTracker/NeighborTracker.h>

%template (neighbortrackeraccessor) ExtraMembersGroupAccessor<NeighborTracker>; //necessary to get NeighborTracker accessor working
%template (nsdSetPyItr) STLPyIteratorRefRetType<std::set<CompuCell3D::NeighborSurfaceData> , CompuCell3D::NeighborSurfaceData>;
// %template (nsdSetPyItr) STLPyIterator<std::set<CompuCell3D::NeighborSurfaceData> >;
%template (neighborsurfacedataset) std::set<CompuCell3D::NeighborSurfaceData>; //necessary to get basis set functionality working

PLUGINACCESSOR(NeighborTracker)


%include <CompuCell3D/plugins/PixelTracker/PixelTracker.h>
%template (PixelTrackerAccessor) ExtraMembersGroupAccessor<PixelTracker>; //necessary to get PixelTracker accessor working
// #define std::set<CompuCell3D::PixelTrackerData>::value_type CompuCell3D::PixelTrackerData
%template (PixelTrackerDataset) std::set<CompuCell3D::PixelTrackerData>; //necessary to get basis set functionality working
%template (pixelSetPyItr) STLPyIteratorRefRetType< std::set<CompuCell3D::PixelTrackerData>,CompuCell3D::PixelTrackerData >; 
// %template (pixelSetPyItr) STLPyIterator<std::set<CompuCell3D::PixelTrackerData> >;
PLUGINACCESSOR(PixelTracker)


%include <CompuCell3D/plugins/BoundaryPixelTracker/BoundaryPixelTracker.h>
%template (BoundaryPixelTrackerAccessor) ExtraMembersGroupAccessor<BoundaryPixelTracker>; //necessary to get BoundaryPixelTracker accessor working
%template (BoundaryPixelTrackerDataset) std::set<CompuCell3D::BoundaryPixelTrackerData>; //necessary to get basis set functionality working
%template (IntBoundaryPixelTrackerDataSetMap) std::map<int, std::set<CompuCell3D::BoundaryPixelTrackerData> >; //necessary to get basis set functionality working
%template (boundaryPixelSetPyItr) STLPyIteratorRefRetType<std::set<CompuCell3D::BoundaryPixelTrackerData> , CompuCell3D::BoundaryPixelTrackerData >;
// %template (boundaryPixelSetPyItr) STLPyIterator<std::set<CompuCell3D::BoundaryPixelTrackerData> >;
PLUGINACCESSOR(BoundaryPixelTracker)


%include <CompuCell3D/plugins/ContactLocalFlex/ContactLocalFlexData.h>
%template (contactlocalflexcontainerccessor) ExtraMembersGroupAccessor<ContactLocalFlexDataContainer>; //necessary to get ContactlocalFlexData accessor working
%template (clfdSetPyItr) STLPyIteratorRefRetType<std::set<CompuCell3D::ContactLocalFlexData> , CompuCell3D::ContactLocalFlexData >;
// %template (clfdSetPyItr) STLPyIterator<std::set<CompuCell3D::ContactLocalFlexData> >;
%template (contactlocalflexdataset) std::set<CompuCell3D::ContactLocalFlexData>; //necessary to get basis set functionality working
PLUGINACCESSOR(ContactLocalFlex)

//ContactLocalProductPlugin
%include <CompuCell3D/plugins/ContactLocalProduct/ContactLocalProductData.h>
%template (contactproductflexccessor) ExtraMembersGroupAccessor<ContactLocalProductData>; //necessary to get ContactLocalProductData accessor working
%template (jVecPyItr) STLPyIteratorRefRetType<ContactLocalProductData::ContainerType_t,float>; //ContainerType_t - this is vector<float> in current implementation
// %template (jVecPyItr) STLPyIterator<ContactLocalProductData::ContainerType_t>; //ContainerType_t - this is vector<float> in current implementation
%template (contactproductdatacontainertype) std::vector<float>; //necessary to get basis vector functionality working
PLUGINACCESSOR(ContactLocalProduct)

//some functions to get more vector function to work

%extend std::vector<float>{

   void set(unsigned int pos, float _x){
      if(pos <= self->size()-1 ){
         self->operator[](pos)=_x;
      }
   }

   float get(unsigned int pos){
      if(pos <= self->size()-1 ){
         return self->operator[](pos);
      }
   }


}

//ContactMultiCadPlugin
%include <CompuCell3D/plugins/ContactMultiCad/ContactMultiCadData.h>
%template (contactmulticaddataaccessor) ExtraMembersGroupAccessor<ContactMultiCadData>; //necessary to get ContactMultiCadData accessor working
PLUGINACCESSOR(ContactMultiCad)

//AdhesionFlexPlugin
%include <CompuCell3D/plugins/AdhesionFlex/AdhesionFlexData.h>
%template (adhesionflexdataaccessor) ExtraMembersGroupAccessor<AdhesionFlexData>; //necessary to get AdhesionFlexData accessor working
PLUGINACCESSOR(AdhesionFlex)



//CellOrientation Plugin
%include <CompuCell3D/plugins/CellOrientation/CellOrientationVector.h>
%template (cellOrientationVectorAccessor) ExtraMembersGroupAccessor<CellOrientationVector>; //necessary to get CellOrientationVector accessor working
%template (LambdaCellOrientationAccessor) ExtraMembersGroupAccessor<LambdaCellOrientation>; //necessary to get LambdaCellOrientation accessor working
PLUGINACCESSOR(CellOrientation)

 ////PolarizationVectorPlugin
%include <CompuCell3D/plugins/PolarizationVector/PolarizationVector.h>
%template (polarizationVectorAccessor) ExtraMembersGroupAccessor<PolarizationVector>; //necessary to get CellOrientationVector accessor working
PLUGINACCESSOR(PolarizationVector)

//Elasticity Plugin
%include <CompuCell3D/plugins/ElasticityTracker/ElasticityTracker.h>
%template (elasticityTrackerAccessor) ExtraMembersGroupAccessor<ElasticityTracker>; //necessary to get ElasticityTracker accessor working
%template (elasticitySetPyItr) STLPyIteratorRefRetType<std::set<CompuCell3D::ElasticityTrackerData> , CompuCell3D::ElasticityTrackerData >;
// %template (elasticitySetPyItr) STLPyIterator<std::set<CompuCell3D::ElasticityTrackerData> >;
%template (elasticityTrackerDataSet) std::set<CompuCell3D::ElasticityTrackerData>; //necessary to get basic set functionality working
PLUGINACCESSOR(ElasticityTracker)


//Plasticity Plugin
%include <CompuCell3D/plugins/PlasticityTracker/PlasticityTracker.h>
%template (plasticityTrackerAccessor) ExtraMembersGroupAccessor<PlasticityTracker>; //necessary to get PlasticityTracker accessor working
%template (plasticitySetPyItr) STLPyIteratorRefRetType<std::set<CompuCell3D::PlasticityTrackerData> , CompuCell3D::PlasticityTrackerData >;
// %template (plasticitySetPyItr) STLPyIterator<std::set<CompuCell3D::PlasticityTrackerData> >;
%template (plasticityTrackerDataSet) std::set<CompuCell3D::PlasticityTrackerData>; //necessary to get basic set functionality working
PLUGINACCESSOR(PlasticityTracker)

////Focal Point Plasticity Plugin
//
%ignore CompuCell3D::FocalPointPlasticityLinkTrackerData;
%include <CompuCell3D/plugins/FocalPointPlasticity/FocalPointPlasticityTracker.h>
%template (focalPointPlasticityTrackerAccessor) ExtraMembersGroupAccessor<FocalPointPlasticityTracker>; //necessary to get PlasticityTracker accessor working
%template (focalPointPlasticitySetPyItr) STLPyIteratorRefRetType<std::set<CompuCell3D::FocalPointPlasticityTrackerData> , CompuCell3D::FocalPointPlasticityTrackerData >;
%template (focalPointPlasticitySetPyItr) STLPyIterator<std::set<CompuCell3D::FocalPointPlasticityTrackerData> >;
%template (focalPointPlasticityTrackerDataSet) std::set<CompuCell3D::FocalPointPlasticityTrackerData>; //necessary to get basic set functionality working
%template (focalPointPlasticityTrackerDataVector) std::vector<CompuCell3D::FocalPointPlasticityTrackerData>; //necessary to get basic set functionality working

%{
namespace swig{

	// link id
	template<> struct traits<CompuCell3D::FPPLinkID>{
		typedef pointer_category category;
		static const char* type_name() {return "FPPLinkID";}
	};

}

%}

%ignore CompuCell3D::FocalPointPlasticityLinkType;
%include <CompuCell3D/plugins/FocalPointPlasticity/FocalPointPlasticityLinks.h>

%template(_FPPLinkList) std::vector<CompuCell3D::FocalPointPlasticityLink*>;
%template(_FPPInternalLinkList) std::vector<CompuCell3D::FocalPointPlasticityInternalLink*>;
%template(_FPPAnchorList) std::vector<CompuCell3D::FocalPointPlasticityAnchor*>;
%include "plugins/FocalPointPlasticity/FocalPointPlasticityLinkInventoryBase.h"
%template(FPPLinkList) CompuCell3D::FPPLinkListBase<CompuCell3D::FocalPointPlasticityLink>;
%template(FPPInternalLinkList) CompuCell3D::FPPLinkListBase<CompuCell3D::FocalPointPlasticityInternalLink>;
%template(FPPAnchorList) CompuCell3D::FPPLinkListBase<CompuCell3D::FocalPointPlasticityAnchor>;
%template (mapFPPLinkIDFPPLinkPyItr) STLPyIteratorMap<std::unordered_map<CompuCell3D::FPPLinkID, CompuCell3D::FocalPointPlasticityLink*, CompuCell3D::LinkInventoryHasher>, CompuCell3D::FocalPointPlasticityLink*>;
%template (mapFPPLinkIDFPPInternalLinkPyItr) STLPyIteratorMap<std::unordered_map<CompuCell3D::FPPLinkID, CompuCell3D::FocalPointPlasticityInternalLink*, CompuCell3D::LinkInventoryHasher>, CompuCell3D::FocalPointPlasticityInternalLink*>;
%template (mapFPPLinkIDFPPAnchorPyItr) STLPyIteratorMap<std::unordered_map<CompuCell3D::FPPLinkID, CompuCell3D::FocalPointPlasticityAnchor*, CompuCell3D::LinkInventoryHasher>, CompuCell3D::FocalPointPlasticityAnchor*>;
%template (_fppInventoryBaseLink) CompuCell3D::FPPLinkInventoryBase<CompuCell3D::FocalPointPlasticityLink>;
%template (_fppInventoryBaseInternalLink) CompuCell3D::FPPLinkInventoryBase<CompuCell3D::FocalPointPlasticityInternalLink>;
%template (_fppInventoryBaseAnchor) CompuCell3D::FPPLinkInventoryBase<CompuCell3D::FocalPointPlasticityAnchor>;

%include "plugins/FocalPointPlasticity/FocalPointPlasticityLinkInventory.h"

%inline %{
   PyObject* getLinkPyAttrib(CompuCell3D::FocalPointPlasticityLinkBase* _link){
        PyObject* pyAttrib = _link->getPyAttrib();
        Py_INCREF(pyAttrib);
        return pyAttrib;
   }
%}

%extend CompuCell3D::FocalPointPlasticityLinkBase {
    %pythoncode %{
        def get_dict(self):
            return getLinkPyAttrib(self)
        
        def set_dict(self, _dict):
            raise AttributeError('ASSIGNMENT link.dict=%s is illegal. Dictionary "dict" can only be modified but not replaced'%(_dict))
        
        __swig_setmethods__["dict"] = set_dict
        __swig_getmethods__["dict"] = get_dict
        if _newclass: dict = property(get_dict, set_dict)

        __sbml__ = '__sbml__'

        def setsbml(self, sbml) :		
            raise AttributeError('ASSIGNMENT link.sbml = %s is illegal. '
                                '"sbml" attribute can only be modified but not replaced' % (sbml))

        def getsbml(self):
            link_dict = self.dict
            class LinkSBMLFetcher:
                def __getattr__(self, item):
                    if FocalPointPlasticityLinkBase.__sbml__ not in link_dict.keys():
                        raise KeyError('Link has no SBML solvers')
                    elif item not in link_dict[FocalPointPlasticityLinkBase.__sbml__].keys():
                        raise KeyError(f'Cound not find SBML model with name {item}.')
                    return link_dict[FocalPointPlasticityLinkBase.__sbml__][item]
            return LinkSBMLFetcher()

        __swig_getmethods__["sbml"] = getsbml
        __swig_setmethods__["sbml"] = setsbml
        if _newclass : sbml = property(getsbml, setsbml)
    %}
}

PLUGINACCESSOR(FocalPointPlasticity)


//MomentOfInertia
PLUGINACCESSOR(MomentOfInertia)


//Secretion
%include <CompuCell3D/plugins/Secretion/FieldSecretor.h>
PLUGINACCESSOR(Secretion)

%extend  CompuCell3D::FieldSecretor{

  bool secreteInsideCellConstantConcentration(CellG * _cell, float _amount){
    if (!self->pixelTrackerPlugin){
        throw std::runtime_error(std::string("PixelTracker Plugin has been turned off. Cannot execute secreteInsideCell function"));        
    }else{
        return self->_secreteInsideCellConstantConcentration(_cell,_amount);
    }               
  }    

FieldSecretorResult secreteInsideCellConstantConcentrationTotalAmount(CellG * _cell, float _amount) {
	if (!self->pixelTrackerPlugin) {
		throw std::runtime_error(std::string("PixelTracker Plugin has been turned off. Cannot execute secreteInsideCell function"));
	}
	else {
		return self->_secreteInsideCellConstantConcentrationTotalCount(_cell,_amount);
	}
}


  bool secreteInsideCell(CellG * _cell, float _amount){
    if (!self->pixelTrackerPlugin){
        throw std::runtime_error(std::string("PixelTracker Plugin has been turned off. Cannot execute secreteInsideCell function"));        
    }else{
        return self->_secreteInsideCell(_cell,_amount);
    }               
  }    
  
  FieldSecretorResult secreteInsideCellTotalCount(CellG * _cell, float _amount) {
	  if (!self->pixelTrackerPlugin) {
		  throw std::runtime_error(std::string("PixelTracker Plugin has been turned off. Cannot execute secreteInsideCell function"));
	  }
	  else {
		  return self->_secreteInsideCellTotalCount(_cell,_amount);
	  }
  }


  bool secreteInsideCellAtBoundary(CellG * _cell, float _amount){
    if (!self->boundaryPixelTrackerPlugin){
        throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteInsideCellAtBoundary function"));        
    }else{
        return self->_secreteInsideCellAtBoundary(_cell,_amount);
    }               
  }    

  FieldSecretorResult secreteInsideCellAtBoundaryTotalCount(CellG * _cell, float _amount) {
	  if (!self->boundaryPixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteInsideCellAtBoundary function"));
	  }
	  else {
		  return self->_secreteInsideCellAtBoundaryTotalCount(_cell,_amount);
	  }
  }


  bool secreteInsideCellAtBoundaryOnContactWith(CellG * _cell, float _amount,const std::vector<unsigned char> & _onContactVec){
      
    if (!self->boundaryPixelTrackerPlugin){
        throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteInsideCellAtBoundaryOnContactWith function"));        
    }else{
        return self->_secreteInsideCellAtBoundaryOnContactWith(_cell,_amount,_onContactVec);
    }                     
  }

  FieldSecretorResult secreteInsideCellAtBoundaryOnContactWithTotalCount(CellG * _cell, float _amount,const std::vector<unsigned char> & _onContactVec) {

	  if (!self->boundaryPixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteInsideCellAtBoundaryOnContactWith function"));
	  }
	  else {
		  return self->_secreteInsideCellAtBoundaryOnContactWithTotalCount(_cell,_amount,_onContactVec);
	  }
  }


  bool secreteOutsideCellAtBoundary(CellG * _cell, float _amount) {

	  if (!self->boundaryPixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteOutsideCellAtBoundary function"));
	  }
	  else {
		  return self->_secreteOutsideCellAtBoundary(_cell,_amount);
	  }
  }

  FieldSecretorResult secreteOutsideCellAtBoundaryTotalCount(CellG * _cell, float _amount) {

	  if (!self->boundaryPixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteOutsideCellAtBoundary function"));
	  }
	  else {
		  return self->_secreteOutsideCellAtBoundaryTotalCount(_cell,_amount);
	  }
  }



  bool secreteOutsideCellAtBoundaryOnContactWith(CellG * _cell, float _amount,const std::vector<unsigned char> & _onContactVec){
      
    if (!self->boundaryPixelTrackerPlugin){
        throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteOutsideCellAtBoundaryOnContactWith function"));        
    }else{
        return self->_secreteOutsideCellAtBoundaryOnContactWith(_cell,_amount,_onContactVec);
    }                     
  }  

  FieldSecretorResult secreteOutsideCellAtBoundaryOnContactWithTotalCount(CellG * _cell, float _amount, const std::vector<unsigned char> & _onContactVec) {

	  if (!self->boundaryPixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute secreteOutsideCellAtBoundaryOnContactWith function"));
	  }
	  else {
		  return self->_secreteOutsideCellAtBoundaryOnContactWithTotalCount(_cell, _amount, _onContactVec);
	  }
  }


//   bool secreteInsideCellAtCOM(CellG * _cell, float _amount){
//     return self->_secreteInsideCellAtCOM(_cell,_amount);  
//   }
  
  bool uptakeInsideCell(CellG * _cell, float _maxUptake, float _relativeUptake){
    if (!self->pixelTrackerPlugin){
        throw std::runtime_error(std::string("PixelTracker Plugin has been turned off. Cannot execute uptakeInsideCell function"));        
    }else{
        return self->_uptakeInsideCell(_cell, _maxUptake, _relativeUptake);
    }               
  }    

  FieldSecretorResult uptakeInsideCellTotalCount(CellG * _cell, float _maxUptake, float _relativeUptake) {
	  if (!self->pixelTrackerPlugin) {
		  throw std::runtime_error(std::string("PixelTracker Plugin has been turned off. Cannot execute uptakeInsideCell function"));
	  }
	  else {
		  return self->_uptakeInsideCellTotalCount(_cell, _maxUptake, _relativeUptake);
	  }
  }


  bool uptakeInsideCellAtBoundary(CellG * _cell, float _maxUptake, float _relativeUptake){
    if (!self->pixelTrackerPlugin){
        throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeInsideCellAtBoundary function"));        
    }else{
        return self->_uptakeInsideCellAtBoundary(_cell,_maxUptake, _relativeUptake);
    }               
  }    

  FieldSecretorResult uptakeInsideCellAtBoundaryTotalCount(CellG * _cell, float _maxUptake, float _relativeUptake) {
	  if (!self->pixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeInsideCellAtBoundary function"));
	  }
	  else {
		  return self->_uptakeInsideCellAtBoundaryTotalCount(_cell, _maxUptake, _relativeUptake);
	  }
  }


  bool uptakeInsideCellAtBoundaryOnContactWith(CellG * _cell, float _maxUptake, float _relativeUptake, const std::vector<unsigned char> & _onContactVec){
    if (!self->pixelTrackerPlugin){
        throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeInsideCellAtBoundaryOnContactWith function"));        
    }else{
        return self->_uptakeInsideCellAtBoundaryOnContactWith(_cell,_maxUptake, _relativeUptake,_onContactVec);
    }               
  }          

  FieldSecretorResult uptakeInsideCellAtBoundaryOnContactWithTotalCount(CellG * _cell, float _maxUptake, float _relativeUptake, const std::vector<unsigned char> & _onContactVec) {
	  if (!self->pixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeInsideCellAtBoundaryOnContactWith function"));
	  }
	  else {
		  return self->_uptakeInsideCellAtBoundaryOnContactWithTotalCount(_cell, _maxUptake, _relativeUptake, _onContactVec);
	  }
  }



  bool uptakeOutsideCellAtBoundary(CellG * _cell, float _maxUptake, float _relativeUptake){
    if (!self->pixelTrackerPlugin){
        throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeOutsideCellAtBoundary function"));        
    }else{
        return self->_uptakeOutsideCellAtBoundary(_cell,_maxUptake, _relativeUptake);
    }               
  }    

  FieldSecretorResult uptakeOutsideCellAtBoundaryTotalCount(CellG * _cell, float _maxUptake, float _relativeUptake) {
	  if (!self->pixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeOutsideCellAtBoundary function"));
	  }
	  else {
		  return self->_uptakeOutsideCellAtBoundaryTotalCount(_cell, _maxUptake, _relativeUptake);
	  }
  }


  bool uptakeOutsideCellAtBoundaryOnContactWith(CellG * _cell, float _maxUptake, float _relativeUptake, const std::vector<unsigned char> & _onContactVec){
    if (!self->pixelTrackerPlugin){
        throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeOutsideCellAtBoundaryOnContactWith function"));        
    }else{
        return self->_uptakeOutsideCellAtBoundaryOnContactWith(_cell,_maxUptake, _relativeUptake,_onContactVec);
    }               
  }   

  FieldSecretorResult uptakeOutsideCellAtBoundaryOnContactWithTotalCount(CellG * _cell, float _maxUptake, float _relativeUptake, const std::vector<unsigned char> & _onContactVec) {
	  if (!self->pixelTrackerPlugin) {
		  throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute uptakeOutsideCellAtBoundaryOnContactWith function"));
	  }
	  else {
		  return self->_uptakeOutsideCellAtBoundaryOnContactWithTotalCount(_cell, _maxUptake, _relativeUptake, _onContactVec);
	  }
  }

  float amountSeenByCell(CellG * _cell) {
      if (!self->pixelTrackerPlugin) {
          throw std::runtime_error(std::string("BoundaryPixelTracker Plugin has been turned off. Cannot execute  amountSeenByCell function"));
      }
      else {
          return self->_amountSeenByCell(_cell);
      }
  }

//   bool uptakeInsideCellAtCOM(CellG * _cell, float _maxUptake, float _relativeUptake){
//     return _uptakeInsideCellAtCOM(_cell,_maxUptake,_relativeUptake);
//   }
  
}


////Steppables
%include <CompuCell3D/steppables/Mitosis/MitosisSteppable.h>

////AutogeneratedModules2 - DO NOT REMOVE THIS LINE IT IS USED BY TWEDIT TO LOCATE CODE INSERTION POINT
//BiasVectorSteppable_autogenerated2


%include <CompuCell3D/steppables/BiasVectorSteppable/BiasVectorSteppable.h>



%inline %{

 BiasVectorSteppable * getBiasVectorSteppable(){

      return (BiasVectorSteppable *)Simulator::steppableManager.get("BiasVectorSteppable");

   }



%}

//ImplicitMotility_autogenerated2


%include <CompuCell3D/plugins/ImplicitMotility/ImplicitMotilityPlugin.h>



%inline %{

 ImplicitMotilityPlugin * getImplicitMotilityPlugin(){

      return (ImplicitMotilityPlugin *)Simulator::pluginManager.get("ImplicitMotility");

   }



%}

////CurvatureCalculator_autogenerated2
//
%include <CompuCell3D/plugins/CurvatureCalculator/CurvatureCalculatorPlugin.h>

%inline %{
 CurvatureCalculatorPlugin * getCurvatureCalculatorPlugin(){
      return (CurvatureCalculatorPlugin *)Simulator::pluginManager.get("CurvatureCalculator");
   }

%}

//OrientedGrowth_autogenerated2
%include <CompuCell3D/plugins/OrientedGrowth/OrientedGrowthData.h>
%template (OrientedGrowthDataAccessorTemplate) ExtraMembersGroupAccessor<OrientedGrowthData>; //necessary to get OrientedGrowthData accessor working in Python
PLUGINACCESSOR(OrientedGrowth)

//OrientedGrowth2_autogenerated2
%include <CompuCell3D/plugins/OrientedGrowth2/OrientedGrowth2Data.h>
%template (OrientedGrowth2DataAccessorTemplate) ExtraMembersGroupAccessor<OrientedGrowth2Data>; //necessary to get OrientedGrowth2Data accessor working in Python
PLUGINACCESSOR(OrientedGrowth2)

////CleaverMeshDumper_autogenerated2

// %include <CompuCell3D/steppables/CleaverMeshDumper/CleaverMeshDumper.h>

// %inline %{
//     CleaverMeshDumper * getCleaverMeshDumper() {
//         return (CleaverMeshDumper *)Simulator::steppableManager.get("CleaverMeshDumper");
//     }
//     %}

//%}
//// // // //CGALMeshDumper_autogenerated2
//// // //             
//// // // %include <CompuCell3D/steppables/CGALMeshDumper/CGALMeshDumper.h>
//// // // 
//// // // %inline %{
//// // //  CGALMeshDumper * getCGALMeshDumper(){
//// // //       return (CGALMeshDumper *)Simulator::steppableManager.get("CGALMeshDumper");
//// // //    }
//// // // 
//// // // %}
//
////ContactOrientation_autogenerated2
//
%include <CompuCell3D/plugins/ContactOrientation/ContactOrientationData.h>
//necessary to get ContactOrientationData accessor working in Python
%template (ContactOrientationDataAccessorTemplate) ExtraMembersGroupAccessor<ContactOrientationData>;
PLUGINACCESSOR(ContactOrientation)

//note that template Array3DCUDA has to use static_cast<T>(0) instead of T() to enable SWIG to properly generate wrappers for T=ubnsigned char using gcc compiler
%template (Array3DCUDAunsignedchar) Array3DCUDA<unsigned char>; //necessary Array3DCUDA<unsigned char> working in Python
//BoundaryMonitor_autogenerated2
%include <CompuCell3D/plugins/BoundaryMonitor/BoundaryMonitorPlugin.h>

%inline %{
 BoundaryMonitorPlugin * getBoundaryMonitorPlugin(){
      return (BoundaryMonitorPlugin *)Simulator::pluginManager.get("BoundaryMonitor");
   }

%}
////CellTypeMonitor_autogenerated2
//                   
//%include <CompuCell3D/plugins/CellTypeMonitor/CellTypeMonitorPlugin.h>
//
//%inline %{
// CellTypeMonitorPlugin * getCellTypeMonitorPlugin(){
//      return (CellTypeMonitorPlugin *)Simulator::pluginManager.get("CellTypeMonitor");
//   }
//
//%}
//Polarization23_autogenerated2
%include <CompuCell3D/plugins/Polarization23/Polarization23Data.h>
%template (Polarization23DataAccessorTemplate) ExtraMembersGroupAccessor<Polarization23Data>; //necessary to get Polarization23Data accessor working in Python
PLUGINACCESSOR(Polarization23)


//ClusterSurface_autogenerated2
PLUGINACCESSOR(ClusterSurface)

//ClusterSurfaceTracker_autogenerated2
PLUGINACCESSOR(ClusterSurfaceTracker)

//// //List of fields from simulator
//
//
//// //%template (simulatorFieldMapPyItr) STLPyIterator<std::map<std::string,Field3DImpl<float>*> >;
//// //%template (simulatorFieldMap) <std::map<std::string,Field3DImpl<float>*>;
//
//
