from django.contrib import admin
from .models import Area, Commodity, Direction, Hotel, Tour , Entertaiment, Profile

admin.site.register(Commodity)
admin.site.register(Direction)

@admin.register(Area)
class AreaAdmin(admin.ModelAdmin):
    list_display = ('name', 'direction')
    list_filter = ['direction']
    
@admin.register(Entertaiment)
class EntertaimentAdmin(admin.ModelAdmin):
    list_display = ('name', 'cost')
    list_filter = ['area']

@admin.register(Hotel)
class HotelAdmin(admin.ModelAdmin):
    list_display = ('name', 'area', 'cost_per_night')
    list_filter = ['area']

@admin.register(Tour)
class TourAdmin(admin.ModelAdmin):
    list_display = ('tourist', 'hotel', 'checkin_date', 'checkout_date', 'cost', 'id')
    list_filter = ('tourist', 'hotel')

@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'date_of_birth', 'photo')