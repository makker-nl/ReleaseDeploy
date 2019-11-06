#############################################################################
# Import an OSB configuration into OSB
#
# Based on https://github.com/biemond/soa_tools/blob/master/maven_osb_ps6_tool/import.py
#
# @author Martien van den Akker, Darwin-IT Professionals
# @version 1.0, 2017-11-09
#
#############################################################################
from java.util import HashMap
from java.util import HashSet
from java.util import ArrayList
from java.io import FileInputStream

from com.bea.wli.sb.util import Refs
from com.bea.wli.config.customization import Customization
from com.bea.wli.sb.management.importexport import ALSBImportOperation

import sys


#=======================================================================================
# Entry function to deploy project configuration and resources
# into a ALSB domain
#=======================================================================================

def importToALSBDomain():
    try:
        SessionMBean = None

        print 'Attempting to import :', importJar, "on OSB Admin Server listening on :", adminUrl
        print 'Read file', importJar
        importJarBinary = readBinaryFile(importJar)
        sessionName = createSessionName()
        print 'Created session', sessionName
        SessionMBean = getSessionManagementMBean(sessionName)
        print 'SessionMBean started session'
        ALSBConfigurationMBean = findService(String("ALSBConfiguration.").concat(sessionName), "com.bea.wli.sb.management.configuration.ALSBConfigurationMBean")
        print "ALSBConfiguration MBean found", ALSBConfigurationMBean
        ALSBConfigurationMBean.uploadJarFile(importJarBinary)
        print 'Jar Uploaded'
        #
        if project == "None":
            print 'No project specified, additive deployment performed'
            osbJarInfo = ALSBConfigurationMBean.getImportJarInfo()
            osbImportPlan = osbJarInfo.getDefaultImportPlan()
            osbImportPlan.setPassphrase(passphrase)
            osbImportPlan.setPreserveExistingEnvValues(true)
            importResult = ALSBConfigurationMBean.importUploaded(osbImportPlan)
            SessionMBean.activateSession(sessionName, "Complete import without customization using wlst")
        else:
            print 'ÒSB project', project, 'will get updated'
            osbJarInfo = ALSBConfigurationMBean.getImportJarInfo()
            osbImportPlan = osbJarInfo.getDefaultImportPlan()
            osbImportPlan.setPassphrase(passphrase)
            operationMap=HashMap()
            operationMap = osbImportPlan.getOperations()
            print
            print 'Default importPlan'
            printOpMap(operationMap)
            set = operationMap.entrySet()

            osbImportPlan.setPreserveExistingEnvValues(true)

            #boolean
            abort = false
            #list of created artifact refences
            createdRefList = ArrayList()
            for entry in set:
                ref = entry.getKey()
                op = entry.getValue()
                #set different logic based on the resource type
                type = ref.getTypeId
                if type == Refs.SERVICE_ACCOUNT_TYPE or type == Refs.SERVICE_PROVIDER_TYPE:
                    if op.getOperation() == ALSBImportOperation.Operation.Create:
                        print 'Unable to import a service account or a service provider on a target system', ref
                        abort = true
                else:
                    #keep the list of created resources
                    print 'ref: ',ref
                    createdRefList.add(ref)
            if abort == true :
                print 'This jar must be imported manually to resolve the service account and service provider dependencies'
                SessionMBean.discardSession(sessionName)
                raise
            print
            print 'Modified importPlan'
            printOpMap(operationMap)
            importResult = ALSBConfigurationMBean.importUploaded(osbImportPlan)
            printDiagMap(importResult.getImportDiagnostics())              
            if importResult.getFailed().isEmpty() == false:
                print 'One or more resources could not be imported properly'
                raise
            #
            # Execute the customizationFile:
            executeCustomization(ALSBConfigurationMBean, createdRefList, customFile)
            #
            SessionMBean.activateSession(sessionName, "Complete import with customization using wlst")
        print "Deployment of : " + importJar + " successful!"
    except:
        print "Unexpected error:", sys.exc_info()[0]
        if SessionMBean != None:
            SessionMBean.discardSession(sessionName)
        raise
#=======================================================================================
# Function to execute the customization file.
#=======================================================================================
def executeCustomization(ALSBConfigurationMBean, createdRefList, customizationFile):
    if customizationFile!=None:
      print 'Loading customization File', customizationFile
      inputStream = FileInputStream(customizationFile)
      if inputStream != None:
        customizationList = Customization.fromXML(inputStream)
        if customizationList != None:
          filteredCustomizationList = ArrayList()
          setRef = HashSet(createdRefList)
          print 'Filter to remove None customizations' 
          print "-----"
          # Apply a filter to all the customizations to narrow the target to the created resources
          print 'Number of customizations in list: ', customizationList.size()
          for customization in customizationList:
            print "Add customization to list: "
            if customization != None:
              print 'Customization: ', customization, " - ", customization.getDescription()
              newCustomization = customization.clone(setRef)
              filteredCustomizationList.add(newCustomization)
            else:
              print "Customization is None!"
            print "-----"
          print 'Number of resulting customizations in list: ', filteredCustomizationList.size()
          ALSBConfigurationMBean.customize(filteredCustomizationList)
        else:
          print 'CustomizationList is null!'
      else:
        print 'Input Stream for customization file is null!'
    else:
      print 'No customization File provided, skip customization.'
#=======================================================================================
# Utility function to print the list of operations
#=======================================================================================
def printOpMap(map):
    set = map.entrySet()
    for entry in set:
        op = entry.getValue()
        print op.getOperation(),
        ref = entry.getKey()
        print ref
    print

#=======================================================================================
# Utility function to print the diagnostics
#=======================================================================================
def printDiagMap(map):
    set = map.entrySet()
    for entry in set:
        diag = entry.getValue().toString()
        print diag
    print

#=======================================================================================
# Utility function to read a binary file
#=======================================================================================
def readBinaryFile(fileName):
    file = open(fileName, 'rb')
    bytes = file.read()
    return bytes

#=======================================================================================
# Utility function to create an arbitrary session name
#=======================================================================================
def createSessionName():
    sessionName = String("SessionScript"+Long(System.currentTimeMillis()).toString())
    return sessionName

#=======================================================================================
# Utility function to load a session MBeans
#=======================================================================================
def getSessionManagementMBean(sessionName):
    SessionMBean = findService("SessionManagement", "com.bea.wli.sb.management.configuration.SessionManagementMBean")
    SessionMBean.createSession(sessionName)
    return SessionMBean

# IMPORT script init
try:
    # import the service bus configuration
    # argv[1] is the export config properties file
    importToALSBDomain()

except:
    print "Unexpected error: ", sys.exc_info()[0]
    dumpStack()
    raise