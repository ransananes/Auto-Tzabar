package com.ransan.auto_tzabar

import io.flutter.app.FlutterApplication
//import io.flutter.plugins.androidalarmmanager.AlarmService
//import io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin
//import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;


class Application : FlutterApplication(), io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback {

    override fun onCreate() {
        super.onCreate()
      //   AlarmService.setPluginRegistrant(this)
    }

    override fun registerWith(registry: io.flutter.plugin.common.PluginRegistry) {
      //  AndroidAlarmManagerPlugin.registerWith(
             //   registry.registrarFor("io.flutter.plugins.androidalarmmanager.AndroidAlarmManagerPlugin"))

    }
}