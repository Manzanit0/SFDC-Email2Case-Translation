/**
 * @author J. G. Manzano
 * @date 17/07/2017 (Created date)
 *
 * @description this class is a small wrapper utility to make calls to the Google Translation API
 */

public with sharing class GTranslationAPI {

    //TODO: Move to Custom Metadata both endpoints and API key.
    private static final String API_KEY = 'Here you must enter your own API key';
    private static final String DETECTION_ENDPOINT = 'https://translation.googleapis.com/language/translate/v2/detect';
    private static final String TRANSLATION_ENDPOINT = 'https://translation.googleapis.com/language/translate/v2';

    //TODO: Adapt the method to accept String[] queries.
    public static String translateText(String query, String source, String target){
        // Build the JSON we will send to the API.
        String body = buildTranslateJsonBody(query, source, target, 'text');

        // Get the API response JSON.
        String responseBody = translationAPICallout(body, TRANSLATION_ENDPOINT).getBody();

        // Parse the response to get the required information.
        TranslationModel model = (TranslationModel) JSON.deserialize(responseBody, TranslationModel.class);
        return model.data.translations[0].translatedText;
    }

    //TODO: Adapt the method to accept String[] queries.
    public static String detectLanguate(String query){
        String body = buildDetectionJsonBody(query);

        String responseBody = translationAPICallout(body, DETECTION_ENDPOINT).getBody();

        DetectionModel model = (DetectionModel) JSON.deserialize(responseBody, DetectionModel.class);
        return model.data.detections.get(0).get(0).language; //TODO: Take into account the confidence?
    }

    private static String buildTranslateJsonBody(String query, String source, String target, String format){
        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        gen.writeStringField('q', query);
        gen.writeStringField('source', source);
        gen.writeStringField('target', target);
        gen.writeStringField('format', format);
        gen.writeEndObject();

        return gen.getAsString();
    }

    private static String buildDetectionJsonBody(String query){
        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        gen.writeStringField('q', query);
        gen.writeEndObject();

        return gen.getAsString();
    }

    private static HttpResponse translationAPICallout(String body, String endpoint){
        // Instantiate a new http object
        Http h = new Http();

        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint + '?key=' + API_KEY);
        req.setMethod('POST');
        req.setBody(body);

        // Send the request, and return a response
        HttpResponse res = h.send(req);
        return res;
    }

    /** MODELS TO PARSE API JSONS **/
    private class TranslationModel {
        public Data data;
    }

    private class Translation {
        public String translatedText;
    }

    private class DetectionModel {
        public Data data;
    }

    private class Data {
        public List<List<Detection>> detections;
        public Translation[] translations;
    }

    private class Detection {
        public String language;
        public Boolean isReliable;
        public Decimal confidence;
    }
}