package com.hjozaty.app.presentation.home

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.hjozaty.app.domain.model.Hotel
import com.hjozaty.app.domain.model.Province
import com.hjozaty.app.domain.usecase.GetHotelsUseCase
import com.hjozaty.app.domain.usecase.GetProvincesUseCase
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.combine
import kotlinx.coroutines.flow.stateIn
import dagger.hilt.android.lifecycle.HiltViewModel
import javax.inject.Inject

/** Presents a stable, derived home feed without embedding business logic in Compose. */
@HiltViewModel
class HomeViewModel @Inject constructor(getHotels: GetHotelsUseCase, getProvinces: GetProvincesUseCase) : ViewModel() {
    val uiState: StateFlow<HomeUiState> = combine(getHotels(), getProvinces()) { hotels, provinces ->
        HomeUiState.Content(provinces, hotels, hotels.filter(Hotel::isFeatured), hotels.filter(Hotel::isPopular), hotels.filter(Hotel::isRecommended))
    }.stateIn(viewModelScope, SharingStarted.WhileSubscribed(5_000), HomeUiState.Loading)
}

/** Immutable states consumed by [HomeScreen]. */
sealed interface HomeUiState {
    data object Loading : HomeUiState
    data class Content(val provinces: List<Province>, val hotels: List<Hotel>, val featured: List<Hotel>, val popular: List<Hotel>, val recommended: List<Hotel>) : HomeUiState
    data class Error(val message: String) : HomeUiState
}
