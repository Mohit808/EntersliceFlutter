package com.enterslice.enterslice;


import static com.enterslice.enterslice.Utills.initDb;
import static com.enterslice.enterslice.Utills.localRef;

import android.content.BroadcastReceiver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.database.Cursor;
import android.location.Location;
import android.os.Bundle;

import java.util.Calendar;

public class MyLocationReceiver extends BroadcastReceiver {


    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("Location in receiver  "+intent.getExtras());
        initDb(context);
        Bundle bundle = intent.getExtras();
        if (bundle != null) {
            Object location = bundle.get("location");
            if(location==null){
                return;
            }
            Calendar calendar=Calendar.getInstance();
            int hour12hrs = calendar.get(Calendar.HOUR);
            int minutes = calendar.get(Calendar.MINUTE);
            int seconds = calendar.get(Calendar.SECOND);

            Location location1= (Location) location;
            ContentValues contentValues=new ContentValues();
            contentValues.put("latitude",String.valueOf(location1.getLatitude()));
            contentValues.put("longitude",String.valueOf(location1.getLongitude()));
            contentValues.put("time", ""+hour12hrs+":"+minutes+":"+seconds);
            long insert = localRef.insert("location", null, contentValues);
            System.out.println(insert);
        }
    }
}
