public class INDICATOR_Service {

    public static List<String> getFieldsToQueryForObject(String obj) {
        Set<String> targetFields = new Set<string>();
        for(Indicator_Badge__mdt mdtr : [SELECT Related_Field__r.QualifiedApiName FROM Indicator_Badge__mdt WHERE Object__r.QualifiedApiName=:obj]){
            targetFields.add(mdtr.Related_Field__r.QualifiedApiName);
        }
        return new List<string>(targetFields);
    }

    public static List<indicator> getIndicatorBadgesForObject(SObject sobj){
        List<Indicator> recordIndicators = new List<Indicator>();
        for(Indicator_Badge__mdt mdtr :[SELECT MasterLabel, Badge_Color__c, Badge_Icon_Name__c, Comparison_Type__c, Comparison_Value__c,Object__r.QualifiedApiName, Related_Field__r.QualifiedApiName FROM Indicator_Badge__mdt WHERE Object__r.QualifiedApiName=:sobj.getSObjectType().getDescribe().getName()]){
            recordIndicators.add(evaluateIndicator(mdtr,sobj));
        }
        return recordIndicators;
    }

    public class Indicator{
        @AuraEnabled public String icon {get;set;}
        @AuraEnabled public String color {get;set;}
        @AuraEnabled public String label {get;set;}
        Indicator(String icon, String color, String label){
            this.icon=icon;
            this.color=color;
            this.label=label;
        }
    }

    private static Indicator evaluateIndicator(Indicator_Badge__mdt badge, SObject sobj){
        Object field=sobj.get(badge.Related_Field__r.QualifiedApiName);
        Boolean isEnabled=false;
        
        if(badge.Comparison_Type__c=='Use Boolean Value of Field'){
            isEnabled = (Boolean)field;
        }else if(badge.Comparison_Type__c=='Contains'){
            isEnabled = String.valueOf(field).contains(badge.Comparison_Value__c);
        }else if(badge.Comparison_Type__c=='Not Blank or Null'){
            isEnabled = String.isNotBlank(String.valueOf(field));
        }else if(badge.Comparison_Type__c=='Greater or Equal'){
            isEnabled = (Decimal)field >= Decimal.valueOf(badge.Comparison_Value__c);
        }else if(badge.Comparison_Type__c=='Less or Equal'){
            isEnabled = (Decimal)field <= Decimal.valueOf(badge.Comparison_Value__c);
        }

        if(isEnabled)
            return new Indicator(badge.Badge_Icon_Name__c, badge.Badge_Color__c, badge.MasterLabel);
        else
            return null; 
    }
}
