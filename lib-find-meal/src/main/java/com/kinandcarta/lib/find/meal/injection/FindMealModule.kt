package com.kinandcarta.lib.find.meal.injection

import android.content.Context
import com.google.android.gms.location.FusedLocationProviderClient
import dagger.Module
import dagger.Provides
import dagger.hilt.InstallIn
import dagger.hilt.android.components.FragmentComponent
import dagger.hilt.android.qualifiers.ActivityContext

@Module
@InstallIn(FragmentComponent::class)
class FindMealModule {

    companion object {
        @Provides
        fun provideFusedLocationClient(@ActivityContext context: Context) =
            FusedLocationProviderClient(context)
    }
}