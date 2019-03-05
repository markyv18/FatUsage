using Toybox.WatchUi;
using Toybox.Application as App;
using Toybox.System as Sys;

class FatUsageView extends WatchUi.SimpleDataField {

        // Constants
//        const FAT_BURN_FIELD_ID = 0;

        // Variables
//        hidden var FAT_Burn_Field;
          //'pwf' is per watt filler
        var pwf0_1 = 0.00;
        var pwf1_2 = 0.00;
        var pwf2_3 = 0.00;
        var pwf3_4 = 0.00;
        var pwf4_5 = 0.00;
        var pwf5_6 = 0.00;
        var pwf6_7 = 0.00;

        var pwr = 0;

        var watt_fat = {};

        var FAT_burn = 0;

        var counter = 0;

        var FAT_0 = 0.009;
        // FAT cals per second calculated as 65 g/day div 24 hrs div 60 min *9(FAT joules per gram) div 60sec then rounded up a tad for athlete metabolism
        var FAT_1 = 0;
        var FAT_2 = 0;
        var FAT_3 = 0;
        var FAT_4 = 0;
        var FAT_5 = 0;
        var FAT_6 = 0;
        var FAT_7 = 0;

        var WATT_0 = 0;
        var WATT_1 = 0;
        var WATT_2 = 0;
        var WATT_3 = 0;
        var WATT_4 = 0;
        var WATT_5 = 0;
        var WATT_6 = 0;
        var WATT_7 = 0;

    function initialize() {
        SimpleDataField.initialize();

        // importing values from mobile/desktop interface
        FAT_1 = App.getApp().getProperty("FAT_1").toFloat();
        WATT_1 = App.getApp().getProperty("WATT_1").toNumber();
        FAT_2 = App.getApp().getProperty("FAT_2").toFloat();
        WATT_2 = App.getApp().getProperty("WATT_2").toNumber();
        FAT_3 = App.getApp().getProperty("FAT_3").toFloat();
        WATT_3 = App.getApp().getProperty("WATT_3").toNumber();
        FAT_4 = App.getApp().getProperty("FAT_4").toFloat();
        WATT_4 = App.getApp().getProperty("WATT_4").toNumber();
        FAT_5 = App.getApp().getProperty("FAT_5").toFloat();
        WATT_5 = App.getApp().getProperty("WATT_5").toNumber();
        FAT_6 = App.getApp().getProperty("FAT_6").toFloat();
        WATT_6 = App.getApp().getProperty("WATT_6").toNumber();
        FAT_7 = App.getApp().getProperty("FAT_7").toFloat();
        WATT_7 = App.getApp().getProperty("WATT_7").toNumber();


// iteration 2: filter out null values here and build logic to only use the ones we have
// then offer 8 or 9 data points? never can have too few and will let the filtering take care of the too many

        //converting grams per minute to calories per second
        FAT_1 = (FAT_1 * 9 / 60);
        FAT_2 = (FAT_2 * 9 / 60);
        FAT_3 = (FAT_3 * 9 / 60);
        FAT_4 = (FAT_4 * 9 / 60);
        FAT_5 = (FAT_5 * 9 / 60);
        FAT_6 = (FAT_6 * 9 / 60);
        FAT_7 = (FAT_7 * 9 / 60);

        //Calculating the per watt calorie increments between each submitted value
        pwf0_1 = (FAT_1 - FAT_0) / (WATT_1 - WATT_0);
        pwf1_2 = (FAT_2 - FAT_1) / (WATT_2 - WATT_1);
        pwf2_3 = (FAT_3 - FAT_2) / (WATT_3 - WATT_2);
        pwf3_4 = (FAT_4 - FAT_3) / (WATT_4 - WATT_3);
        pwf4_5 = (FAT_5 - FAT_4) / (WATT_5 - WATT_4);
        pwf5_6 = (FAT_6 - FAT_5) / (WATT_6 - WATT_5);
        pwf6_7 = (FAT_7 - FAT_6) / (WATT_7 - WATT_6);


        // the below loops build out the hash/dictionary that links a wattage value to a corresponding fat burn rate 0:.009, 1:.0456, 2:.0472... cal

        watt_fat.put(WATT_7, FAT_7);

        counter = (WATT_1 - WATT_0);

        for(var i = 0; i < counter; i ++)
            {
            watt_fat.put( (WATT_0 + i), FAT_0 );
            FAT_0 = FAT_0 + pwf0_1;
            }

        counter = (WATT_2 - WATT_1);

        for(var i = 0; i < counter; i ++)
            {
            watt_fat.put( (WATT_1 + i), FAT_1 );
            FAT_1 = FAT_1 + pwf1_2;
            }

        counter = (WATT_3 - WATT_2);

        for(var i = 0; i < counter; i ++)
            {
            watt_fat.put( (WATT_2 + i), FAT_2 );
            FAT_2 = FAT_2 + pwf2_3;
            }

        counter = (WATT_4 - WATT_3);

        for(var i = 0; i < counter; i ++)
            {
            watt_fat.put( (WATT_3 + i), FAT_3 );
            FAT_3 = FAT_3 + pwf3_4;
            }

        counter = (WATT_5 - WATT_4);

        for(var i = 0; i < counter; i ++)
            {
            watt_fat.put( (WATT_4 + i), FAT_4 );
            FAT_4 = FAT_4 + pwf4_5;
            }

        counter = (WATT_6 - WATT_5);

        for(var i = 0; i < counter; i ++)
            {
            watt_fat.put( (WATT_5 + i), FAT_5 );
            FAT_5 = FAT_5 + pwf5_6;
            }

        counter = (WATT_7 - WATT_6);

        for(var i = 0; i < counter; i ++)
            {
            watt_fat.put( (WATT_6 + i), FAT_6 );
            FAT_6 = FAT_6 + pwf6_7;
            }

        label = "Fat cals";
    }

    function compute(info) {
        //Have we started?
        if (info.elapsedTime > 0) {
            // Is Power > 0, if not normalize to 0
            if (info.currentPower == null) {
                // Power data is null
                pwr = 0;
            }
            else if (info.currentPower < 0) {
                // Power data is below 0
                pwr = 0;
            }
            else if (info.currentPower > WATT_7) {
            	// Power data is above last known wattage hash/dictionary key - above this further contribution to power output comes from carbohydrate (and a little bit of lactate)
				pwr = WATT_7;
            }
            else {
                // Incoming power data is OK! You've got the pow-wuh! https://www.youtube.com/watch?v=Cf_qfX9cKsQ Seriously, watch that, you're welcome.
                pwr = info.currentPower;
            }
        FAT_burn = FAT_burn + watt_fat.get(pwr);
        }

        else {
            // Initial display, before the the session is started
            return 0;
        }

		// For testing purposes in the simulator change '.currentPower to '.elapsedTime/1000' this will mock wattage inputs

        return FAT_burn;
    }
}
