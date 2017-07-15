/**
 * @author J. G. Manzano
 * @date 17/07/2017 (Created date)
 *
 * @description translates any incoming cases from the email2case feature by using the GCP Translation API.
 */

trigger TranslateEmail2Case on Case (after insert) {

    Set<String> emailCaseIds = new Set<String>();
    for(Case item : (Case[]) Trigger.new){
        // TODO: Check if the email really comes from an email2case.
        emailCaseIds.add(item.Id);
    }
    
    TranslateEmail2CaseHelper.translateEmailBody(emailCaseIds);
}