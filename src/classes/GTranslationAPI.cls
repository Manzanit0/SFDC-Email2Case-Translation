/**
 * @author J. G. Manzano
 * @date 17/07/2017 (Created date)
 *
 * @description this class is a small wrapper utility to make calls to the Google Translation API
 */

public with sharing class GTranslationAPI {

    /** API CONSTANTS **/
    //TODO: Move to Custom Metadata both endpoints and API key.
    private static final String API_KEY = 'Here you must enter your own API key';
    private static final String DETECTION_ENDPOINT = 'https://translation.googleapis.com/language/translate/v2/detect';
    private static final String TRANSLATION_ENDPOINT = 'https://translation.googleapis.com/language/translate/v2';

    /** GETTERS **/
    public static String getTranslationEndpoint(){
        return TRANSLATION_ENDPOINT;
    }

    public static String getDetectionEndpoint(){
        return DETECTION_ENDPOINT;
    }

    /** TRANSLATION API METHODS **/
    public static String[] translateTexts(String[] queries, String source, String target){
        try{
            // Build the JSON we will send to the API.
            String body = buildTranslateJsonBody(queries, null, target, 'text');

            // Get the API response JSON.
            String responseBody = translationAPICallout(body, TRANSLATION_ENDPOINT).getBody();

            // Parse the response to get the required information.
            TranslationModel model = (TranslationModel) JSON.deserialize(responseBody, TranslationModel.class);

            // Get the translated texts from the model.
            String[] translations = new String[]{};
            for(Translation translation : model.data.translations){
                translations.add(translation.translatedText);
            }
            return translations;
        }
        catch (Exception e){
            return null;
        }

    }

    public static String[] translateTexts(String[] queries, String target){
        return translateTexts(queries, null, target);
    }

    public static String translateText(String query, String source, String target){
        String[] translations = translateTexts(new String[]{query}, source, target);

         return translations != null && !translations.isEmpty()
                 ? translations[0]
                 : null;
    }

    public static String translateText(String query, String target){
        return translateText(query, null, target);
    }

    private static String buildTranslateJsonBody(String[] queries, String source, String target, String format){
        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        for(String query : queries) gen.writeStringField('q', query);
        if(source != null) gen.writeStringField('source', source);
        if(target != null) gen.writeStringField('target', target);
        gen.writeStringField('format', format);
        gen.writeEndObject();

        return gen.getAsString();
    }

    /** DETECTION API METHODS **/
    public static String[] detectLanguages(String[] queries){
        try{
            String body = buildDetectionJsonBody(queries);

            String responseBody = translationAPICallout(body, DETECTION_ENDPOINT).getBody();

            DetectionModel model = (DetectionModel) JSON.deserialize(responseBody, DetectionModel.class);

            String[] detections = new String[]{};
            for(Detection[] detectionsList : model.data.detections){
                detections.add(detectionsList.get(0).language);
            }

            return detections;  //TODO: Take into account the confidence?
        }
        catch (Exception e){
            return null;
        }
    }

    public static String detectLanguage(String query){
        String[] detections = detectLanguages(new String[]{query});

        return detections != null && !detections.isEmpty()
                ? detections[0]
                : null;
    }

    private static String buildDetectionJsonBody(String[] queries){
        JSONGenerator gen = JSON.createGenerator(true);

        gen.writeStartObject();
        for(String query : queries) gen.writeStringField('q', query);
        gen.writeEndObject();

        return gen.getAsString();
    }

    /** CALLOUT HELPER METHOD **/
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
        public String detectedSourceLanguage;
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