from django.urls import path, re_path
from . import views

urlpatterns = [
    path('', views.index, name='index'),
    re_path(r'^directions/$', views.DirectionListView.as_view(), name='directions'),
    re_path(r'^direction/(?P<pk>\d+)$', views.DirectionDetailView.as_view(), name='direction-detail'),
    re_path(r'^areas/$', views.AreaListView.as_view(), name='areas'),
    re_path(r'^area/(?P<pk>\d+)$', views.AreaDetailView.as_view(), name='area-detail'),
    re_path(r'^hotels/$', views.HotelListView.as_view(), name='hotels'),
    re_path(r'^hotel/(?P<pk>\d+)$', views.HotelDetailView.as_view(), name='hotel-detail'),
    re_path(r'^mytours/$', views.BookedToursByUserListView.as_view(), name='my-tours'),
]