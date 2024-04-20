from django.contrib import admin
from .models import Area, Commodity, Direction, Hotel, Tour #, Entertaiment

admin.site.register(Area)
admin.site.register(Commodity)
admin.site.register(Direction)
#admin.site.register(Entertaiment)
admin.site.register(Hotel)
admin.site.register(Tour)
