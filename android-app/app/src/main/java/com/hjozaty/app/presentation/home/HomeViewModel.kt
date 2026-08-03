package com.hjozaty.app.presentation.home

import androidx.lifecycle.ViewModel
import com.hjozaty.app.domain.usecase.GetHotelsUseCase
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

@HiltViewModel
class HomeViewModel @Inject constructor(getHotels: GetHotelsUseCase) : ViewModel() {
    val hotels = getHotels()
}
