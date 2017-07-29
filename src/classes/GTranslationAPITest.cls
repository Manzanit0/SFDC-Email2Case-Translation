/**
 * @author J. G. Manzano
 * @date 28/07/2017 (Created date)
 *
 * @description test class for GTranslationAPI.
 */

@IsTest(IsParallel = true)
private class GTranslationAPITest {

    @IsTest
    private static void testSingleTranslation() {
        Test.setMock(HttpCalloutMock.class, new GoogleTranslationMock(true));

        String translation;
        Test.startTest();
            translation = GTranslationAPI.translateText('test query','en');
        Test.stopTest();

        System.assertNotEquals(null, translation);
    }

    @IsTest
    private static void testMultipleTranslation() {
        Test.setMock(HttpCalloutMock.class, new GoogleTranslationMock(false));

        String[] translations;
        Test.startTest();
            translations = GTranslationAPI.translateTexts(new String[]{'test 1', 'test 2'}, 'en');
        Test.stopTest();

        System.assertEquals(2, translations.size());
    }

    @IsTest
    private static void testInvalidTranslationCallout() {
        Test.setMock(HttpCalloutMock.class, new GoogleTranslationMock(true));

        String translation;
        Test.startTest();
            translation = GTranslationAPI.translateText(null, 'en');
        Test.stopTest();

        System.assertEquals(null, translation);
    }

    @IsTest
    private static void testSingleDetection(){
        Test.setMock(HttpCalloutMock.class, new GoogleDetectionMock());

        String detections;
        Test.startTest();
            detections = GTranslationAPI.detectLanguage('test query');
        Test.stopTest();

        System.assertNotEquals(null, detections);
    }

    @IsTest
    private static void testMultipleDetections(){
        Test.setMock(HttpCalloutMock.class, new GoogleDetectionMock());

        String[] detections;
        Test.startTest();
            detections = GTranslationAPI.detectLanguages(new String[]{'test 1', 'test 2'});
        Test.stopTest();

        System.assertNotEquals(null, detections);
        System.assertEquals(2, detections.size());
    }

    @IsTest
    private static void testInvalidDetectionCallout(){
        Test.setMock(HttpCalloutMock.class, new GoogleDetectionMock());

        String detections;
        Test.startTest();
            detections = GTranslationAPI.detectLanguage(null);
        Test.stopTest();

        System.assertEquals(null, detections);
    }
}