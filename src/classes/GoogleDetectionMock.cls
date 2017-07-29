/**
 * @author J. G. Manzano
 * @date 29/07/2017 (Created date)
 *
 * @description HTTP mock for GTranslationAPI unit test callouts.
 */

public with sharing class GoogleDetectionMock implements HttpCalloutMock {

    public HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        System.assert(req.getEndpoint().contains(GTranslationAPI.getDetectionEndpoint()));
        System.assertEquals('POST', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"data":{"detections":[' +
                '[{"confidence":0.394001841545105,"isReliable":false,"language":"en"}],' +
                '[{"confidence":0.2831689417362213,"isReliable":false,"language":"en"}]]}}');
        res.setStatusCode(200);
        return res;
    }

}