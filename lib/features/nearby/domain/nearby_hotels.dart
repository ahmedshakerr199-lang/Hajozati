import 'dart:math'; import '../../../core/location/location_service.dart'; import '../../hotels/domain/entities/hotel.dart';
class NearbyHotel { const NearbyHotel(this.hotel,this.distanceKm); final Hotel hotel; final double distanceKm; }
enum NearbyRange { all, km5, km10, km25, km50 }
class CalculateDistanceUseCase { double call(UserLocation a,double lat,double lng){const r=6371.0; final dLat=_rad(lat-a.latitude),dLng=_rad(lng-a.longitude); final h=sin(dLat/2)*sin(dLat/2)+cos(_rad(a.latitude))*cos(_rad(lat))*sin(dLng/2)*sin(dLng/2); return 2*r*atan2(sqrt(h),sqrt(1-h));} double _rad(double v)=>v*pi/180; }
