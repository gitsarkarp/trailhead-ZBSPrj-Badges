public with sharing class INDICATOR_Controller {
    private static SObject sobj;
    @AuraEnabled
    public static string getSObjectLabel(String sObjName){
        try {
            String Label=Schema.getGlobalDescribe().get(sObjName).getDescribe().getLabel();
            return Label;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void getSObject(String recId, String objName){
        try {
            List<String> fields=INDICATOR_Service.getFieldsToQueryForObject(objName);
            if(fields.size()>0){
                String dbQuery='SELECT Id, ' + String.join(fields,',') + ' FROM ' + objName + ' WHERE Id=\'' + recId + '\' LIMIT 1';
                List<SObject> results = database.query(dbQuery);
                if(results.size()==1){
                    sobj=results[0];
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<INDICATOR_Service.Indicator> getIndicators(String recId, String objName){
        try {
            getSObject(recId, objName);
            if(sobj!=null){
                return INDICATOR_Service.getIndicatorBadgesForObject(sobj);
            }else{
                return null;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
