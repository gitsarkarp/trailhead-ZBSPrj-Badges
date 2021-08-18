({
    doInit : function(component, event, helper) {
      var sObj = component.get("v.sObjectName");
      var recId = component.get("v.recordId");
      if(sObj){
        helper.getLabelForRecord(component, sObj);
        helper.getBadgesForRecord(component, recId, sObj);
      }
    },
    
    resetBadges : function(component, event, helper){
      alert("EventCalled");
      var recId = component.get("v.recordId");
      var sObj = component.get("v.sObjectName");
      if(sObj){
        helper.getBadgesForRecord(component, recId, sObj);
        alert("PageTobeRefreshed");
        var refreshPage = $A.get("e.force:refreshView");
        refreshPage.fire();
        alert("PageRefreshed");
      }
    },

    doReload : function(component, event, helper){
      location.reload();
    }
  })