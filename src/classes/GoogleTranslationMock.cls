/**
 * @author J. G. Manzano
 * @date 28/07/2017 (Created date)
 *
 * @description HTTP mock for GTranslationAPI unit test callouts.
 */

public with sharing class GoogleTranslationMock implements HttpCalloutMock {

    private Boolean isSingleTranslation;

    public GoogleTranslationMock(Boolean isSingleTranslation){
        this.isSingleTranslation = isSingleTranslation;
    }

    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assert(req.getEndpoint().contains(GTranslationAPI.getTranslationEndpoint()));
        System.assertEquals('POST', req.getMethod());

        if(this.isSingleTranslation)
            return prepareSingleTranslationResponse();
        else
            return prepareMultipleTranslationResponse();
    }

    private static HttpResponse prepareSingleTranslationResponse(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data":{"translations":[{"translatedText":"El rápido zorro marrón saltó sobre el perro perezoso."}]}}');
        res.setStatusCode(200);
        return res;
    }

    private static HttpResponse prepareMultipleTranslationResponse(){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data":{"translations":[' +
                '{"translatedText":"El rápido zorro marrón saltó sobre el perro perezoso.",' +
                '"detectedSourceLanguage":"en"},' +
                '{"translatedText":"Ella sabe lo que sabe, pero no sé lo que solía saber.",' +
                '"detectedSourceLanguage":"en"}]}}');
        res.setStatusCode(200);
        return res;
    }
}