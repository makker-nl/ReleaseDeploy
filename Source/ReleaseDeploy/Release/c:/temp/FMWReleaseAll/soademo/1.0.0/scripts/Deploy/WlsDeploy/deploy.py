#############################################################################
# Deploy an application as an Ear
#
# References
# . https://docs.oracle.com/cd/E13222_01/wls/docs103/config_scripting/reference.html#wp1024285
#
# @author Martien van den Akker, Darwin-IT Professionals
# @version 1.0, 2017-11-09
#
#############################################################################
import sys, traceback,time
waitInterval=5
#=======================================================================================
# Entry function to deploy an ear file with deployment plan.
# Expected variables:
# deployName: Name of the application to deploy
# deployArchive: reference to the archive to deploy
# deployTargets: comma seperated list of targets to deploy the application to
# deployPlanFile: Reference to the deployPlan
#=======================================================================================
def deployEAR():
    try:
      print "Deploy"
      # Deploy the application
      # Apparently already in domainRuntime()
      print 'Check deployment of application '+deployName + '.'
      applDplRuntime = getMBean('/DeploymentManager/DeploymentManager/AppDeploymentRuntimes/'+deployName)
      if applDplRuntime == None:
        print ('Application '+deployName+' apparently not deployed yet')
      else:
        print ('Application '+deployName+' already deployed, first undeploy..')
        edit()
        startEdit()
        progress = undeploy(appName=deployName)
        #while progress.isRunning():
        #  pass
        save()
        activate(block='true')
        print 'Application ' + deployName + ' succesfully undeployed.'
      print 'Deploying application ' + deployName + '.'
      edit()
      startEdit()
      if deployPlanIncludeFile=="true":
        progress = deploy(appName=deployName, path=deployArchive, targets=deployTargets, planPath=deployPlanFile, upload="true")
      else:
        progress = deploy(appName=deployName, path=deployArchive, targets=deployTargets, upload="true")
      save()
      activate(block='true')
      print ('Wait a moment for completing deployment...')
      if progress.isRunning():
        print ('Deployment still running...')
      else:
        print ('Deployment done')
      print 'Application ' + deployName + ' succesfully deployed.'
      appStateRT = getMBean('/AppRuntimeStateRuntime/AppRuntimeStateRuntime')
      if appStateRT != None:
        deployTargetList = deployTargets.split(',')
        for deployTarget in deployTargetList:
          state = appStateRT.getCurrentState(deployName, deployTarget)
          print ('State of '+deployName+' in '+deployTarget+': '+state)
      else:
        print 'AppRuntimeStateRuntime MBean not found...'
      #
    except WLSTException:
      print "WLSTException:", sys.exc_info()[0]
      print progress.printStatus()
      raise
      #print "message: "+ progress.getMessage()
    except:
        print "Unexpected error:", sys.exc_info()[0]
        raise
# Script init
try:
    deployEAR()

except:
    print "Unexpected error: ", sys.exc_info()[0]
    dumpStack()
    raise