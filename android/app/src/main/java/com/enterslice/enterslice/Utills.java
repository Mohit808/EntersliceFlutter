package com.enterslice.enterslice;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;

public class Utills {
    public static DatabaseHelper databaseHelper;
    public static SQLiteDatabase localRef;
    public static void initDb(Context context){
        databaseHelper=new DatabaseHelper(context,DatabaseHelper.DATABASE_NAME,null, DatabaseHelper.DATABASE_VERSION);
        localRef=databaseHelper.getWritableDatabase();
    }
}
