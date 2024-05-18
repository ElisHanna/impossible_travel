from django.contrib import admin
from django.urls import path, include
from touring import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
    path('touring/', include('touring.urls')),
    path('', views.index, name='index'),
    path('accounts/', include('django.contrib.auth.urls')),
    path('users/', include('django.contrib.auth.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)