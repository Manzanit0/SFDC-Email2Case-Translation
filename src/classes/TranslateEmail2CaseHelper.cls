/**
 * @author J. G. Manzano
 * @date 17/07/2017 (Created date)
 *
 * @description Helper class for the TranslateEmail2Case trigger.
 */

public with sharing class TranslateEmail2CaseHelper {

    @future(callout=true)
    public static void translateEmailBody(Set<String> caseIds){
        Case[] cases = [SELECT Id, Description FROM Case WHERE Id IN: caseIds];

        //TODO: Make this bulk-friendly -> One Callout for all the needed translations. Check GTranslationAPI.cls.
        for(Case item :  cases){
            // Callout Google Translation API.
            String language = GTranslationAPI.detectLanguate(item.Description);
            String translation = GTranslationAPI.translateText(item.Description, language, 'en');

            // Update the case fields with the translation.
            item.Original_Email__c = item.Description;
            item.Translated_Email__c = translation;
        }

        update cases;
    }
}